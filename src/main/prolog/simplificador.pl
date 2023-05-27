
:- module(simplificador, [simplificar/2]).

% Reglas para simplificar expresiones
simplificar(X, X) :- atomic(X), !.

simplificar(F, S) :-
    F =.. [Op, A, B],
    simplificar(A, SA),
    simplificar(B, SB),
    simplificar_oper(Op, SA, SB, S), !.

simplificar(X, X).

% Reglas para simplificar operaciones%


simplificar_oper(+, A, B + C, S) :-
    (number(A), number(B), R is A + B, simplificar_oper(+, R, C, S), !);
    (number(C), number(B), R is C + B, simplificar_oper(+, R, A, S), !);
    (number(A), number(C), R is C + A, simplificar_oper(+, R, B, S), !);
    simplificar_oper(+, A, B, A + B + C).

simplificar_oper(+, A + B, C, S) :-
    (number(B), number(C), R is B + C, simplificar_oper(+, R, A, S), !);
    (number(A), number(C), R is A + C, simplificar_oper(+, R, B, S), !);
    (number(A), number(B), R is A + B, simplificar_oper(+, R, C, S), !);
    simplificar_oper(+, B, C, A + B + C).

simplificar_oper(*, A, B * C, S) :-
    (number(A), number(B), R is A * B, simplificar_oper(*, R, C, S), !);
    (number(C), number(B), R is B * C, simplificar_oper(*, R, A, S), !);
    (number(A), number(C), R is A * C, simplificar_oper(*, R, B, S), !);
    simplificar_oper(*, A, B, A * B * C).

simplificar_oper(*, A * B, C, S) :-
    (number(B), number(C), R is B * C, simplificar_oper(*, R, A, S), !);
    (number(A), number(C), R is A * C, simplificar_oper(*, R, B, S), !);
    (number(A), number(B), R is A * B, simplificar_oper(*, R, C, S), !);
    simplificar_oper(*, A, B, A * B * C ).

simplificar_oper(-, A, B + C, S) :-
    (number(A), number(B), R is A - B, R > 0, simplificar_oper(+, R, C, S), !);
    (number(A), number(B), R is A - B, R < 0, simplificar_oper(-, C, R, S), !);
    (number(A), number(B), R is A - B, R =:= 0, S = C, !);
    (number(A), number(C), R is A + C, simplificar_oper(-, R, B, S), !);
    (number(B), number(C), R is -B + C, R > 0, simplificar_oper(+, R, A, S), !);
    (number(B), number(C), R is -B + C, R < 0, simplificar_oper(-, A, R, S), !);
    (number(B), number(C), R is -B + C, R =:= 0, S = A, !);
    simplificar_oper(-, A, B, A - B + C).

simplificar_oper(-, A + B, C, S) :-
    (number(A), number(B), R is A + B, simplificar_oper(-, R, C, S), !);
    (number(A), number(C), R is A - C, R > 0, simplificar_oper(+, R, B, S), !);
    (number(A), number(C), R is A - C, R < 0, simplificar_oper(-, B, R, S), !);
    (number(A), number(C), R is A - C, R =:= 0, S = B, !);
    (number(B), number(C), R is B - C, R > 0, simplificar_oper(+, R, A, S), !);
    (number(B), number(C), R is B - C, R < 0, simplificar_oper(-, A, R, S), !);
    (number(B), number(C), R is B - C, R =:= 0, S = A, !);
    simplificar_oper(+, A, B, A + B - C).

simplificar_oper(-, A, B - C, S) :-
    (number(A), number(B), R is A - B, R > 0, simplificar_oper(-, R, C, S), !);
    (number(A), number(B), R is A - B, R < 0, S = -R - C, !);
    (number(A), number(B), R is A - B, R =:= 0, S = - C, !);
    (number(A), number(C), R is A - C, R > 0, simplificar_oper(-, R, B, S), !);
    (number(A), number(C), R is A - C, R < 0, S = -A - R, !);
    (number(A), number(C), R is A - C, R =:= 0, S = -B, !);
    (number(B), number(C), R is B + C, simplificar_oper(-, A, R, S));
    simplificar_oper(-, A, B, A - B - C).

simplificar_oper(-, A - B, C, S) :-
    (number(A), number(B), R is A - B, R > 0, simplificar_oper(-, R, C, S), !);
    (number(A), number(B), R is A - B, R < 0, S = -R - C, !);
    (number(A), number(B), R is A - B, R =:= 0, S = - C, !);
    (number(A), number(C), R is A - C, R > 0, simplificar_oper(-, R, B, S), !);
    (number(A), number(C), R is A - C, R < 0, S = -A - R, !);
    (number(A), number(C), R is A - C, R =:= 0, S = -B, !);
    (number(B), number(C), R is B + C, simplificar_oper(-, A, R, S));
    simplificar_oper(-, A, B, A - B - C).
simplificar_oper(-, A, -B, S):-
    (simplificar_oper(+, A, B, S)).

simplificar_oper(-, A, B, S) :-
    (number(B), number(A), S is A - B, !);
    (number(A), A =:= 0, S = -B, !);
    (number(B), B =:= 0, S = A, !);
    (S = A - B).


simplificar_oper(+, 0, B, B).

simplificar_oper(+, A, 0, A).

simplificar_oper(+, X, X, 2 * X).

simplificar_oper(+, X, -Y, S):-
    (simplificar_oper(-, X, Y, S)).

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
    (number(A), A =:= 0, S = B, !);
    (number(B), B =:= 0, S = A, !);
    (S = A + B).

simplificar_oper(-, A, A, 0).


simplificar_oper(*, 0, _, 0).

simplificar_oper(*, _, 0, 0).

simplificar_oper(*, 1, B, B).

simplificar_oper(*, A, 1, A).

simplificar_oper(*, A, B, S) :-
    (number(B), number(A), S is A * B, !);
    (A = -AX, B = -BX, S = AX * BX, !);
    (A = -AX, S = -(AX * B), !);
    (B = -BX, S = -(A * BX), !);
    (S = A * B).

simplificar_oper(/, A, A, 1).
simplificar_oper(/, 0, _, 0).

simplificar_oper(/, A, B, S) :-
    (number(A), number(B), S is A / B, !);
    (A = -AX, B = -BX, S = AX / BX, !);
    (A = -AX, S = -(AX / B), !);
    (B = -BX, S = -(A / BX), !);
    S = A / B.

simplificar_oper(^, _, 0, 1).
simplificar_oper(^, A, 1, A).
simplificar_oper(^, 0, _, 0).
simplificar_oper(^, 1, _, 1).

simplificar_oper(^, A, B, S) :-
     (number(A), number(B), S is A^B , !);
     (S = A^B).
