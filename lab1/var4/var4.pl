loves(mary, peaches).
loves(mary, corn).
loves(mary, apples).

fruit(peaches).
fruit(apples).

color(peaches, yellow).
color(apples, red).
color(apples, yellow).
color(oranges, orange).
loves(beth, X) :- 
    loves(mary, X), 
    fruit(X), 
    color(X, red).

loves(beth, X) :- 
    loves(mary, X), 
    X = corn.

% ----- ЗАПРОСЫ -----

% 1. Что любит Бет?
?- loves(beth, What).
What = apples ;
What = corn.

% 2. Любит ли Мэри кукурузу?
?- loves(mary, corn).
true.

% 3. Какие фрукты известны?
?- fruit(X).
X = peaches ;
X = apples.

% 4. Только красные фрукты (исправленный запрос)
?- loves(mary, Fruit), loves(beth, Fruit), fruit(Fruit), color(Fruit, red).
Fruit = apples.
