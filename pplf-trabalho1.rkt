#lang racket

#|
ANÁLISE
Verificar se duas reservas de horário não conflitam
entre si, ou seja, se os dois horários podem ser reservados.
|#

#|
DEFINIÇÃO TIPOS DE DADOS
Informações: horários de duas aulas.

Representações:
horários são subdividido em horas e minutos.
horas podem assumir valores entre [0, 23] e minutos podem assumir
valores entre [0, 59].

disponibilidade é um tipo booleano com valores:
#t caso não exista conflitos entre os horários.
#f caso exista confilitos entre os horários.
|#

#|
ESPECIFICAÇÃO
horario1 horario2 -> disponibilidade.
Verifica se duas aulas podem reservar a mesma sala sem que haja
conflito de horário. Retorna #t caso os dois horários não conflitem,
#f caso contrário.
(define (verifica-reserva
         horario-1
         horario-2) ...)
Exemplos:
horario-1 8:00 9:40, horario-2 9:40 11:20, retorna #t pois a partir
de 9:40 a sala estará livre.
horario-1 8:00 9:40, horario-2 8:50 9:40, retorna #f pois as 8:50 a
sala continua em uso pelo horario-1.
horario-1 8:00 9:40, horario-2 8:00 9:40, retorna #f pois ambos
horários tem começo e término na mesma hora.
|#

#|
IMPLEMENTAÇÃO
|#
(struct horario (hora-inicial minuto-inicial hora-final minuto-final))

(define horario1 (horario 13 0 14 0))
(define horario2 (horario 15 0 16 0))

(horario-minuto-inicial horario1)

#|
(define (verifica-reserva
         horario1
         horario2)
  (if (= horario-hora-inicial horario1 horario-hora-inicial horario2)))
|#

#|
VERIFICAÇÃO
|#

#|
REVISÃO
|#