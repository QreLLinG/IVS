student(anna, group_101).
student(peter, group_101).
student(ivan, group_102).
student(maria, group_102).
student(olga, group_103).
student(sergey, group_103).

knows(X, Y) :-
    student(X, Group),
    student(Y, Group),
    X \= Y.
