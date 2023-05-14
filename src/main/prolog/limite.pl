
%indeterminaciones%
indeterm(0*infinito,_,_,indeterminado).
indeterm(infinito*0,_,_,indeterminado).
indeterm(infinito/infinito,_,_,indeterminado).
indeterm(1^infinito,_,_,indeterminado).
indeterm(0^0,_,_,indeterminado).
indeterm(0/0,_,_,indeterminado).
indeterm(infinito-infinito,_,_,indeterminado).

%limites bases%
limite(e,_,_,2.7183).

limite(X,X,P,P).

limite(X,_,_,L):-
	number(X),
	L is X.
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
	(indeterm(LX^LY,_,_,L);(atom(LX),L = LX);(atom(LY),L = LY);L is LX^LY),!.
%limites trigonometricos%
limite(sin(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(LT is sin(LX),cerca_cero(LT,L))),!.

limite(cos(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(LT is cos(LX),cerca_cero(LT,L))),!.

limite(tan(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(LT is tan(LX),cerca_cero(LT,L))),!.

limite(asin(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(LT is asin(LX),cerca_cero(LT,L))),!.

limite(acos(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(LT is acos(LX),cerca_cero(LT,L))),!.

limite(atan(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(LT is atan(LX),cerca_cero(LT,L))),!.

%Limite del modulo%
limite(abs(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(L is abs(LX))),!.

%Limite con raiz cuadrada%
limite(sqrt(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(L is sqrt(LX))),!.

%limite con logaritmos base 10 y log natural%
limite(log(X),V,P,L):-
	limite(X,V,P,LX),
	((LX=<0,L=indeterminado);L is log(LX)),!.
limite(log10(X),V,P,L):-
	limite(X,V,P,LX),
	((LX=<0,L=indeterminado);L is log10(LX)),!.

%otros%
limite_zero(X/Y,V,P,L):-
	T is Y,
	((T\=0,limite_div(X/Y,V,P,L));L='division por cero'),!.

limite_div(X/Y,V,P,L):-
	limite(X,V,P,LX),
	limite(Y,V,P,LY),
        (indeterm(LX/LY,_,_,L);(number(LX),LY=infinito,L=0);(number(LX),LY=:=0,L = infinito);(atom(LX),L = LX);(atom(LY),L = LY);(mcd(LX,LY,D),XD is LX/D,YD is LY/D,((YD=:=1,L=XD);L=XD/YD))),!.

cerca_cero(X,0):-
	abs(X)=<0.00001.
cerca_cero(X,X):-
	abs(X)>0.00001.
%mcd%
mcd(X,X,X).
mcd(X,Y,D):-
	X>Y,
	LX is X-Y,
	mcd(LX,Y,D).
mcd(X,Y,D):-
	X<Y,
	LX is Y-X,
	mcd(X,LX,D).














