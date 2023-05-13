
:- module(simplificador, [simplificar/2]).

% Reglas para simplificar expresiones
simplificar(X, X) :- atomic(X), !.

simplificar(F, S) :-
    F =.. [Op, A, B],
    simplificar(A, SA),
    simplificar(B, SB),
    simplificar_oper(Op, SA, SB, S), !.

simplificar(X, X).

% Reglas para simplificar operaciones
simplificar_oper(+, A, B+C, R+C) :-
    (number(A), number(B), R is A + B, !);
    simplificar_oper(+, A, B, R).

simplificar_oper(+, A+B, C, R+B) :-
    (number(A), number(C), R is A + C, !);
    simplificar_oper(+, A, C, R).

simplificar_oper(+, 0, B, B).

simplificar_oper(+, A, 0, A).

simplificar_oper(+, X, X, 2*X).

simplificar_oper(+, N*X, K*X, S) :-
    (number(N), number(K), Sum is N + K, S = Sum*X, !);
    (S = (N + K) * X, !).

simplificar_oper(+, X, K*X, S) :-
    (number(K), Sum is 1 + K, S = Sum*X, !);
    (S = (1 + K) * X, !).

simplificar_oper(+, N*X, X, S) :-
    (number(N), Sum is 1 + N, S = Sum*X, !);
    (S = (1 + N) * X, !).

simplificar_oper(-, N*X, K*X, S) :-
    (number(N), number(K), Sum is N - K, S = Sum*X, !);
    (S = (N - K) * X, !).

simplificar_oper(-, X, K*X, S) :-
    (number(K), Sum is 1 - K, S = Sum*X, !);
    (S = (1 - K) * X, !).

simplificar_oper(-, N*X, X, S) :-
    (number(N), Sum is N - 1, S = Sum*X, !);
    (S = (N - 1) * X, !).

simplificar_oper(+, A, B, S) :-
    (number(B), number(A), S is A + B , !);
    (S = A + B, !).
    
simplificar_oper(-, A, A, 0).

simplificar_oper(-, A, B, S) :-
    (number(B), number(A), S is A - B);
    (S =.. [-, A, B]), !.

simplificar_oper(*, 0, _, 0).

simplificar_oper(*, _, 0, 0).

simplificar_oper(*, 1, B, B).

simplificar_oper(*, A, 1, A).

simplificar_oper(*, A, B, S) :-
    (number(B), number(A), S is A * B, !);
    (S =.. [*, A, B]), !.

simplificar_oper(/, A, A, 1).

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
