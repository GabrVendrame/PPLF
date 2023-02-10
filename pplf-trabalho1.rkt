#lang racket
(require examples)
;; Aluno: Gabriel de Souza Vendrame RA: 112681

;; (EXERCICIO 1)

#| ANÁLISE
Verificar se duas reservas de horário não conflitam
entre si, ou seja, se os dois horários podem ser reservados.
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
horario1 horario2 -> conflito.
Verifica se duas reuniões podem reservar a mesma sala sem que haja
conflito de horário. Retorna #t caso os dois horários não conflitam,
#f caso contrário.
(define (conflito?
         reuniao1
         reuniao2) ...)
Exemplos:
reuniao1 8:00 8:50, reuniao2 14:00 14:50, retorna #f pois não há conflito de horário.
reuniao1 8:00 8:50, reuniao2 8:50 9:40, retorna #f pois a reuniao1 já esta finalizada no momento que a reuniao2 começa.
reuniao1 10:00 10:20, reuniao2 10:30 12:00, retorna #f pois não há conflito entre os horários.
reuniao1 9:00 12:00, reuniao2 10:00 11:00, retorna #t pois a sala está ocupada pela reuniao1 no início da reuniao2.
reuniao1 10:00 11:00, reuniao2 10:30 11:30, retorna #t pois a reuniao1 ainda esta usando a sala no inicio da reuniao2.
reuniao1 13:00 13:30, reuniao2 13:00 13:30, retorna #t pois ambas reunioes são no mesmo horário.
reuniao1 17:30 18:00, reuniao2 14:30 18:00, retorna #t, reuniao2 ainda está ocorrendo no começo da reuniao1.
|#

;; IMPLEMENTAÇÃO

(struct horario (hora-inicial minuto-inicial hora-final minuto-final) #:transparent)
#| Horário representa a reserva de hora para a sala de reunião.
hora-inicial: número - hora inicial da reserva (exemplo 9:00-12:00, a hora inicial seria 9).
minuto-inicial: número - minuto inicial da reserva (no exemplo acima minuto inicial seria 0).
hora-final: número - hora final da reserva (no exemplo anterior hora final seria 12).
minuto-final número - minuto final da reserva (no exemplo citado minuto final seria 0).
|#

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
                      
;; VERIFICAÇÃO 
(examples
 (check-equal? (conflito? (horario 8 0 8 50) (horario 14 0 14 50)) #f)
 (check-equal? (conflito? (horario 8 0 8 50) (horario 8 50 9 40)) #f)
 (check-equal? (conflito? (horario 10 0 10 20) (horario 10 30 12 00)) #f)
 (check-equal? (conflito? (horario 9 0 12 0) (horario 10 0 11 0)) #t)
 (check-equal? (conflito? (horario 13 0 13 30) (horario 13 0 13 30)) #t)
 (check-equal? (conflito? (horario 17 30 18 0) (horario 14 30 18 0)) #t))

;; (EXERCICIO 2)

#| ANÁLISE
Determinar a nova posição do personagem no tabuleiro.
|#

#| DEFINIÇÃO TIPOS DE DADOS
Informações: localização atual do personagem e um comando.

Representações:
personagem é uma struct com o ponto (x, y), que representa a localização no tabuleiro, e a posição em que ele está virado.

comando é uma string que pode assumir três valores:
"direita".
"esquerda".
"avançar n".
|#

#| ESPECIFICAÇÃO
personagem comando -> nova-posicao.
Faz um avanço ou uma mudança na posição em que o personagem está virado.
Retorna a nova posição do personagem de acordo com o comando especificado.
(define (jogada
         personagem
         comando) ...)
Exemplos:
personagem (2, 8) "norte", comando "direita", retorna personagem (2, 8) "leste".
personagem (3, 5) "norte", comando "esquerda", retorna personagem (3, 5) "oeste".
personagem (3, 2) "sul", comando "direita", retorna personagem (3, 2) "oeste".
personagem (5, 4) "sul", comando "esquerda", retorna personagem (5, 4) "leste".
personagem (1, 9) "leste", comando "direita", retorna personagem (5, 4) "sul".
personagem (9, 10) "leste", comando "esquerda", retorna personagem (9, 10) "norte".
personagem (1, 6) "oeste", comenado "direita", retorna personagem (1, 6) "norte".
personagem (1, 2) "oeste", comenado "esquerda", retorna personagem (1, 2) "sul".
personagem (4, 9) "norte", comando "avancar 1", retorna personagem (4, 10) "norte".
personagem (7, 6) "sul", comando "avancar 2", retorna personagem (5, 6) "sul".
personagem (6, 10) "leste", comando "avancar 2", retorna personagem (8, 10) "leste".
personagem (9, 3) "oeste", comando "avancar 1", retorna personagem (8, 3) "oeste".
|#

;; IMPLEMENTAÇÃO