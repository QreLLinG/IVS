# ============================================
# ЛАБОРАТОРНАЯ РАБОТА №3
# Составление расписания экзаменов методом программирования в ограничениях
# ============================================

# Фрагмент 1: Установка библиотеки (раскомментировать при первом запуске в Colab)
# !pip install python-constraint -q

# Фрагмент 2: Импорт библиотек
import random
from constraint import Problem, AllDifferentConstraint, BacktrackingSolver
from collections import defaultdict
import time

# ============================================
# Фрагмент 3: Генерация случайных данных
# ============================================

def generate_random_exams(num_exams=13, num_groups=3, num_teachers=4):
    """
    Генерация случайных входных данных
    num_exams: количество экзаменов
    num_groups: количество групп
    num_teachers: количество преподавателей
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
# Фрагмент 5: Создание задачи и добавление переменных
# ============================================

def create_problem(exams, max_days=7):
    """
    Создание задачи CP и добавление переменных
    max_days: максимальное количество дней
    """
    problem = Problem(BacktrackingSolver())
    days = list(range(1, max_days + 1))
    
    # Переменные: день для каждого экзамена
    for exam in exams:
        problem.addVariable(exam['name'], days)
    
    print(f"\nСоздана задача с {len(exams)} переменными")
    print(f"Домены переменных: дни 1..{max_days}")
    
    return problem, days

# ============================================
# Фрагмент 6: Добавление группового ограничения
# ============================================

def add_group_constraints(problem, exams):
    """Добавление ограничения: у одной группы не может быть двух экзаменов в один день"""
    groups_dict = defaultdict(list)
    for exam in exams:
        groups_dict[exam['group']].append(exam['name'])
    
    print("\nДобавление групповых ограничений:")
    print("-"*40)
    
    for group, exam_list in groups_dict.items():
        if len(exam_list) > 1:
            problem.addConstraint(AllDifferentConstraint(), exam_list)
            print(f"  Группа {group}: экзамены {', '.join(exam_list)} — все в разные дни")
        else:
            print(f"  Группа {group}: только один экзамен — ограничение не требуется")

# ============================================
# Фрагмент 7: Добавление преподавательского ограничения
# ============================================

def add_teacher_constraints(problem, exams):
    """Добавление ограничения: преподаватель не может принимать два экзамена одновременно"""
    teachers_dict = defaultdict(list)
    for exam in exams:
        teachers_dict[exam['teacher']].append(exam['name'])
    
    print("\nДобавление преподавательских ограничений:")
    print("-"*40)
    
    for teacher, exam_list in teachers_dict.items():
        if len(exam_list) > 1:
            problem.addConstraint(AllDifferentConstraint(), exam_list)
            print(f"  Преподаватель {teacher}: экзамены {', '.join(exam_list)} — все в разные дни")
        else:
            print(f"  Преподаватель {teacher}: только один экзамен — ограничение не требуется")

# ============================================
# Фрагмент 8: Добавление временного ограничения
# ============================================

def add_time_constraints(problem, exams, days, hours_per_day=8):
    """Добавление ограничения: суммарная длительность экзаменов в день не более hours_per_day часов"""
    print(f"\nДобавление временных ограничений (≤ {hours_per_day} часов в день):")
    print("-"*40)
    
    for day in days:
        def day_constraint(*args, day=day, exams=exams):
            total = 0
            for i, d in enumerate(args):
                if d == day:
                    total += exams[i]['duration']
            return total <= hours_per_day
        
        problem.addConstraint(day_constraint, [exam['name'] for exam in exams])
    
    print(f"  Добавлено ограничение для каждого из {len(days)} дней")
    print(f"  Суммарная длительность экзаменов в день ≤ {hours_per_day} часов")

# ============================================
# Фрагмент 9: Решение задачи
# ============================================

def solve_schedule(problem, exams, max_days):
    """Решение задачи расписания"""
    print(f"\n{'='*60}")
    print("ПОИСК РЕШЕНИЯ")
    print(f"{'='*60}")
    
    start_time = time.time()
    solutions = problem.getSolutions()
    elapsed_time = time.time() - start_time
    
    print(f"Время выполнения: {elapsed_time:.2f} секунд")
    print(f"Найдено решений: {len(solutions)}")
    
    if solutions:
        # Выбираем решение с минимальным количеством дней
        best_solution = min(solutions, key=lambda s: max(s.values()))
        best_days = max(best_solution.values())
        print(f"Оптимальное количество дней: {best_days}")
        return best_solution, elapsed_time, best_days
    else:
        print("❌ РЕШЕНИЕ НЕ НАЙДЕНО!")
        return None, elapsed_time, None

# ============================================
# Фрагмент 10: Вывод расписания
# ============================================

def print_schedule(solution, exams):
    """Вывод расписания в удобном формате"""
    if not solution:
        print("Нет решения для отображения")
        return
    
    # Группировка по дням
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
# Фрагмент 11: Статистика и проверка ограничений
# ============================================

def print_statistics(solution, exams, groups, teachers, elapsed_time, best_days):
    """Вывод статистики и проверка соблюдения ограничений"""
    if not solution:
        print("Нет решения для анализа")
        return
    
    # Группировка по дням
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
    
    # ===== ПРОВЕРКА ОГРАНИЧЕНИЙ =====
    print(f"\n{'='*60}")
    print("ПРОВЕРКА СОБЛЮДЕНИЯ ОГРАНИЧЕНИЙ")
    print(f"{'='*60}")
    
    # Проверка 1: групповое ограничение
    group_violation = False
    for g in groups:
        exam_days = [solution[e['name']] for e in exams if e['group'] == g]
        if len(exam_days) != len(set(exam_days)):
            group_violation = True
            print(f"  ❌ Группа {g}: нарушение (экзамены в один день)")
    if not group_violation:
        print(f"  ✓ Групповое ограничение: СОБЛЮДАЕТСЯ")
    
    # Проверка 2: преподавательское ограничение
    teacher_violation = False
    for t in teachers:
        exam_days = [solution[e['name']] for e in exams if e['teacher'] == t]
        if len(exam_days) != len(set(exam_days)):
            teacher_violation = True
            print(f"  ❌ Преподаватель {t}: нарушение (экзамены в один день)")
    if not teacher_violation:
        print(f"  ✓ Преподавательское ограничение: СОБЛЮДАЕТСЯ")
    
    # Проверка 3: временное ограничение
    time_violation = False
    for day in schedule:
        total_hours = sum(e['duration'] for e in schedule[day])
        if total_hours > 8:
            time_violation = True
            print(f"  ❌ День {day}: {total_hours} часов (максимум 8)")
    if not time_violation:
        print(f"  ✓ Временное ограничение (≤8 часов): СОБЛЮДАЕТСЯ")
    
    # Дополнительная информация
    total_hours_all = sum(e['duration'] for e in exams)
    theoretical_min = (total_hours_all + 7) // 8
    
    print(f"\n{'='*60}")
    print("ДОПОЛНИТЕЛЬНАЯ ИНФОРМАЦИЯ")
    print(f"{'='*60}")
    print(f"  Суммарная длительность всех экзаменов: {total_hours_all} часов")
    print(f"  Теоретический минимум дней: {theoretical_min}")
    print(f"  Фактическое количество дней: {best_days}")
    print(f"  Время выполнения: {elapsed_time:.2f} секунд")

# ============================================
# Фрагмент 12: Итоговое заключение
# ============================================

def print_conclusion(best_days, theoretical_min, elapsed_time, num_exams, num_groups, num_teachers):
    """Вывод итогового заключения"""
    print(f"\n{'='*60}")
    print("ЗАКЛЮЧЕНИЕ")
    print(f"{'='*60}")
    
    if best_days == theoretical_min:
        print(f"✅ Задача успешно решена методом программирования в ограничениях")
        print(f"✅ Количество экзаменов: {num_exams}")
        print(f"✅ Количество групп: {num_groups}")
        print(f"✅ Количество преподавателей: {num_teachers}")
        print(f"✅ Получено идеальное расписание на {best_days} дней")
        print(f"✅ Результат совпадает с теоретическим минимумом ({theoretical_min} дней)")
        print(f"✅ Все ограничения соблюдены")
        print(f"✅ Время решения: {elapsed_time:.2f} секунд")
        print(f"\n📌 В отличие от типичного случая, когда расписание занимает на 1-2 дня больше")
        print(f"   теоретического минимума из-за конфликтующих ограничений, в данной работе")
        print(f"   было получено идеальное расписание, полностью совпадающее с нижней границей.")
    else:
        print(f"✅ Задача успешно решена методом программирования в ограничениях")
        print(f"✅ Количество экзаменов: {num_exams}")
        print(f"✅ Количество групп: {num_groups}")
        print(f"✅ Количество преподавателей: {num_teachers}")
        print(f"✅ Получено расписание на {best_days} дней")
        print(f"✅ Теоретический минимум: {theoretical_min} дней")
        print(f"✅ Все ограничения соблюдены")
        print(f"✅ Время решения: {elapsed_time:.2f} секунд")
    
    print(f"\n{'='*60}")

# ============================================
# ОСНОВНАЯ ПРОГРАММА
# ============================================

def main():
    print("\n" + "="*60)
    print("ЛАБОРАТОРНАЯ РАБОТА №3")
    print("ПРОГРАММИРОВАНИЕ В ОГРАНИЧЕНИЯХ")
    print("СОСТАВЛЕНИЕ РАСПИСАНИЯ ЭКЗАМЕНОВ")
    print("="*60)
    
    # Параметры задачи
    num_exams = 13
    num_groups = 3
    num_teachers = 4
    max_days = 7
    hours_per_day = 8
    
    # Фрагмент 3: Генерация данных
    exams, groups, teachers = generate_random_exams(num_exams, num_groups, num_teachers)
    
    # Фрагмент 4: Просмотр данных
    print_exams_list(exams)
    
    # Фрагмент 5: Создание задачи
    problem, days = create_problem(exams, max_days)
    
    # Фрагмент 6: Групповые ограничения
    add_group_constraints(problem, exams)
    
    # Фрагмент 7: Преподавательские ограничения
    add_teacher_constraints(problem, exams)
    
    # Фрагмент 8: Временные ограничения
    add_time_constraints(problem, exams, days, hours_per_day)
    
    # Фрагмент 9: Решение задачи
    solution, elapsed_time, best_days = solve_schedule(problem, exams, max_days)
    
    if solution:
        # Фрагмент 10: Вывод расписания
        print_schedule(solution, exams)
        
        # Фрагмент 11: Статистика
        print_statistics(solution, exams, groups, teachers, elapsed_time, best_days)
        
        # Фрагмент 12: Заключение
        total_hours = sum(e['duration'] for e in exams)
        theoretical_min = (total_hours + 7) // 8
        print_conclusion(best_days, theoretical_min, elapsed_time, num_exams, num_groups, num_teachers)
    else:
        print("\n❌ Задача не имеет решения при заданных параметрах")
        print("   Рекомендации: увеличить max_days или уменьшить количество экзаменов")

# Запуск программы
if __name__ == "__main__":
    main()