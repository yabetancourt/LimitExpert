:- module(derivador,[derivar/4]).
:- use_module(simplificador, [simplificar/2]).

derivar(F, X, DF, Pasos) :-
    derivada(F, X, D, Pasos),
    simplificar(D, DF).

derivada(F, X, DF, Pasos) :-
    F =.. [Op, A, B], % Descomponer la expresión en dos tÃ©rminos
    derivada(A, X, DA, Pasos1),
    derivada(B, X, DB, Pasos2),
    derivar_oper(Op, A, B, DA, DB, DF, Pasos3), % Aplicar la regla de derivación para la operación
    append(Pasos1, Pasos2, Aux), append(Aux, Pasos3, Pasos), !. % Agregar los nuevos pasos a la lista de pasos

derivada(C, _, 0, [('Derivada de una constante', 0)]) :- number(C), !.
derivada(X, X, 1, [('Derivada de x', 1)]) :- atom(X), !.
derivada(X, _, 0, [('Derivada de una constante', 0)]) :- atom(X).

% Derivadas de funciones trigonometricas
derivada(sen(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(sen(X), X, cos(X), [('Derivada del seno', cos(X))]) :- atom(X), !.
derivada(sen(X), Y, cos(X) * DF, Pasos) :-
    derivada(X, Y, DF, Pasos1),
    append([('Derivada del seno y Regla de la cadena', cos(X) * DF)], Pasos1, Pasos).

derivada(cos(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(cos(X), X, -sen(X), [('Derivada del coseno', -sen(X))]) :- atom(X), !.
derivada(cos(X), Y, -sen(X) * DF, Pasos) :-
    derivada(X, Y, DF, Pasos1),
    append([('Derivada del coseno y Regla de la cadena', -sen(X) * DF)], Pasos1, Pasos).

derivada(tan(X), _, 0, [('Derivada de una constante', 0)]):- number(X), !.
derivada(tan(X), X, 1 / cos(X) ^ 2, [('Derivada de la tangente', 1 / cos(X) ^ 2)]) :- atom(X), !.
derivada(tan(X), Y, (1 / cos(X) ^ 2) * DF, Pasos) :-
     derivada(X, Y, DF, Pasos1),
     append([('Derivada de la tangente y Regla de la cadena', (1 / cos(X) ^ 2) * DF)], Pasos1, Pasos).

derivada(ln(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(ln(X), X, 1/(X), [('Derivada del logoritmo natural', 1/X)]) :- atom(X), !.
derivada(ln(X), Y, (1 / (X)) * DF, Pasos) :-
   derivada(X, Y, DF, Pasos1),
   append([('Derivada del logaritmo natural y Regla de la cadena', (1 / (X)) * DF)], Pasos1, Pasos).

derivada(log(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(log(X), X, 1 / (X) * ln(10), [('Derivada del logoritmo', 1 / (X) * ln(10))]) :- atom(X), !.
derivada(log(X), Y, (1 / (X)) * ln(10) * DF, Pasos) :-
   derivada(X, Y, DF, Pasos1),
   append([('Derivada del logaritmo y Regla de la cadena', (1 / (X)) * ln(10) * DF)], Pasos1, Pasos).

derivada(cot(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(cot(X), X, -(1 / sen(X) ^ 2), [('Derivada de la cotangente', -(1 / sen(X) ^ 2))]) :- atom(X), !.
derivada(cot(X), Y, -(1 / (sen(X) ^ 2)) * DF, Pasos) :-
    derivada(X, Y, DF, Pasos1),
    append([('Derivada de la cotangente y Regla de la cadena', -(1 / (sen(X) ^ 2)) * DF)], Pasos1, Pasos).

derivada(csc(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(csc(X), X, -(cot(X) * csc(X)), [('Derivada de la cosecante', -(cot(X) * csc(X)))]) :- atom(X), !.
derivada(csc(X), Y, -(cot(X) * csc(X)) * DF, Pasos) :-
    derivada(X, Y, DF, Pasos1),
    append([('Derivada de la cosecante y Regla de la cadena', -(cot(X) * csc(X)) * DF)], Pasos1, Pasos).

derivada(sec(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(sec(X), X, tan(X) * sec(X), [('Derivada de la secante', tan(X) * sec(X))]) :- atom(X), !.
derivada(sec(X), Y, tan(X) * sec(X) * DF, Pasos) :-
    derivada(X, Y, DF, Pasos1),
    append([('Derivada de la secante y Regla de la cadena', tan(X) * sec(X) * DF)], Pasos1, Pasos).

derivada(arcsen(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(arcsen(X), X, 1 / ((1 - (X ^ 2)) ^ (1 / 2)), [('Derivada del arcoseno', 1 / ((1 - (X ^ 2)) ^ (1 / 2)))]) :- atom(X), !.
derivada(arcsen(X), Y, DF * 1 / ((1 - (X ^ 2)) ^ (1 / 2)), Pasos) :-
    derivada(X, Y, DF, Pasos1),
    append([('Derivada del arcoseno y Regla de la cadena', DF * 1 / ((1 - (X ^ 2)) ^ (1 / 2)))], Pasos1, Pasos).

derivada(arccos(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(arccos(X), X, -(1 / ((1 - (X ^ 2)) ^ (1 / 2))), [('Derivada del arcocoseno',-(1 / ((1 - (X ^ 2)) ^ (1 / 2))))]) :- atom(X), !.
derivada(arccos(X), Y, -(1 / ((1 - (X ^ 2)) ^ (1 / 2))) * DF, Pasos) :-
    derivada(X, Y, DF, Pasos1),
    append([('Derivada del arcocoseno y Regla de la cadena', -(1 / ((1 - (X ^ 2)) ^ (1 / 2))) * DF)], Pasos1, Pasos).

derivada(arctan(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(arctan(X), X, 1 / (1 + X ^ 2), [('Derivada del arcotangente', 1 / (1 + X ^ 2))]) :- atom(X), !.
derivada(arctan(X), Y, DF * 1/(1 + X ^ 2), Pasos) :-
    derivada(X, Y, DF, Pasos1),
    append([('Derivada del arcotangente y Regla de la cadena', DF * 1/(1 + X ^ 2))], Pasos1, Pasos).

derivada(arccot(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(arccot(X), X, -(1 / (1 + (X ^ 2))), [('Derivada del arcocotangente', -(1 / (1 + (X ^ 2))))]) :- atom(X), !.
derivada(arccot(X), Y, -(1 / (1 + (X ^ 2))) * DF, Pasos) :-
    derivada(X, Y, DF, Pasos1),
    append([('Derivada del arcocotangente y Regla de la cadena', -(1 / (1 + (X ^ 2))) * DF)], Pasos1, Pasos).

derivada(senh(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(senh(X), X, cosh(X), [('Derivada del seno hiperbólico', cosh(X))]) :- atom(X), !.
derivada(senh(X), Y, cosh(X) * DF, Pasos) :-
    derivada(X, Y, DF, Pasos1),
    append([('Derivada del seno hiperbólico y Regla de la cadena', -(1 / (1 + (X ^ 2))) * DF)], Pasos1, Pasos).

derivada(cosh(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(cosh(X), X,  senh(X), [('Derivada del coseno hiperbólico', senh(X))]) :- atom(X), !.
derivada(cosh(X), Y, senh(X) * DF, Pasos):-
    derivada(X, Y, DF, Pasos1),
    append([('Derivada del coseno hiperbólico y Regla de la cadena', -(1 / (1 + (X ^ 2))) * DF)], Pasos1, Pasos).

derivada(tanh(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(tanh(X), X, 1 / (cosh(X) ^ 2), [('Derivada de la tangente hiperbólica', 1 / (cosh(X) ^ 2))]) :- atom(X), !.
derivada(tanh(X), Y, DF * 1 / (cosh(X) ^ 2), Pasos) :-
    derivada(X, Y, DF, Pasos1),
    append([('Derivada de la tangente hiperbólica y Regla de la cadena', DF * 1 / (cosh(X) ^ 2))], Pasos1, Pasos).

derivada(coth(X), _, 0, [('Derivada de una constante', 0)]) :- number(X), !.
derivada(coth(X), X, -(1 / (senh(X) ^ 2)), [('Derivada de la tangente hiperbólica'),-(1 / (senh(X) ^ 2))]) :- atom(X), !.
derivada(coth(X), Y, -(1 / (senh(X) ^ 2)) * DF,Pasos) :-
    derivada(X, Y, DF, Pasos1),
    append([('Derivada de la cotangente hiperbólica y Regla de la cadena', -(1 / (senh(X) ^ 2)) * DF)], Pasos1, Pasos).

derivar_oper(+, _, _, DA, DB, DA + DB, [('Suma de derivadas', DA + DB)]).
derivar_oper(-, _, _, DA, DB, DA - DB, [('Resta de derivadas', DA - DB)]).
derivar_oper(*, A, B, DA, DB, DA * B + A * DB, [('Regla del producto', DA * B + A * DB)]).
derivar_oper(/, A, B, DA, DB, (DA * B - A * DB) / (B * B),  [('Regla del cociente', (DA * B - A * DB) / (B * B))]).
derivar_oper(^, A, B, DA, DB, D, PasosActualizados) :-
    (number(A), number(B), D = 0, !, PasosActualizados = [('Derivada de constante', 0)]);
    (number(B), D = B * A ^ (B - 1) * DA, !, PasosActualizados = [('Regla de la potencia', B * A ^ (B - 1) * DA)]);
    (number(A), D = A ^ B * DB, !, PasosActualizados = [('Regla de la potencia', A ^ B * DB)]);
    (D = e ^ (B * ln(A)) * (1 / A * DA * B + ln(A) * DB), PasosActualizados = [('Regla de la potencia', e ^ (B * ln(A)) * (1 / A * DA * B + ln(A) * DB))]).

%Otros
regla_derivacion("Regla de la suma: d[f(x)+g(x)] = f'(x)+g'(x)").
regla_derivacion("Regla de la resta: d[f(x)-g(x)] = f'(x)-g'(x)").
regla_derivacion("Regla de una constante por una función: d[k*f(x)] = k*f'(x)").
regla_derivacion("Regla de la multiplicación: d[f(x)*g(x)] = f'(x)*g(x)+f(x)*g'(x)").
regla_derivacion("Regla de la división: d[f(x)/g(x)] = (f'(x)*g(x)-f(x)*g'(x))/[g(x)]^2").
regla_derivacion("Regla de la cadena(función compuesta): d(f[g(x)]) = f'[g(x)]*g'(x)").



