pai(adao, abel).
pai(adao, caim).
pai(adao, sete).
pai(caim, enoque).
pai(enoque, irad).
pai(irad, meujael).
pai(meujael, metusael).
pai(metusael, lameque).
pai(lameque, jabal).
pai(lameque, jubal).
pai(lameque, tubalcaim).
pai(lameque, naama).
mae(eva, abel).
mae(eva, caim).
mae(eva, sete).
mae(ada, jabal).
mae(ada, jubal).
mae(zila, tubalcaim).
mae(zila, naama).

homem(X) :-
    pai(X, _).

homem(sete).
homem(caim).
homem(jabal).
homem(jubal).
homem(tubalcaim).

mulher(X) :-
    mae(X, _).

mulher(naama).

irmaos(X, Y) :-
    pai(Z, X),
    pai(Z, Y),
    dif(X, Y);
    mae(Z, X),
    mae(Z, Y),
    dif(X, Y).

casados(X, Y) :-
    pai(X, Z),
    mae(Y, Z).

filho(X, Y) :-
    pai(Y, X);
    mae(Y, X).

avo(X, Y) :-
    mae(X, Z),
    filho(Y, Z).

irma(X, Y) :-
    mulher(X),
    irmaos(X, Y).

irmao(X, Y) :-
    homem(X),
    irmaos(X, Y).

e_pai(X) :-
    pai(X, _).

e_mae(X) :-
    mae(X, _).

e_filho(X) :-
    filho(_, X).