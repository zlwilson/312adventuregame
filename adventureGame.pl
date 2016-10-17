:- dynamic i_am_at/1, at/2, holding/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

i_am_at(start).

path(start, n, 0.1).
path(start, s, 2.1).
path(start, e, 1.2).
path(start, w, 1.0).

path(end, n, 1.0).
path(end, e, 2.1).
path(end, s, 3.0).

path(0.0, e, 0.1).
path(0.0, s, 1.0).

path(0.1, w, 0.0).
path(0.1, e, 0.2).
path(0.1, s, start).

path(0.2, w, 0.1).
path(0.2, s, 1.2).

path(1.0, n, 0.0).
path(1.0, s, end).
path(1.0, e, start).

path(1.2, n, 0.2).
path(1.2, s, 2.2).
path(1.2, w, start).

path(2.1, n, start).
path(2.1, s, 3.1).
path(2.1, e, 2.2).
path(2.1, w, end).

path(2.2, n, 1.2).
path(2.2, s, 3.2).
path(2.2, w, 2.1).

path(3.0, n, end).
path(3.0, e, 3.1).

path(3.1, n, 2.1).
path(3.1, w, 3.2).
path(3.1, e, 3.1).

path(3.2, n, 2.2).
path(3.2, w, 3.1).


/* list all objects and their locations */

at(brisk, 0.0).
at(quesadilla, 0.1).
at(sword_a_thousand_truths, 0.2).
at(meat_sweats, 1.0).
at(charlie_horse, start).
at(aight, 1.2).
at(trophy, end).
at(forbidden_hoot, 2.1).
at(tha_shiznit, 2.2).
at(straps, 3.0).
at(gats, 3.1).
at(herbs, 3.2).

value(brisk, 1).
value(quesadilla, 1).
value(sword_a_thousand_truths, 10).
value(meat_sweats, -8).
value(charlie_horse, -2).
value(aight, 2).
value(trophy, 50).
value(forbidden_hoot, -10).
value(tha_shiznit, 7).
value(straps, 3).
value(gats, 4).
value(herbs, 12).


/* These rules describe actions with object. */

take(X) :-
	holding(X),
	write('You''re already holding that!'),
	!, nl.

take(X) :-
	i_am_at(Place),
	at(X, Place),
	retract(at(X, Place)),
	assert(holding(X)),
	write('OK.'),
	value(X,I),
	b_setval(level, level + I),
	!, nl.

take(_) :-
	write('I don''t see it here.'),
	nl.

drop(X) :-
	holding(X),
	i_am_at(Place),
	retract(holding(X)),
	assert(at(X, Place)),
	write('OK, item dropped.'),
	!, nl.

drop(_) :-
	write('You aren''t holding that!'),
	nl.

look :-
	i_am_at(Place),
	describe(Place),
	nl,
	notice_objects_at(Place),
	nl.


/* These rules set up a loop to print out all the objects
in your vicinity. */

notice_objects_at(Place) :-
	at(X, Place),
	write('There is a '), write(X), write(' here.'), nl,
	fail.

notice_objects_at(_).


/* These rules define the direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).

go(Direction) :-
	i_am_at(Here),
	path(Here, Direction, There),
	retract(i_am_at(Here)),
	assert(i_am_at(There)),
	!, look.

go(_) :- write('You can''t go that way.').


/* This rule tells how to look about you. */

look :-
	i_am_at(Place),
	describe(Place),
	nl.

win :-
    finish
	i_am_at(2.0),
	holding(brisk),
	holding(quesadilla),
	holding(meat_sweats).

die :- finish.

finish :-
	nl,
	write('The game is over. Please enter the "halt." command.'),
	nl.


/* This rule just writes out game instructions. */

instructions :-
	nl,
	write('Welcome to a mountain in Peru!'), nl,
	write('Your name is David the Explorer,'), nl,
	write('And your quest is to find the Pool(e).'), nl,
	write('This is the layout of the world'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|_X_|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('You are starting your adventure at the x'), nl,
	write('Enter commands using standard Prolog syntax.'), nl,
	write('Available commands are:'), nl,
	write('start.             -- to start the game.'), nl,
	write('n.  s.  e.  w.     -- to go in that direction.'), nl,
	write('take(Object).      -- to pick up an object.'), nl,
	write('drop(Object).      -- to put down an object.'), nl,
	write('look.              -- to look around you again.'), nl,
	write('instructions.      -- to see this message again.'), nl,
	write('halt.              -- to end the game and quit.'), nl,
	nl.


/* This rule prints out instructions and tells where you are. */

start :-
	instructions,
	look.


/* Describe each room. */

describe(0.0) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|_X_|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl.
describe(0.1) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|_X_|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl.
describe(0.2) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|_X_|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl.
describe(1.0) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|_X_|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl.
describe(start) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|_X_|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl.
describe(1.2) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|_X_|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl.
describe(end) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|_X_|___|___|'), nl,
	write('|___|___|___|'), nl.
describe(2.1) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|_X_|___|'), nl,
	write('|___|___|___|'), nl.
describe(2.2) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|_X_|'), nl,
	write('|___|___|___|'), nl.
describe(3.0) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|_X_|___|___|'), nl.
describe(3.1) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|_X_|___|'), nl.
describe(3.2) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|_X_|'), nl.

