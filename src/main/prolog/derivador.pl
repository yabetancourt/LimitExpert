
:- use_module(simplificador, [simplificar/2]).

derivar(F, X, DF) :-
    derivada(F, X, D),
    simplificar(D, DF).

% Regla para derivar una expresión algebraica
derivada(F, X, DF) :-
    F =.. [Op, A, B], % Descomponer la expresión en dos términos
    derivada(A, X, DA),
    derivada(B, X, DB),
    derivar_oper(Op, A, B, DA, DB, DF). % Aplicar la regla de derivación para la operación

% Derivadas constantes y simples
derivada(C, _, 0) :- number(C).
derivada(X, X, 1) :- atomic(X).

% Reglas para derivar operaciones
derivar_oper(+, _, _, DA, DB, DA+DB).
derivar_oper(-, _, _, DA, DB, DA-DB).
derivar_oper(*, A, B, DA, DB, DA*B+A*DB).
derivar_oper(/, A, B, DA, DB, (DA*B-A*DB)/(B*B)).
derivar_oper(^, A, B, DA, _, B*A^(B-1)*DA).
