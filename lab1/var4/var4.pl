mary_loves(peaches).
mary_loves(corn).
mary_loves(apples).

beth_loves(X) :-
    mary_loves(X),
    fruit(X),
    color(X, red).

beth_loves(X) :-
    mary_loves(X),
    X = corn.

fruit(peaches).
fruit(apples).

color(peaches, yellow).
color(apples, red).
color(apples, yellow).
color(oranges, orange).
