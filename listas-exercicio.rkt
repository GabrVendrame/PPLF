#lang racket
(require examples)

;; LISTA PROJETO DE FUNÇÕES

;; 1) Projete uma função que encontre o máximo entre dois números dados.

#| ANÁLISE
Encontrar o maior valor entre dois números.
|#

#| DEFINIÇÃO DOS DADOS
Informações: 2 números dados.
Ambos números inteiros.
|#

#| ESPECIFICAÇÃO
Número Número -> Número

Encontra o maior número entre dois valores.

(define (maximo num1 num2)
  ...)

Exemplos
num1 3, num2 3, retorna 3 como máximo.
num1 15, num2 42, retorna 42 como máximo.
num1 65, num2 43, retorna 65 como máxixmo.
|#

;; IMPLEMENTAÇÃO

(define (maximo num1 num2)
  (if (>= num1 num2)
      num1
      num2))

;; VERIFICAÇÃO

(examples
 (check-equal? (maximo 3 3) 3)
 (check-equal? (maximo 15 42) 42)
 (check-equal? (maximo 65 43) 65))

;; 2) Projete uma função que receba 3 números como parâmetros e retorne a soma dos quadrados dos dois maiores números.

#| ÁNALISE
Definir a soma dos quadrados dos dois maiores números entre 3 números dados.
|#

#| DEFINIÇÃO DOS TIPOS DE DADOS
Informações: 3 números passados por parâmetro.

Os 3 números são inteiros.
|#

#| ESPECIFICAÇÃO
Número Número Número -> Número
Encontra os dois maiores números entre os três dados e retorna a soma dos quadrados desses números.

(define (soma-quadrados num1 num2 num3)
  ...)

Exemplos
num1 1, num2 74, num3 13, retorna 5645.
num1 19, num2 16, num3 5, retorna 617.
num1 16, num2 10, num3 12, retorna 400.
|#