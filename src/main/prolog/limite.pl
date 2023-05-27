:- use_module(derivador, [derivar/3]).

%indeterminaciones%
indeterm(X*infinito,_,_,indeterminado):-X=:=0.
indeterm(infinito*X,_,_,indeterminado):-X=:=0.
indeterm(infinito/infinito,_,_,indeterminado).
indeterm(X^infinito,_,_,indeterminado):-X=:=1.
indeterm(X^Y,_,_,indeterminado):-X=:=0,Y=:=0.
indeterm(X/Y,_,_,indeterminado):-X=:=0.0,Y=:=0.0.
indeterm(infinito-infinito,_,_,indeterminado).

%limites bases%
limite(e,_,_,2.7183).

limite(X,X,P,P).

limite(X,_,_,L):-
	number(X),
	L is X.
limite(-X,V,P,L):-
	limite(X,V,P,LX),
	L= -LX.
%limite fundamental algebraico%
limite((1+1/X)**X,X,infinito,e).

%limite del producto%
limite(X*Y,V,P,L):-
	limite(X,V,P,LX),
	limite(Y,V,P,LY),
	(indeterm(LX*LY,_,_,L);(atom(LX),L = LX);(atom(LY),L = LY);L is	LX*LY),!.

%limite de la suma%
limite(X+Y,V,P,L):-
	limite(X,V,P,LX),
	limite(Y,V,P,LY),
	((atom(LX),L = LX);(atom(LY),L = LY);L is LX+LY),!.

%limite de la resta%
limite(X-Y,V,P,L):-
	limite(X,V,P,LX),
	limite(Y,V,P,LY),
        (indeterm(LX-LY,_,_,L);(atom(LX),L = LX);(atom(LY),L = LY);L is	LX-LY),!.

% limite de la division, tener en cuenta llamar a LHospital al
% producirse indeterminaciones%
limite(X/Y,V,P,L):-
	catch(limite_zero(X/Y,V,P,L),_,limite_div(X/Y,V,P,L)).



%limite de la potencia%
limite(X^Y,V,P,L):-
	limite(Y,V,P,LY),
        limite(X,V,P,LX),
	(indeterm(LX^LY,_,_,L);(atom(LX),L = LX);(atom(LY),L = LY);(LA is LX^LY,aproximar(LA,L))),!.
%limites trigonometricos%
limite(sen(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(LT is sin(LX),aproximar(LT,L))),!.

limite(cos(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(LT is cos(LX),aproximar(LT,L))),!.

limite(tan(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(LT is tan(LX),aproximar(LT,L))),!.

limite(asen(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(LT is asin(LX),aproximar(LT,L))),!.

limite(acos(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(LT is acos(LX),aproximar(LT,L))),!.

limite(atan(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(LT is atan(LX),aproximar(LT,L))),!.

%Limite del modulo%
limite(abs(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(L is abs(LX))),!.

%Limite con raiz cuadrada%
limite(sqrt(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(LA is sqrt(LX),aproximar(LA,L))),!.

%limite con logaritmos base 10 y log natural%
limite(ln(X),V,P,L):-
	limite(X,V,P,LX),
	((LX=<0,L=indeterminado);(LA is log(LX),aproximar(LA,L))),!.
limite(log(X),V,P,L):-
	limite(X,V,P,LX),
	((LX=<0,L=indeterminado);(LA is log10(LX),aproximar(LA,L))),!.

%otros%
limite_zero(X/Y,V,P,L):-
	T is Y,
	((T\=0,limite_div(X/Y,V,P,L));L='division por cero'),!.

limite_div(X/Y,V,P,L):-
	limite(X,V,P,LX),
	limite(Y,V,P,LY),
        ((indeterm(LX/LY,_,_,_),limite_LH(X/Y,V,P,L));(number(LX),LY=infinito,L=0);(number(LX),LY=:=0,L = infinito);(atom(LX),L = LX);(atom(LY),L = LY);(mcd(LX,LY,D),XD is LX/D,YD is LY/D,((YD=:=1,L=XD);L=XD/YD))),!.

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
	derivar(X,V,DX),
	derivar(Y,V,DY),
	limite(DX/DY,V,P,L).

















