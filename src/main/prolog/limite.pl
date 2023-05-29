:- set_prolog_flag(answer_write_options, [max_depth(1000)]).
:- use_module(derivador, [derivar/4]).
%indeterminaciones%
indeterm(X*infinito,_,_,indeterminado):-X=:=0.
indeterm(infinito*X,_,_,indeterminado):-X=:=0.
indeterm(infinito/infinito,_,_,indeterminado).
indeterm(X^infinito,_,_,indeterminado):-X=:=1.
indeterm(X^Y,_,_,indeterminado):-X=:=0,Y=:=0.
indeterm(X/Y,_,_,indeterminado):-X=:=0.0,Y=:=0.0.
indeterm(infinito-infinito,_,_,indeterminado).

%limites bases%
limite(pi,_,_,3.1416,[('Límite de pi',3.1416)]).
limite(e,_,_,2.7183,[('Constante de Euler',2.7183)]).
limite(X,X,pi,3.1416,[('Límite de una variable que se aproxima a un punto',3.1416)]).
limite(X,X,P,P,[('Límite de una variable que se aproxima a un punto',P)]).

limite(X,_,_,L,[('Límite de una constante',X)]):-
	number(X),
	L is X.
limite(-X,V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	L= -LX,
	append(Pasos1,[('Límite de una expresión negativa',L)],Pasos).

%limite fundamental algebraico%
limite((1+1/X)**X,X,infinito,e,[('Límite fundamental algebraico',e)]).

%limite del producto%
limite(X*Y,V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	limite(Y,V,P,LY,Pasos2),
	(indeterm(LX*LY,_,_,L);(atom(LX),L = LX);(atom(LY),L = LY);(LA is LX*LY,aproximar(LA,L))),!,
	append(Pasos1,Pasos2,Aux),append(Aux,[('Límite del producto',L)],Pasos).

%limite de la suma%
limite(X+Y,V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	limite(Y,V,P,LY,Pasos2),
	((atom(LX),L = LX);(atom(LY),L = LY);(LA is LX+LY,aproximar(LA,L))),!,
      append(Pasos1,Pasos2,Aux),append(Aux,[('Límite de la suma',L)],Pasos).


%limite de la resta%
limite(X-Y,V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	limite(Y,V,P,LY,Pasos2),
        (indeterm(LX-LY,_,_,L);(atom(LX),L = LX);(atom(LY),L = LY);(LA is LX-LY,aproximar(LA,L))),!,
       append(Pasos1,Pasos2,Aux),append(Aux,[('Límite de la resta',L)],Pasos).


% limite de la division, tener en cuenta llamar a LHospital al
% producirse indeterminaciones%
limite(X/Y,V,P,L,Pasos):-
	catch(limite_zero(X/Y,V,P,L,Pasos),_,limite_div(X/Y,V,P,L,Pasos)).



%limite de la potencia%
limite(X^Y,V,P,L,Pasos):-
	limite(Y,V,P,LY,Pasos1),
        limite(X,V,P,LX,Pasos2),
	(indeterm(LX^LY,_,_,L);(atom(LX),L = LX);(atom(LY),L = LY);(LA is LX^LY,aproximar(LA,L))),!,
       append(Pasos1,Pasos2,Aux),append(Aux,[('Límite de la potencia',L)],Pasos).

%limites trigonometricos%
limite(sen(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LT is sin(LX),aproximar(LT,LA),((LA =:= -0.0,L=0.0);L=LA),!)),!,append(Pasos1,[('Límite del seno',L)],Pasos).

limite(cos(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LT is cos(LX),aproximar(LT,LA),((LA =:= -0.0,L=0.0);L=LA),!)),!,
	append(Pasos1,[('Límite del coseno',L)],Pasos).


limite(tan(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LT is tan(LX),aproximar(LT,LA),((LA =:= -0.0,L=0.0);L=LA),!)),!,
	append(Pasos1,[('Límite de la tangente',L)],Pasos).


limite(asen(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LT is asin(LX),aproximar(LT,LA),((LA =:= -0.0,L=0.0);L=LA),!)),!,
	append(Pasos1,[('Límite del arcoseno',L)],Pasos).


limite(acos(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LT is acos(LX),aproximar(LT,LA),((LA =:= -0.0,L=0.0);L=LA),!)),!,
	append(Pasos1,[('Límite del arcocoseno',L)],Pasos).


limite(atan(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LT is atan(LX),aproximar(LT,LA),((LA =:= -0.0,L=0.0);L=LA),!)),!,
	append(Pasos1,[('Límite del arcotangente',L)],Pasos).


%Limite del modulo%
limite(abs(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LA is abs(LX),aproximar(LA,L))),!,
	append(Pasos1,[('Límite del módulo',L)],Pasos).


%Limite con raiz cuadrada%
limite(sqrt(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LA is sqrt(LX),aproximar(LA,L))),!,
	append(Pasos1,[('Límite de la raíz cuadrada',L)],Pasos).


%limite con logaritmos base 10 y log natural%
limite(ln(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((LX=<0,L=indeterminado);(LA is log(LX),aproximar(LA,L))),!,
	append(Pasos1,[('Límite del logaritmo natural',L)],Pasos).

limite(log(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((LX=<0,L=indeterminado);(LA is log10(LX),aproximar(LA,L))),!,
	append(Pasos1,[('Límite del logaritmo base 10',L)],Pasos).


%otros%
limite_zero(X/Y,V,P,L,Pasos):-
	T is Y,
	((T\=0,limite_div(X/Y,V,P,L,Pasos));(L='división por cero',Pasos=['División por cero'])),!.

limite_div(X/Y,V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	limite(Y,V,P,LY,Pasos2),
        ((indeterm(LX/LY,_,_,_),limite_LH(X/Y,V,P,L),append(Pasos1,Pasos2,Aux),append(Aux,['Límite indeterminado',('Aplicando LHospital',L)],Pasos));
	(number(LX),LY=infinito,L=0,append(Pasos1,Pasos2,Aux),append(Aux,[('Límite de la división',L)],Pasos));
	(number(LX),LY=:=0,L = infinito,append(Pasos1,Pasos2,Aux),append(Aux,[('Límite de la división',L)],Pasos));
	(atom(LX),L = LX,append(Pasos1,Pasos2,Aux),append(Aux,[('Límite de la división',L)],Pasos));
	(atom(LY),L = LY,append(Pasos1,Pasos2,Aux),append(Aux,[('Límite de la división',L)],Pasos));
	(mcd(LX,LY,D),XD is LX/D,YD is LY/D,aproximar(XD,AX),aproximar(YD,AY),((AY=:=1.0,L=AX);L=AX/AY),!,append(Pasos1,Pasos2,Aux),append(Aux,[('Hallando mcd y dividiendo',L)],Pasos))),!.

aproximar(X,A):-
	format(atom(NA),'~1f',X),
	atom_number(NA,A).
%mcd%
mcd(0,_,1).
mcd(0.0,_,1).
mcd(_,0,1).
mcd(_,0.0,1).

mcd(X,Y,Z):-X=:=Y,!,Z=X.
mcd(X,Y,D):-
	(X<0;Y<0),!,
	AX is abs(X),
	YX is abs(Y),
	mcd(AX,YX,D).
mcd(X,Y,D):-
	X>Y,
	LX is X-Y,
	aproximar(LX,AX),
	mcd(AX,Y,D).
mcd(X,Y,D):-
	X<Y,
	LX is Y-X,
	aproximar(LX,AX),
	mcd(X,AX,D).

limite_LH(X/Y,V,P,L):-
	derivar(X,V,DX,_),
	derivar(Y,V,DY,_),
	limite(DX/DY,V,P,L,_).
