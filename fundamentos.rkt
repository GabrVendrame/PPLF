#lang racket

;; ex1 slide fundamentos
(define (gasto-combustivel distancia preco rendimento)
  (/ (* distancia preco) rendimento))
;; ex2 slide fundamentos


;; exemplo de condicionais
(define (e-logico x y)
  (if x y #f))
(define (ou-logico x y)
  (if x #t y))

;; lista de ex1
;; EX1

10 ;; = 10
(+ 5 3 4) ;; = 12
(- 9 1) ;; = 8
(- 9) ;; = -9
(/ 6 2) ;; = 3
(/ 4) ;; = 1/4
(*) ;; = 1
(+) ;; = 0
(+ (* 2 4) (- 4 6)) ;; = 6

(define a 3)
(define b (+ a 1))
(+ a b (* a b)) ;; = 19
(= a b) #f

(if (and (> b a) (< b (* a b)))
b
a)
;; = 4

(cond [(= a 4) 6]
[(= b 4) (+ 6 7 a)]
[else 25]) ;; = 16

(+ 2 (if (> b a) b a)) ;; = 6

(* (cond [(> a b) a]
[(< a b) b]
[else -1])
(+ a 1)) ;; = 16

;; EX2
;; a) expressao invalida
;; b) expressao invalida
;; c) expressao valida
;; d) expressao invalida
;; e) expressao invalida
