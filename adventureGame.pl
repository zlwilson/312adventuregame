:- dynamic i_am_at/1, at/2, holding/1, equipped/1, level/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

i_am_at(start).

equippedList(dl([],[])).

path(start, n, 0.1).
path(start, s, 2.1).
path(start, e, 1.2).
path(start, w, 1.0).
path(start, ne, 0.2).
path(start, nw, 0.0).
path(start, se, 2.2).
path(start, sw, end).

path(end, n, 1.0).
path(end, e, 2.1).
path(end, s, 3.0).
path(end, ne, start).
path(end, se, 3.1).

path(0.0, e, 0.1).
path(0.0, s, 1.0).
path(0.0, se, start).

path(0.1, w, 0.0).
path(0.1, e, 0.2).
path(0.1, s, start).
path(0.1, se, 1.2).
path(0.1, sw, 1.0).

path(0.2, w, 0.1).
path(0.2, s, 1.2).
path(0.2, sw, start).

path(1.0, n, 0.0).
path(1.0, s, end).
path(1.0, e, start).
path(1.0, ne, 0.1).
path(1.0, se, 2.1).

path(1.2, n, 0.2).
path(1.2, s, 2.2).
path(1.2, w, start).
path(1.2, nw, 0.1).
path(1.2, sw, 2.1).

path(2.1, n, start).
path(2.1, s, 3.1).
path(2.1, e, 2.2).
path(2.1, w, end).
path(2.1, nw, 1.0).
path(2.1, sw, 3.0).
path(2.1, ne, 1.2).
path(2.1, se, 3.2).

path(2.2, n, 1.2).
path(2.2, s, 3.2).
path(2.2, w, 2.1).
path(2.2, nw, start).
path(2.2, sw, 3.1).

path(3.0, n, end).
path(3.0, e, 3.1).
path(3.0, ne, 2.1).

path(3.1, n, 2.1).
path(3.1, w, 3.2).
path(3.1, e, 3.1).
path(3.1, nw, end).
path(3.2, ne, 2.2).

path(3.2, n, 2.2).
path(3.2, w, 3.1).
path(3.0, nw, 2.1).


/* list all objects and their locations */

at(brisk, 0.0).
at(quesadilla, 0.1).
at(sword_a_thousand_truths, 0.2).
at(meat_sweats, 1.0).
at(charlie_horse, start).
at(aight, 1.2).
at(trophy, end).
at(dont_touch_me, 2.1).
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
value(dont_touch_me, -15).
value(tha_shiznit, 7).
value(straps, 3).
value(gats, 4).
value(herbs, 12).

/* Movement styles: 0 = regular, 1 = diagonal */

move(brisk, 1).
move(quesadilla, 0).
move(sword_a_thousand_truths, 1).
move(meat_sweats, 1).
move(charlie_horse, 0).
move(aight, 0).
move(tha_shiznit, 1).
move(straps, 0).
move(gats, 1).
move(herbs, 0).


/* Rules for collecting objects */

take(X) :-
	holding(X),
	write('You''re already holding that!'),
	!, nl.

take(dont_touch_me) :-
	write('Sorry, you died!'), nl,
	finish.

take(X) :-
	i_am_at(P),
	at(X, P),
	retract(at(X, P)),
	assert(holding(X)),
	value(X,L),
	assert(level(L)),
	write('OK.'),
	write("your level is changed by"),
	write(L),
	!, nl.

newlevel(X) :-
	nb_getval(level, L),
	write('Old level is: '), write(L), nl,
	value(X, I),
	LNew is L + I,
	nb_setval(level, LNew),
	write('New level is: '), write(LNew), nl.

take(_) :-
	write('I don''t see that here.'),
	nl.

drop(X) :-
	holding(X),
	i_am_at(P),
	retract(holding(X)),
	value(X,L),
	retract(level(L)),
	assert(at(X, P)),
	write('OK, item dropped.'), nl,
	write("Your level is changed by: "),
	write(L),
	!, nl.

drop(_) :-
	write('You aren''t holding that!'),
	nl.

equip(X) :-
	holding(X),
	addtoequip(X, dl(PREV,NEW),dl(PREV,NEW)),
	write('You are now equipped with '), write(X), ln,
	directions(X).

directions(X) :-
	move(X, 0),
	write('You can move n, e, s, w').

directions(X) :-
	move(X, 1),
	write('You can move ne, nw, se, sw').

look :-
	i_am_at(P),
	describe(P),
	nl,
	notice_objects_at(P),
	nl.


/* Print out objects around you */

notice_objects_at(P) :-
	at(X, P),
	write('There is a '), write(X), write(' here.'), nl,
	fail.

notice_objects_at(_).

addtoequip(E,dl(L1,L2),dl([E|L1])).

/* Directions and moving */

n :-
	equip(X),
	move(X,0),
	go(n).

s :-
	equip(X),
	move(X,0),
	go(s).

e :-
	equip(X),
	move(X,0),
	go(e).

w :-
	equip(X),
	move(X,0),
	go(w).

ne :-
	equip(X),
	move(X,1),
	go(ne).

nw :-
	equip(X),
	move(X,1),
	go(nw).

se :-
	equip(X),
	move(X,1),
	go(se).

sw :-
	equip(X),
	move(X,1),
	go(sw).


go(D) :-
	i_am_at(H),
	path(H, D, T),
	retract(i_am_at(H)),
	assert(i_am_at(T)),
	!, look.

go(_) :- write('You can''t go that way.').


/* This rule tells how to look about you. */

lookaround :-
	i_am_at(Place),
	describe(Place),
	nl.

win :-
	level(X),
	X < -14,
	write('You win with '), write(Level), write(' points!'), nl,
    finish,
	i_am_at(2.0).

finish :-
	nl,
	write('The game is over. Please enter the "halt." command.'),
	nl.


instructions :-
	nl,
	write('Welcome to a mountain in Peru!'), nl,
	write('Your name is David the Explorer,'), nl,
	write('And your quest is to find the Pool(e).'), nl,
	write('This is the layout of the world: '), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('Enter commands using standard Prolog syntax.'), nl,
	write('Available commands are:'), nl,
	write('start.             -- to start the game.'), nl,
	write('You can equip objects as you go to change the directions you can move:'), nl,
	write('n.  s.  e.  w.     -- to go in that direction when you are equipped with certain items.'), nl,
	write('ne.  nw.  se.  sw. -- to go in that direction when you are equipped with certain items.'), nl,
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

