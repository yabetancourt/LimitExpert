
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
derivada(C, _, 0) :- number(C), !.
derivada(X, X, 1) :- atomic(X), !.
derivada(X, _, 0) :- atomic(X).

% Derivadas de funciones trigonometricas
derivada(sen(X), _, 0) :- number(X), !.
derivada(sen(X), X, cos(X)) :- atomic(X), !.
derivada(sen(X), Y, cos(X) * DF) :- derivada(X,Y,DF).

derivada(cos(X), _, 0) :- number(X), !.
derivada(cos(X), X, -sen(X)) :- atomic(X), !.
derivada(cos(X), Y, -sen(X) * DF) :- derivada(X,Y,DF).

derivada(tan(X), _, 0):- number(X), !.
derivada(tan(X), X, 1 / cos(X) ^ 2) :- atomic(X), !.
derivada(tan(X), Y, (1 / cos(X) ^ 2) * DF) :- derivada(X, Y, DF).

derivada(ln(X), _, 0) :- number(X), !.
derivada(ln(X), X, 1/X) :- atomic(X), !.
derivada(ln(X), Y, (1 / X) * DF) :- derivada(X, Y, DF).

derivada(cot(X), _, 0) :- number(X), !.
derivada(cot(X), X, -(1 / sen(X) ^ 2)) :- atomic(X), !.
derivada(cot(X), Y, -(1 / (sen(X) ^ 2))*DF) :- derivada(X, Y, DF).

derivada(csc(X), _, 0) :- number(X), !.
derivada(csc(X), X, -(cot(X) * csc(X))) :- atomic(X), !.
derivada(csc(X), Y, -(cot(X) * csc(X)) * DF) :- derivada(X, Y, DF).

derivada(sec(X), _, 0) :- number(X), !.
derivada(sec(X), X, tan(X) * sec(X)) :- atomic(X), !.
derivada(sec(X), Y, tan(X) * sec(X) * DF) :- derivada(X, Y, DF).

derivada(arcsen(X), _, 0) :- number(X), !.
derivada(arcsen(X), X, 1 / ((1 - (X ^ 2)) ^ (1 / 2))) :- atomic(X), !.
derivada(arcsen(X), Y, DF * 1 / ((1 - (X ^ 2)) ^ (1 / 2))) :- derivada(X, Y, DF).

derivada(arccos(X), _, 0) :- number(X), !.
derivada(arccos(X), X, -(1 / ((1 - (X ^ 2)) ^ (1 / 2)))) :- atomic(X), !.
derivada(arccos(X), Y, -(1 / ((1 - (X ^ 2)) ^ (1 / 2))) * DF) :- derivada(X, Y, DF).

derivada(arctan(X), _, 0) :- number(X), !.
derivada(arctan(X), X, 1 / (1 + X ^ 2)) :- atomic(X), !.
derivada(arctan(X), Y, DF * 1/(1 + X ^ 2)) :- derivada(X, Y, DF).

derivada(arccot(X), _, 0) :- number(X), !.
derivada(arccot(X), X, -(1 / (1 + (X ^ 2)))) :- atomic(X), !.
derivada(arccot(X), Y, -(1 / (1 + (X ^ 2))) * DF) :- derivada(X, Y, DF).

derivada(senh(X), _, 0) :- number(X), !.
derivada(senh(X), X, cosh(X)) :- atomic(X), !.
derivada(senh(X), Y, cosh(X) * DF) :- derivada(X, Y, DF).

derivada(cosh(X), _, 0) :- number(X), !.
derivada(cosh(X), X, senh(X)) :- atomic(X), !.
derivada(cosh(X), Y, senh(X) * DF):- derivada(X, Y, DF).

derivada(tanh(X), _, 0) :- number(X), !.
derivada(tanh(X), X, 1 / (cosh(X) ^ 2)) :- atomic(X), !.
derivada(tanh(X), Y, DF * 1 / (cosh(X) ^ 2)) :- derivada(X, Y, DF).

derivada(coth(X), _, 0) :- number(X), !.
derivada(coth(X), X, -(1 / (senh(X) ^ 2))) :- atomic(X), !.
derivada(coth(X), Y, -(1 / (senh(X) ^ 2)) * DF) :- derivada(X, Y, DF).

% Reglas para derivar operaciones
derivar_oper(+, _, _, DA, DB, DA + DB).
derivar_oper(-, _, _, DA, DB, DA - DB).
derivar_oper(*, A, B, DA, DB, DA * B + A * DB).
derivar_oper(/, A, B, DA, DB, (DA * B - A * DB) / (B * B)).
derivar_oper(^, A, B, DA, _, B * A ^ (B - 1) * DA).
derivar_oper(log, B, _, _, DA, D) :-
                  (DA = 0, D = 0, !);
                  D = 1 / (DA * ln(B)).

