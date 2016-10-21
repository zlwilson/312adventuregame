	/* Layout of board:
	   ___ ___ ___
	  |_0_|_1_|_2_|
	  |_3_|_4_|_5_|	start = 4
	  |END|_6_|_7_|
	  |_8_|_9_|_10|
	  
	*/

:- dynamic i_am_at/1, at/2, holding/1, equipped/1, level/1, random/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

i_am_at(4).

equippedList(dl([],[])).

path(4, n, 1).
path(4, s, 6).
path(4, e, 5).
path(4, w, 3).
path(4, ne, 2).
path(4, nw, 0).
path(4, se, 7).
path(4, sw, end).

path(end, n, 3).
path(end, e, 6).
path(end, s, 8).
path(end, ne, 4).
path(end, se, 9).

path(0, e, 1).
path(0, s, 3).
path(0, se, 4).

path(1, w, 0).
path(1, e, 2).
path(1, s, 4).
path(1, se, 5).
path(1, sw, 3).

path(2, w, 1).
path(2, s, 5).
path(2, sw, 4).

path(3, n, 0).
path(3, s, end).
path(3, e, 4).
path(3, ne, 1).
path(3, se, 6).

path(5, n, 2).
path(5, s, 7).
path(5, w, 4).
path(5, nw, 1).
path(5, sw, 6).

path(6, n, 4).
path(6, s, 9).
path(6, e, 7).
path(6, w, end).
path(6, nw, 3).
path(6, sw, 8).
path(6, ne, 5).
path(6, se, 10).

path(7, n, 5).
path(7, s, 10).
path(7, w, 6).
path(7, nw, 4).
path(7, sw, 9).

path(8, n, end).
path(8, e, 9).
path(8, ne, 6).

path(9, n, 6).
path(9, w, 10).
path(9, e, 9).
path(9, nw, end).
path(10, ne, 7).

path(10, n, 7).
path(10, w, 9).
path(8, nw, 6).


/* list all objects and their locations */

at(brisk, 0).
at(quesadilla, 1).
at(sword_a_thousand_truths, 2).
at(meat_sweats, 3).
at(charlie_horse, 4).
at(aight, 2).
at(pool, end).
at(dont_touch_me, 6).
at(tha_shiznit, 7).
at(straps, 8).
at(gats, 9).
at(herbs, 10).
at(david, 0).

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
value(david, 9001).

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
	retract(equipped(X)),
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
	assert(equipped(X)),
	write('You are now equipped with '), write(X), nl,
	directions(X).

unequip(X) :-
	retract(equipped(X)),
	write('You are now unequipped with '), write(X), nl,
	!, nl.

directions(X) :-
	move(X, 0),
	write('You can move n, e, s, w'), nl.

directions(X) :-
	move(X, 1),
	write('You can move ne, nw, se, sw'), nl.

look :-
	i_am_at(P),
	describe(P),
	nl,
	notice_objects_at(P),
	nl.

david :-
	moveDavid(X),
	at(david, X),
	write('David is at '), write(X), nl.

moveDavid(X) :- 
	at(david, Y),
	retract(at(david, Y)),
	X is random(10),
	assert(at(david, X)).

/* Print out objects around you */

notice_objects_at(P) :-
	at(X, P),
	write('There is a '), write(X), write(' here.'), nl,
	fail.

notice_objects_at(_).

addtoequip(E,dl(L1,L2),dl([E|L1])).

/* Directions and moving */

n :-
	equipped(X),
	move(X,0),
	go(n).

s :-
	equipped(X),
	move(X,0),
	go(s).

e :-
	equipped(X),
	move(X,0),
	go(e).

w :-
	equipped(X),
	move(X,0),
	go(w).

ne :-
	equipped(X),
	move(X,1),
	go(ne).

nw :-
	equipped(X),
	move(X,1),
	go(nw).

se :-
	equipped(X),
	move(X,1),
	go(se).

sw :-
	equipped(X),
	move(X,1),
	go(sw).


go(D) :-
	i_am_at(H),
	path(H, D, T),
	retract(i_am_at(H)),
	assert(i_am_at(T)),
	!, look.

go(_) :- write('You can''t go that way.').

win :-
	holding(david),
	i_am_at(end),
	write('You got David to the Pool(e)!'), nl,
    finish.

finish :-
	nl,
	write('The game is over. Please enter the "halt." command.'),
	nl.


instructions :-
	nl,
	write('Welcome to a mountain in Peru!'), nl,
	write('Your name is Kevin the Explorer,'), nl,
	write('And your quest is to find the David and get it to the Pool(e).'), nl,
	write('This is the layout of the world: '), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('Enter commands using standard Prolog syntax.'), nl,
	write('Available commands are:'), nl,
	write('start.             -- to start the game.'), nl,
	write('You can equip objects as you go that allow you to move, and to change the directions allowed:'), nl,
	write('n.  s.  e.  w.     -- to go in that direction when you are equipped with certain items.'), nl,
	write('ne.  nw.  se.  sw. -- to go in that direction when you are equipped with certain items.'), nl,
	write('take(Object).      -- to pick up an object.'), nl,
	write('drop(Object).      -- to put down an object.'), nl,
	write('equip(Object).     -- to equip an item.'), nl,
	write('unequip(Object).   -- to unequip an item.'), nl,
	write('david.			  -- where is david now...'), nl,
	write('look.              -- to look around you again.'), nl,
	write('look.              -- to look around you again.'), nl,
	write('instructions.      -- to see this message again.'), nl,
	write('halt.              -- to end the game and quit.'), nl,
	nl.


/* This rule prints out instructions and tells where you are. */

start :-
	instructions,
	look.


/* Describe each room. */

describe(0) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|_X_|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl.
describe(1) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|_X_|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl.
describe(2) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|_X_|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl.
describe(3) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|_X_|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl.
describe(4) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|_X_|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl.
describe(2) :-
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
	write('|___|___|___|'), nl,
	write('Wow this room is really wet...'), nl.
describe(6) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|_X_|___|'), nl,
	write('|___|___|___|'), nl.
describe(7) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|_X_|'), nl,
	write('|___|___|___|'), nl.
describe(8) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|_X_|___|___|'), nl.
describe(9) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|_X_|___|'), nl.
describe(10) :-
	write('You are here:'), nl,
	write(' ___ ___ ___'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|___|'), nl,
	write('|___|___|_X_|'), nl.

