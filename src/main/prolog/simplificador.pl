
:- module(simplificador, [simplificar/2]).

% Reglas para simplificar expresiones
simplificar(X, X) :- atomic(X), !.

simplificar(F, S) :-
    F =.. [Op, A, B],
    simplificar(A, SA),
    simplificar(B, SB),
    simplificar_oper(Op, SA, SB, S), !.

simplificar(_, 0).

% Reglas para simplificar operaciones
simplificar_oper(+, 0, B, S) :-
    simplificar(B, S), !.

simplificar_oper(+, A, 0, S) :-
    simplificar(A, S), !.

simplificar_oper(+, A, B, S) :-
    simplificar(A, SA),
    simplificar(B, SB),
    (SA = 0, S = SB;
    SB = 0, S = SA;
    number(SB), number(SA), S is SA + SB;
    S =.. [+, SA, SB]), !.

simplificar_oper(-, A, A, 0) :- !.

simplificar_oper(-, A, B, S) :-
    simplificar(A, SA),
    simplificar(B, SB),
    (SA = SB, S = 0;
    number(SB), number(SA), S is SA - SB;
    S =.. [-, SA, SB]), !.

simplificar_oper(*, 0, _, 0) :- !.

simplificar_oper(*, _, 0, 0) :- !.

simplificar_oper(*, 1, B, S) :-
    simplificar(B, S), !.

simplificar_oper(*, A, 1, S) :-
    simplificar(A, S), !.

simplificar_oper(*, A, B, S) :-
    simplificar(A, SA),
    simplificar(B, SB),
    (SA = 0, S = 0;
    SB = 0, S = 0;
    SA = 1, S = SB;
    SB = 1, S = SA;
    number(SB), number(SA), S is SA * SB;
    S =.. [*, SA, SB]), !.

simplificar_oper(/, A, A, 1) :- !.

simplificar_oper(/, A, B, S) :-
    simplificar(A, SA),
    simplificar(B, SB),
    (SA = 0, S = 0;
    SB = 1, S = SA;
    number(SB), number(SA), S is SA / SB;
    S =.. [/, SA, SB]), !.

simplificar_oper(^, _, 0, 1) :- !.

simplificar_oper(^, A, 1, S) :-
    simplificar(A, S), !.

simplificar_oper(^, A, B, S) :-
    simplificar(A, SA),
    simplificar(B, SB),
    (SA = 0, S = 0;
     SB = 0, S = 1;
     SA = 1, S = 1;
     number(SA), number(SB), S is SA^SB;
     S =.. [^, SA, SB]), !.
