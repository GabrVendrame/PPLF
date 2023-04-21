:- use_module(library(plunit)).
:- use_module(library(clpfd)).

%% ultimo(L, X) is semidet
% 
% Verdadeiro se X é o último elemento da lista L.

:- begin_tests(ultimo).

test(ultimo0) :- ultimo([], []).
test(ultimo1) :- ultimo([1], 1).
test(ultimo2) :- ultimo([1, 2, 3], 3).
test(ultimo3, fail) :- ultimo([1, 2, 3], 1).

:- end_tests(ultimo).

ultimo([], []) :- !.

ultimo([_ | XS], X) :-
    ultimo(XS, X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% pares(L, P) is semidet
%
% Verdadeiro se P é uma lista com
% os elementos pares de L.

:- begin_tests(pares).

test(pares0) :- pares([], []).
test(pares1) :- pares([1], []).
test(pares2) :- pares([2], [2]).
test(pares3) :- pares([1, 2, 3, 4], [2, 4]).
test(pares4) :- pares([1, 2, 3, 4], [1, 3]).

:- end_tests(pares).

pares([], []) :- !.

pares([X | XS], [X | YS]) :-
    0 is X mod 2,
    pares(XS, YS), !.

pares([X | XS], P) :-
    1 is X mod 2,
    pares(XS, P), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% lista_soma(XS, A, YS) is semidet
%
% Verdadeiro se a lista YS é a soma XS + A.

:- begin_tests(lista_soma).

test(soma0) :- lista_soma([], 1, []).
test(soma1) :- lista_soma([0], 1, [1]).
test(soma2) :- lista_soma([1, 2, 3], 2, [3, 4, 5]).
test(soma10) :- lista_soma([0, 0, 0, 0, 0], 10, [10, 10, 10, 10, 10]).
test(soma3, fail) :- lista_soma([1, 2, 3], 4, [1, 2, 3]).

:- end_tests(lista_soma).

lista_soma([], _, []) :- !.

lista_soma([X | XS], A, [Y | YS]) :-
    Y is X + A,
    lista_soma(XS, A, YS).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% maximo(XS, M) is semidet
%
% Verdadeiro se M é o valor máximo da lista XS.

:- begin_tests(maximo).

test(maximo0) :- maximo([], 0).
test(maximo1) :- maximo([5, 2, 3, 4, 1], 5).
test(maximo2) :- maximo([2, 3, 5, 1, 4], 5).
test(maximo3) :- maximo([1, 2, 3, 4, 5], 5).
test(maximo4, fail) :- maximo([1, 2, 3, 4, 5], 1).

:- end_tests(maximo).

maximo([], 0) :- !.

maximo([X], X) :- !.

maximo([X, Y | XS], M) :-
    X >= Y,
    maximo([X | XS], M), !.

maximo([X, Y | XS], M) :-
    X < Y,
    maximo([Y | XS], M), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% inverte(+L, I) is semidet.
%
% Retorna verdadeiro se a lista I é uma
% lista invertida da lista L.

:- begin_tests(inverte).

test(inverte0) :- inverte([], []).
test(inverte1) :- inverte([1, 2, 1], [1, 2, 1]).
test(inverte2) :- inverte([1, 2, 3], [3, 2, 1]).
test(inverte3) :- inverte([1, 2, 3], [1, 3, 2]).

:- end_tests(inverte).

inverte([], []).

inverte(L, I) :-
    L = [A | AS],
    inverte(AS, R),
    append(R, [A], I).

%% igual(L, L2) is det
%
% Verdadeiro se a lista L for igual
% a lista L2, falso caso contrário.

:- begin_tests(igual).

test(igual0) :- igual([], []).
test(igual1) :- igual([1, 2, 3], [1, 2, 3]).
test(igual2, fail) :- igual([1, 2, 3], [1, 3, 2]).

:- end_tests(igual).

igual([], []).

igual([L | LS], [I | IS]) :- 
    L = I,
    igual(LS, IS).

%% palindromo(+L) is det
%
% Verdadeiro se a lista L é um palíndromo,
% falso caso contrário.

:- begin_tests(palindromo).

test(palindromo0) :- palindromo([]).
test(palindromo1) :- palindromo([1, 1, 1]).
test(palindromo2) :- palindromo([6, 9, 6]).
test(palindromo3, fail) :- palindromo([1, 2, 3]).

:- end_tests(palindromo).

palindromo([]) :- !.

palindromo(L) :-
    inverte(L, I),
    igual(L, I).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% removido_em(L, X, I, R) is semidet
%
% Verdeiro se a lista R for a lista R
% com o elemento X removido no indice I.

:- begin_tests(removido_em).

test(removido_em0) :- removido_em([], 3, 2, []).
test(removido_em1) :- removido_em([1, 2, 3], 1, 0, [2, 3]).
test(removido_em2) :- removido_em([1, 2, 3], 2, 1, [1, 3]).
test(removido_em3) :- removido_em([1, 2, 3], 3, 2, [1, 2]).
test(removido_em4, fail) :- removido_em([1, 2, 3], 1, 0, [1, 2, 3]).

:- end_tests(removido_em).

removido_em([], _, _, []) :- !.

removido_em([_ | LS], _, 0, LS) :- !.

removido_em([L | LS], X, I, [L | RS]) :-
    I > 0,
    I0 is I-1,
    removido_em(LS, X, I0, RS), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% inserido_em(L, X, I, R) is semidet
%
% Verdadeiro se R é a lista L com o elemento X
% inserido no índice I.

:- begin_tests(inserido_em).

test(inserido_em0) :- inserido_em([], c, 0, [c]).
test(inserido_em1) :- inserido_em([b, c], a, 0, [a, b, c]).
test(inserido_em2) :- inserido_em([a, b, d], c, 2, [a, b, c, d]).
test(inserido_em3) :- inserido_em([a, b, c], d, 3, [a, b, c, d]).
test(inserido_em4, fail) :- inserido_em([a, b, c], d, 3, [a, b, c]).

:- end_tests(inserido_em).

inserido_em([], X, 0, [X]) :- !.

inserido_em([_ | LS], X, 0, [X, _ | LS]) :- !.

inserido_em([L | LS], X, I, [L | RS]) :-
    I > 0,
    I0 is I-1,
    inserido_em(LS, X, I0, RS), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% sub_lista(L, I, J, S) is semidet
%
% Verdadeiro se S é uma sub-lista de L
% do índice I até o índice J.

:- begin_tests(sub_lista).

test(sub_lista0) :- sub_lista([], 0, 0, []).
test(sub_lista1) :- sub_lista([1, 2, 3, 4, 5], 1, 2, [2, 3, 4]).
test(sub_lista2) :- sub_lista([1], 0, 1, [1]).
test(sub_lista3, fail) :- sub_lista([1, 2, 3, 4, 5], 0, 2, [1, 2, 3, 4]).

:- end_tests(sub_lista).

sub_lista([], _, _, []) :- !.

sub_lista([_ | LS], I, J, S) :-
    I > 0,
    I0 is I-1,
    sub_lista(LS, I0, J, S), !.

sub_lista([L | LS], I, J, [L | SS]) :-
    J > 0,
    J0 is J-1,
    sub_lista(LS, I, J0, SS), !.

sub_lista([L | _], I, J, [L]) :-
    I =:= 0,
    J =:= 0, !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% duplicada(L, D) is semidet
%
% Verdadeiro se D é uma lista com os elementos
% duplicados de L.

:- begin_tests(duplicada).

test(duplicada0) :- duplicada([], []).
test(duplicada1) :- duplicada([a], [a, a]).
test(duplicada2) :- duplicada([a, b, c, c, d], [a, a, b, b, c, c, c, c, d, d]).
test(duplicada3, fail) :- duplicada([a, b, c], [a, a, b, c]).

:- end_tests(duplicada).

duplicada([], []) :- !.

duplicada([L | LS], D) :-
    D = [L, L | DS],
    duplicada(LS, DS).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% dobrada(L) is det
%
% Verdadeiro se L possui dois blocos iguais,
% falso caso contrário.

:- begin_tests(dobrada).

test(dobrada0) :- dobrada([]).
test(dobrada1) :- dobrada([a, b, c, a, b, c]).
test(dobrada2, fail) :- dobrada([a, b, a]).

:- end_tests(dobrada).

dobrada([]) :- !.

dobrada(L) :-
    append(X, Y, L),
    append(_, X, Y),
    X = Y, !.