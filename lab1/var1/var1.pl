% variant1.pl
% Lab 1: Facts and Rules
% Variant 1

% Facts
dog(flash).
dog(rover).
cat(butsy).
horse(star).

black(flash).
brown(butsy).
ginger(rover).
white(star).

% Rules
pet(X) :- dog(X).
pet(X) :- cat(X).

animal(X) :- pet(X).
animal(X) :- horse(X).

owner(tom, X) :- dog(X), \+ black(X).
owner(kate, X) :- horse(X).
owner(kate, X) :- black(X).
