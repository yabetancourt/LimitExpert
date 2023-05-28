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
limite(e,_,_,2.7183,[('Constante de Euler',2.7183)]).

limite(X,X,P,P,[('Limite de una variable que se aproxima a un punto',P)]).

limite(X,_,_,L,[('Limite de una constante',X)]):-
	number(X),
	L is X.
limite(-X,V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	L= -LX,
	append(Pasos1,[('Limite de una expresion negativa',L)],Pasos).

%limite fundamental algebraico%
limite((1+1/X)**X,X,infinito,e,[('Limite fundamental algebraico',e)]).

%limite del producto%
limite(X*Y,V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	limite(Y,V,P,LY,Pasos2),
	(indeterm(LX*LY,_,_,L);(atom(LX),L = LX);(atom(LY),L = LY);L is	LX*LY),!,
	append(Pasos1,Pasos2,Aux),append(Aux,[('L�mite del producto',L)],Pasos).

%limite de la suma%
limite(X+Y,V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	limite(Y,V,P,LY,Pasos2),
	((atom(LX),L = LX);(atom(LY),L = LY);L is LX+LY),!,
      append(Pasos1,Pasos2,Aux),append(Aux,[('L�mite de la suma',L)],Pasos).


%limite de la resta%
limite(X-Y,V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	limite(Y,V,P,LY,Pasos2),
        (indeterm(LX-LY,_,_,L);(atom(LX),L = LX);(atom(LY),L = LY);L is	LX-LY),!,
       append(Pasos1,Pasos2,Aux),append(Aux,[('L�mite de la resta',L)],Pasos).


% limite de la division, tener en cuenta llamar a LHospital al
% producirse indeterminaciones%
limite(X/Y,V,P,L,Pasos):-
	catch(limite_zero(X/Y,V,P,L,Pasos),_,limite_div(X/Y,V,P,L,Pasos)).



%limite de la potencia%
limite(X^Y,V,P,L,Pasos):-
	limite(Y,V,P,LY,Pasos1),
        limite(X,V,P,LX,Pasos2),
	(indeterm(LX^LY,_,_,L);(atom(LX),L = LX);(atom(LY),L = LY);(LA is LX^LY,aproximar(LA,L))),!,
       append(Pasos1,Pasos2,Aux),append(Aux,[('L�mite de la potencia',L)],Pasos).

%limites trigonometricos%
limite(sen(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LT is sin(LX),aproximar(LT,L))),!,
	append(Pasos1,[('Limite del seno',L)],Pasos).

limite(cos(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LT is cos(LX),aproximar(LT,L))),!,
	append(Pasos1,[('Limite del coseno',L)],Pasos).


limite(tan(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LT is tan(LX),aproximar(LT,L))),!,
	append(Pasos1,[('Limite de la tangente',L)],Pasos).


limite(asen(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LT is asin(LX),aproximar(LT,L))),!,
	append(Pasos1,[('Limite del arcoseno',L)],Pasos).


limite(acos(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LT is acos(LX),aproximar(LT,L))),!,
	append(Pasos1,[('Limite del arcocoseno',L)],Pasos).


limite(atan(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LT is atan(LX),aproximar(LT,L))),!,
	append(Pasos1,[('Limite del arcotangente',L)],Pasos).


%Limite del modulo%
limite(abs(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(L is abs(LX))),!,
	append(Pasos1,[('Limite del m�dulo',L)],Pasos).


%Limite con raiz cuadrada%
limite(sqrt(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((atom(LX),L=LX);(LA is sqrt(LX),aproximar(LA,L))),!,
	append(Pasos1,[('Limite de la ra�z cuadrada',L)],Pasos).


%limite con logaritmos base 10 y log natural%
limite(ln(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((LX=<0,L=indeterminado);(LA is log(LX),aproximar(LA,L))),!,
	append(Pasos1,[('Limite del logaritmo natural',L)],Pasos).

limite(log(X),V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	((LX=<0,L=indeterminado);(LA is log10(LX),aproximar(LA,L))),!,
	append(Pasos1,[('Limite del logaritmo base 10',L)],Pasos).


%otros%
limite_zero(X/Y,V,P,L,Pasos):-
	T is Y,
	((T\=0,limite_div(X/Y,V,P,L,Pasos));(L='division por cero',Pasos=['Divisi�n por cero'])),!.

limite_div(X/Y,V,P,L,Pasos):-
	limite(X,V,P,LX,Pasos1),
	limite(Y,V,P,LY,Pasos2),
        ((indeterm(LX/LY,_,_,_),limite_LH(X/Y,V,P,L));(number(LX),LY=infinito,L=0);(number(LX),LY=:=0,L = infinito);(atom(LX),L = LX);(atom(LY),L = LY);(mcd(LX,LY,D),XD is LX/D,YD is LY/D,((YD=:=1,L=XD);L=XD/YD))),!,
	append(Pasos1,Pasos2,Aux),append(Aux,[('Limite de la divisi�n',L)],Pasos).

aproximar(X,A):-
	format(atom(NA),'~1f',X),
	atom_number(NA,A).
%mcd%
mcd(0,_,1).
mcd(0.0,_,1).

mcd(X,Y,Z):-X=:=Y,!,Z=X.
mcd(-X,Y,D):-
	mcd(X,Y,D).
mcd(X,-Y,D):-
	mcd(X,Y,D).
mcd(X,Y,D):-
	X>Y,
	LX is X-Y,
	mcd(LX,Y,D).
mcd(X,Y,D):-
	X<Y,
	LX is Y-X,
	mcd(X,LX,D).

limite_LH(X/Y,V,P,L):-
	derivar(X,V,DX,_),
	derivar(Y,V,DY,_),
	limite(DX/DY,V,P,L,_).

















