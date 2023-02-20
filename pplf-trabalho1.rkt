#lang racket
(require examples)
;; Aluno: Gabriel de Souza Vendrame RA: 112681

;; (EXERCICIO 1)

#| ANÁLISE
Verificar se duas reservas de horário não conflitam entre si, ou seja, se os dois horários podem ser reservados.
|#

#| DEFINIÇÃO TIPOS DE DADOS
Informações: horários de duas reuniões.

Representações:
horario é uma struct com os dados hora-inicial, minuto-inicial, hora-final, minuto-final.
horas podem assumir valores entre [8, 18] e minutos podem assumir valores entre [0, 59].

conflito é um tipo booleano com valores:
#f caso não exista conflitos entre os horários.
#t caso exista confilitos entre os horários.
|#

#| ESPECIFICAÇÃO
horario1 horario2 -> boolean.
Verifica se duas reuniões podem reservar a mesma sala sem que haja
conflito de horário. Retorna #t caso os dois horários não conflitam,
#f caso contrário.
|#

(examples
 (check-equal? (conflito? (horario 8 0 8 50) (horario 14 0 14 50)) #f)
 (check-equal? (conflito? (horario 8 0 8 50) (horario 8 50 9 40)) #f)
 (check-equal? (conflito? (horario 10 0 10 20) (horario 10 30 12 00)) #f)
 (check-equal? (conflito? (horario 9 0 12 0) (horario 10 0 11 0)) #t)
 (check-equal? (conflito? (horario 13 0 13 30) (horario 13 0 13 30)) #t)
 (check-equal? (conflito? (horario 17 30 18 0) (horario 14 30 18 0)) #t))

(define (conflito? reuniao1 reuniao2)
  (cond
    [(= (horario-hora-inicial reuniao1) (horario-hora-inicial reuniao2))
     (cond
       [(= (horario-minuto-inicial reuniao1) (horario-minuto-inicial reuniao2)) #t]
       [(< (horario-minuto-inicial reuniao1) (horario-minuto-inicial reuniao2))
        (cond
          [(<= (horario-minuto-final reuniao1) (horario-minuto-inicial reuniao2)) #f]
          [else #t])])]
    [(< (horario-hora-inicial reuniao1) (horario-hora-inicial reuniao2))
     (cond
       [(<= (horario-hora-final reuniao1) (horario-hora-inicial reuniao2)) #f]
       [else #t])]
    [else
     (cond
       [(>= (horario-hora-inicial reuniao1) (horario-hora-final reuniao2)) #f]
       [else #t])]))

(struct horario (hora-inicial minuto-inicial hora-final minuto-final) #:transparent)
#|
Horário representa a reserva de hora para a sala de reunião.
hora-inicial: número - hora inicial da reserva (exemplo 9:00-12:00, a hora inicial seria 9).
minuto-inicial: número - minuto inicial da reserva (no exemplo acima minuto inicial seria 0).
hora-final: número - hora final da reserva (no exemplo anterior hora final seria 12).
minuto-final número - minuto final da reserva (no exemplo citado minuto final seria 0).
|#


;; (EXERCICIO 2)

#| ANÁLISE
Determinar a nova posição do personagem no tabuleiro.
|#

#| DEFINIÇÃO TIPOS DE DADOS
Informações: localização atual do personagem e um comando.

Representações:
personagem é uma struct com o ponto (x, y), que representa a localização no tabuleiro, e a direção em que ele está virado.
x, y recebem valores entre [1, 10].
direção recebe uma das 4 direções cardeais (norte, sul, leste, oeste).

comando também é uma struct que pode assumir dois valores:
"virar", que tera duas opções, "esquerda" e "direita"
"avancar", que avança n posições na direção que está virado.
|#

#| ESPECIFICAÇÃO
personagem comando -> nova-posicao.
Faz um avanço na direção em que o personagem está virado ou muda a direção em que o personagem está virado.
Retorna a nova posição do personagem de acordo com o comando especificado.
|#

(examples
 (check-equal? (jogada (personagem 2 8 "norte") (comando "virar" "direita")) (personagem 2 8 "leste"))
 (check-equal? (jogada (personagem 3 5 "norte") (comando "virar" "esquerda")) (personagem 3 5 "oeste"))
 (check-equal? (jogada (personagem 3 2 "sul") (comando "virar" "direita")) (personagem 3 2 "oeste"))
 (check-equal? (jogada (personagem 5 4 "sul") (comando "virar" "esquerda")) (personagem 5 4 "leste"))
 (check-equal? (jogada (personagem 1 9 "leste") (comando "virar" "direita")) (personagem 1 9 "sul"))
 (check-equal? (jogada (personagem 9 10 "leste") (comando "virar" "esquerda")) (personagem 9 10 "norte"))
 (check-equal? (jogada (personagem 1 6 "oeste") (comando "virar" "direita")) (personagem 1 6 "norte"))
 (check-equal? (jogada (personagem 1 2 "oeste") (comando "virar" "esquerda")) (personagem 1 2 "sul"))
 (check-equal? (jogada (personagem 4 9 "norte") (comando "avancar" 1)) (personagem 4 10 "norte"))
 (check-equal? (jogada (personagem 7 6 "sul") (comando "avancar" 2)) (personagem 7 4 "sul"))
 (check-equal? (jogada (personagem 6 10 "leste") (comando "avancar" 2)) (personagem 8 10 "leste"))
 (check-equal? (jogada (personagem 9 3 "oeste") (comando "avancar" 1)) (personagem 8 3 "oeste")))

(define (jogada jogador movimento)
  (cond
    [(equal? (comando-acao movimento) "virar")
     (cond
       [(equal? (comando-valor movimento) "direita")
        (cond
          [(equal? (personagem-direcao jogador) "norte") (struct-copy personagem jogador [direcao "leste"])]
          [(equal? (personagem-direcao jogador) "sul") (struct-copy personagem jogador [direcao "oeste"])]
          [(equal? (personagem-direcao jogador) "leste") (struct-copy personagem jogador [direcao "sul"])]
          [else (struct-copy personagem jogador [direcao "norte"])])]
       [else
        (cond
          [(equal? (personagem-direcao jogador) "norte") (struct-copy personagem jogador [direcao "oeste"])]
          [(equal? (personagem-direcao jogador) "sul") (struct-copy personagem jogador [direcao "leste"])]
          [(equal? (personagem-direcao jogador) "leste") (struct-copy personagem jogador [direcao "norte"])]
          [else (struct-copy personagem jogador [direcao "sul"])])])]
    [else
     (cond
       [(equal? (personagem-direcao jogador) "norte") (struct-copy personagem jogador [y (+ (personagem-y jogador) (comando-valor movimento))])]
       [(equal? (personagem-direcao jogador) "sul") (struct-copy personagem jogador [y (- (personagem-y jogador) (comando-valor movimento))])]
       [(equal? (personagem-direcao jogador) "leste") (struct-copy personagem jogador [x (+ (personagem-x jogador) (comando-valor movimento))])]
       [else (struct-copy personagem jogador [x (- (personagem-x jogador) (comando-valor movimento))])])]))

(struct personagem (x y direcao)#:transparent)
#|
personagem representa o jogador no tabuleiro.
x: número - representa a coordenada x do jogador no tabuleiro.
y: número - representa a coordenada y do jogador no tabuleiro.
direcao: string - representa a direção cardeal em que o jogador está virado.
|#

(struct comando (acao valor)#:transparent)
#|
comando representa a próxima jogada do jogador no tabuleiro.
acao: string - representa a ação do movimento escolhido, virar ou avançar.
valor: caso acao = virar é uma string - representa a direção em que o jogador irá virar, esquerda ou direita.
caso acao = avancar é um número - representa a quantidade de casas que o jogador irá avançar.
|#


;; (EXERCÍCIO 3)

#| ANÁLISE
Converter uma lista de números para uma lista de strings onde todos os elementos possuam o mesmo número de caracteres.
|#

#| DEFINIÇÃO TIPOS DE DADOS
Informações: entrada é uma lista de números.

Representações:
ldn é uma lista com pelo menos 1 número, podendo ter até n números.
lista-str é a ldn convertida para string com todos os elementos contendo o mesmo tamanho.
|#

#| ESPECIFICAÇÃO
ldn -> lista-str.
Converte uma lista de números para uma lista de strings.
Retorna a lista de string com todos os elementos da lista possuindo o mesmo tamanho (quantidade de caracteres).
|#

(examples
 (check-equal? (converte-lista empty) empty)
 (check-equal? (converte-lista (cons 0 empty)) (cons 0 empty))
 (check-equal? (converte-lista (cons 1 (cons 5 (cons 7 (cons 10 (cons 4 empty)))))) (cons 01 (cons 05 (cons 07 (cons 10 (cons 04 empty))))))
 (check-equal? (converte-lista (cons 4 (cons 30 (cons 17 (cons 100 (cons 1 empty)))))) (cons 004 (cons 030 (cons 017 (cons 100 (cons 001 empty))))))
 (check-equal? (converte-lista (cons 7 (cons 3 (cons 73 (cons 18 (cons 215 (cons 1000 (cons 572 empty))))))))
               (cons 0007 (cons 0003 (cons 0073 (cons 0018 (cons 0215 (cons 1000 (cons 0572 empty)))))))))
                
(define (converte-lista ldn)
  ...)

;; (EXERCÍCIO 4)

#| ANÁLISE
Verificar se uma string é um palíndromo.
|#

#| DEFINIÇÃO TIPOS DE DADOS
Informações: entrada é uma string.

Representações:
palavra é uma string.
|#

#| ESPECIFICAÇÃO
palavra -> boolean.
A função verifica se a string dada é um palíndromo (escrita de trás pra frente é igual a escrita normal).
Retorna #t caso a string seja um palíndromo, #f caso contrário.
|#
(examples
 (check-equal? (palindromo? ("socorram-me subi no ônibus em Marrocos")) #t)
 (check-equal? (palindromo? ("aibofobia")) #t)
 (check-equal? (palindromo? ("roma")) #f))

(define (palindromo? palavra)
  ...)