# ============================================
# ЛАБОРАТОРНАЯ РАБОТА №3
# Программирование в ограничениях
# Оптимизация расписания экзаменов (CSP + оптимизация)
# УМЕРЕННАЯ ВЕРСИЯ ДЛЯ GOOGLE COLAB
# ============================================

# Фрагмент 1: Установка библиотеки (раскомментировать при первом запуске в Colab)
# !pip install python-constraint -q

# Фрагмент 2: Импорт библиотек
import random
from constraint import Problem, AllDifferentConstraint, BacktrackingSolver
from collections import defaultdict
import time

# ============================================
# Фрагмент 3: Генерация случайных данных (УМЕРЕННОЕ УВЕЛИЧЕНИЕ)
# ============================================

def generate_random_exams(num_exams=12, num_groups=3, num_teachers=4):
    """
    Генерация случайных входных данных
    num_exams: количество экзаменов (увеличено до 12)
    num_groups: количество групп (3)
    num_teachers: количество преподавателей (увеличено до 4)
    """
    groups = [f"Group_{chr(65+i)}" for i in range(num_groups)]
    teachers = [f"Prof_{i+1}" for i in range(num_teachers)]
    durations = [2, 3]  # длительность экзамена 2 или 3 часа
    
    # Фиксируем seed для воспроизводимости результатов
    random.seed(42)
    
    exams = []
    
    for i in range(num_exams):
        name = f"Exam_{i+1}"
        group = random.choice(groups)
        teacher = random.choice(teachers)
        duration = random.choice(durations)
        exams.append({
            'name': name,
            'group': group,
            'teacher': teacher,
            'duration': duration
        })
    
    print(f"\n{'='*60}")
    print(f"СГЕНЕРИРОВАНЫ ДАННЫЕ")
    print(f"{'='*60}")
    print(f"  Экзаменов: {num_exams}")
    print(f"  Групп: {', '.join(groups)}")
    print(f"  Преподавателей: {', '.join(teachers)}")
    
    return exams, groups, teachers

# ============================================
# Фрагмент 4: Просмотр сгенерированных данных
# ============================================

def print_exams_list(exams):
    """Вывод списка сгенерированных экзаменов"""
    print(f"\n{'='*60}")
    print("СПИСОК СГЕНЕРИРОВАННЫХ ЭКЗАМЕНОВ")
    print(f"{'='*60}")
    print(f"{'№':<3} {'Название':<12} {'Группа':<10} {'Преподаватель':<12} {'Длит.':<5}")
    print("-"*50)
    
    for i, exam in enumerate(exams):
        print(f"{i+1:<3} {exam['name']:<12} {exam['group']:<10} {exam['teacher']:<12} {exam['duration']} ч")

# ============================================
# Фрагмент 5: Создание задачи с заданным количеством дней
# ============================================

def create_problem_for_days(exams, num_days):
    """
    Создание задачи CSP для фиксированного количества дней
    num_days: количество доступных дней
    """
    problem = Problem(BacktrackingSolver())
    days = list(range(1, num_days + 1))
    
    # Переменные
    for exam in exams:
        problem.addVariable(exam['name'], days)
    
    # Групповое ограничение
    groups_dict = defaultdict(list)
    for exam in exams:
        groups_dict[exam['group']].append(exam['name'])
    for exam_list in groups_dict.values():
        if len(exam_list) > 1:
            problem.addConstraint(AllDifferentConstraint(), exam_list)
    
    # Преподавательское ограничение
    teachers_dict = defaultdict(list)
    for exam in exams:
        teachers_dict[exam['teacher']].append(exam['name'])
    for exam_list in teachers_dict.values():
        if len(exam_list) > 1:
            problem.addConstraint(AllDifferentConstraint(), exam_list)
    
    # Временное ограничение
    for day in days:
        def day_constraint(*args, day=day, exams=exams):
            total = 0
            for i, d in enumerate(args):
                if d == day:
                    total += exams[i]['duration']
            return total <= 8
        problem.addConstraint(day_constraint, [exam['name'] for exam in exams])
    
    return problem

# ============================================
# Фрагмент 6: Оптимизация — поиск минимального количества дней
# ============================================

def find_optimal_schedule(exams):
    """
    Поиск оптимального расписания с минимальным количеством дней
    Возвращает лучшее решение и количество дней
    """
    # Вычисляем теоретическую нижнюю границу
    total_hours = sum(exam['duration'] for exam in exams)
    theoretical_min = (total_hours + 7) // 8
    
    # Верхняя граница (в худшем случае — каждый экзамен в свой день)
    upper_bound = len(exams)
    
    print(f"\n{'='*60}")
    print("ОПТИМИЗАЦИЯ — ПОИСК МИНИМАЛЬНОГО КОЛИЧЕСТВА ДНЕЙ")
    print(f"{'='*60}")
    print(f"  Суммарная длительность: {total_hours} часов")
    print(f"  Теоретический минимум: {theoretical_min} дней")
    print(f"  Верхняя граница: {upper_bound} дней")
    
    best_solution = None
    best_days = None
    
    # Перебираем возможное количество дней от нижней до верхней границы
    for num_days in range(theoretical_min, min(upper_bound, 10) + 1):
        print(f"\n  Пробуем {num_days} дней...")
        
        start_time = time.time()
        problem = create_problem_for_days(exams, num_days)
        solutions = problem.getSolutions()
        elapsed = time.time() - start_time
        
        if solutions:
            # Выбираем лучшее решение (минимальное количество использованных дней)
            candidate = min(solutions, key=lambda s: max(s.values()))
            actual_days_used = max(candidate.values())
            print(f"    ✅ РЕШЕНИЕ НАЙДЕНО за {elapsed:.2f} сек")
            print(f"    Фактически использовано дней: {actual_days_used}")
            best_solution = candidate
            best_days = actual_days_used
            break
        else:
            print(f"    ❌ Решений не найдено за {elapsed:.2f} сек")
    
    return best_solution, best_days

# ============================================
# Фрагмент 7: Вывод расписания
# ============================================

def print_schedule(solution, exams):
    """Вывод расписания в удобном формате"""
    if not solution:
        print("Нет решения для отображения")
        return
    
    schedule = defaultdict(list)
    for exam in exams:
        schedule[solution[exam['name']]].append(exam)
    
    print(f"\n{'='*60}")
    print("РАСПИСАНИЕ ЭКЗАМЕНОВ")
    print(f"{'='*60}")
    
    for day in sorted(schedule.keys()):
        total_hours = sum(e['duration'] for e in schedule[day])
        print(f"\n📅 ДЕНЬ {day} (загруженность: {total_hours}/8 часов)")
        print("-"*55)
        print(f"{'Название':<12} {'Группа':<10} {'Преподаватель':<14} {'Длит.':<5}")
        print("-"*55)
        for exam in schedule[day]:
            print(f"{exam['name']:<12} {exam['group']:<10} {exam['teacher']:<14} {exam['duration']} ч")

# ============================================
# Фрагмент 8: Статистика и проверка ограничений
# ============================================

def print_statistics(solution, exams, groups, teachers, best_days):
    """Вывод статистики и проверка соблюдения ограничений"""
    if not solution:
        print("Нет решения для анализа")
        return
    
    schedule = defaultdict(list)
    for exam in exams:
        schedule[solution[exam['name']]].append(exam)
    
    print(f"\n{'='*60}")
    print("СТАТИСТИКА РАСПИСАНИЯ")
    print(f"{'='*60}")
    
    print(f"\n📊 Общее количество дней: {len(schedule)}")
    
    print(f"\n📊 Загруженность по дням:")
    for day in sorted(schedule.keys()):
        hours = sum(e['duration'] for e in schedule[day])
        exams_count = len(schedule[day])
        print(f"   День {day}: {hours} часов, {exams_count} экзаменов")
    
    avg_load = sum(sum(e['duration'] for e in schedule[day]) for day in schedule) / len(schedule)
    print(f"\n📊 Средняя загруженность дня: {avg_load:.1f} часов")
    
    # Проверка ограничений
    print(f"\n{'='*60}")
    print("ПРОВЕРКА СОБЛЮДЕНИЯ ОГРАНИЧЕНИЙ")
    print(f"{'='*60}")
    
    # Групповое ограничение
    group_violation = False
    for g in groups:
        exam_days = [solution[e['name']] for e in exams if e['group'] == g]
        if len(exam_days) != len(set(exam_days)):
            group_violation = True
            print(f"  ❌ Группа {g}: нарушение")
    if not group_violation:
        print(f"  ✓ Групповое ограничение: СОБЛЮДАЕТСЯ")
    
    # Преподавательское ограничение
    teacher_violation = False
    for t in teachers:
        exam_days = [solution[e['name']] for e in exams if e['teacher'] == t]
        if len(exam_days) != len(set(exam_days)):
            teacher_violation = True
            print(f"  ❌ Преподаватель {t}: нарушение")
    if not teacher_violation:
        print(f"  ✓ Преподавательское ограничение: СОБЛЮДАЕТСЯ")
    
    # Временное ограничение
    time_violation = False
    for day in schedule:
        total_hours = sum(e['duration'] for e in schedule[day])
        if total_hours > 8:
            time_violation = True
            print(f"  ❌ День {day}: {total_hours} часов")
    if not time_violation:
        print(f"  ✓ Временное ограничение: СОБЛЮДАЕТСЯ")

# ============================================
# Фрагмент 9: Вывод заключения
# ============================================

def print_conclusion(best_days, theoretical_min, num_exams, num_groups, num_teachers):
    """Вывод итогового заключения"""
    print(f"\n{'='*60}")
    print("ЗАКЛЮЧЕНИЕ")
    print(f"{'='*60}")
    
    if best_days == theoretical_min:
        print(f"✅ Задача комбинаторной оптимизации решена методом CSP")
        print(f"✅ Количество экзаменов: {num_exams}")
        print(f"✅ Количество групп: {num_groups}")
        print(f"✅ Количество преподавателей: {num_teachers}")
        print(f"✅ Получено ОПТИМАЛЬНОЕ решение на {best_days} дней")
        print(f"✅ Результат совпадает с теоретическим минимумом")
        print(f"✅ Все ограничения соблюдены")
    else:
        print(f"✅ Задача комбинаторной оптимизации решена методом CSP")
        print(f"✅ Получено допустимое решение на {best_days} дней")
        print(f"✅ Теоретический минимум: {theoretical_min} дней")
        print(f"✅ Все ограничения соблюдены")

# ============================================
# ОСНОВНАЯ ПРОГРАММА
# ============================================

def main():
    print("\n" + "="*60)
    print("ЛАБОРАТОРНАЯ РАБОТА №3")
    print("ПРОГРАММИРОВАНИЕ В ОГРАНИЧЕНИЯХ")
    print("ЗАДАЧА КОМБИНАТОРНОЙ ОПТИМИЗАЦИИ — РАСПИСАНИЕ ЭКЗАМЕНОВ")
    print("="*60)
    
    # Параметры задачи 
    num_exams = 12      
    num_groups = 3      
    num_teachers = 4    
    
    # Генерация данных
    exams, groups, teachers = generate_random_exams(num_exams, num_groups, num_teachers)
    
    # Просмотр данных
    print_exams_list(exams)
    
    # Оптимизация — поиск минимального количества дней
    total_hours = sum(e['duration'] for e in exams)
    theoretical_min = (total_hours + 7) // 8
    
    solution, best_days = find_optimal_schedule(exams)
    
    if solution:
        # Вывод расписания
        print_schedule(solution, exams)
        
        # Статистика
        print_statistics(solution, exams, groups, teachers, best_days)
        
        # Заключение
        print_conclusion(best_days, theoretical_min, num_exams, num_groups, num_teachers)
    else:
        print("\n❌ Оптимальное решение не найдено")
        print("   Увеличьте верхнюю границу поиска")

if __name__ == "__main__":
    main()
