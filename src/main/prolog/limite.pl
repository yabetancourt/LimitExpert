
%indeterminaciones%
indeterm(0*infinito,_,_,indeterminado).
indeterm(infinito*0,_,_,indeterminado).
indeterm(infinito/infinito,_,_,indeterminado).
indeterm(1**infinito,_,_,indeterminado).
indeterm(0**0,_,_,indeterminado).
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
	limite(X,V,P,LX),
	limite(Y,V,P,LY),
        (indeterm(LX/LY,_,_,L);(number(LX),LY=infinito,L=0);(number(LX),LY=:=0,L = infinito);(atom(LX),L = LX);(atom(LY),L = LY);L is LX/LY),!.

%limite de la potencia%
limite(X**Y,V,P,L):-
	limite(Y,V,P,LY),
        limite(X,V,P,LX),
	(indeterm(LX**LY,_,_,L);(atom(LX),L = LX);(atom(LY),L = LY);L is LX**LY),!.
%limites trigonometricos%
limite(sin(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(L is sin(LX))),!.

limite(cos(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(L is cos(LX))),!.

limite(tan(X),V,P,L):-
	limite(X,V,P,LX),
	((atom(LX),L=LX);(L is tan(LX))),!.

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














