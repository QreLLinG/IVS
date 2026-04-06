day_shift(mary).
day_shift(suzy).
day_shift(jane).

evening_shift(sam).
evening_shift(jane).
evening_shift(bob).
evening_shift(patricia).

knows(X, Y) :-
    day_shift(X), day_shift(Y), X \= Y.

knows(X, Y) :-
    evening_shift(X), evening_shift(Y), X \= Y.



