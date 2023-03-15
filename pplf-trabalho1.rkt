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
Hora Minuto Hora Minuto -> Boolean.
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

#|
Horário representa a reserva de hora para a sala de reunião.
hora-inicial: número - hora inicial da reserva (exemplo 9:00-12:00, a hora inicial seria 9).
minuto-inicial: número - minuto inicial da reserva (no exemplo acima minuto inicial seria 0).
hora-final: número - hora final da reserva (no exemplo anterior hora final seria 12).
minuto-final número - minuto final da reserva (no exemplo citado minuto final seria 0).
|#
(struct horario (hora-inicial minuto-inicial hora-final minuto-final) #:transparent)


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
personagem comando -> personagem.
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

#|
personagem representa a posição do jogador no tabuleiro.
x: número - representa a coordenada x do jogador no tabuleiro.
y: número - representa a coordenada y do jogador no tabuleiro.
direcao: string - representa a direção cardeal em que o jogador está virado.
|#
(struct personagem (x y direcao)#:transparent)

#|
comando representa a próxima jogada do jogador no tabuleiro.
acao: string - representa a ação do movimento escolhido, virar ou avançar.
valor: caso acao = virar é uma string - representa a direção em que o jogador irá virar, esquerda ou direita.
caso acao = avancar é um número - representa a quantidade de casas que o jogador irá avançar.
|#
(struct comando (acao valor)#:transparent)


;; (EXERCÍCIO 3)

#| ANÁLISE
Converter uma lista de números para uma lista de strings onde todos os elementos possuam o mesmo número de caracteres.
|#

#| DEFINIÇÃO TIPOS DE DADOS
Informações: lista de números.

Representações:
ldn é uma lista com pelo menos 1 número, podendo ter até n números.
lista-str é a ldn convertida para string com todos os elementos contendo o mesmo tamanho.
|#

#| ESPECIFICAÇÃO
Lista(Números) -> Lista(Strings).
Retorna a lista de string com todos os elementos da lista possuindo o mesmo tamanho (quantidade de caracteres).
|#
(examples
 (check-equal? (ldn-para-lds empty) empty)
 (check-equal? (ldn-para-lds (list 0)) (list "0"))
 (check-equal? (ldn-para-lds (list 10 5 7 1 4)) (list "10" "05" "07" "01" "04"))
 (check-equal? (ldn-para-lds (list 4 30 100 17 1)) (list "004" "030" "100" "017" "001"))
 (check-equal? (ldn-para-lds (list 7 3 73 18 215 572 1000)) (list "0007" "0003" "0073" "0018" "0215" "0572" "1000")))

(define (ldn-para-lds ldn)
  (define lds (para-string ldn))
  (define maior (maior-string lds 0))
  (completa-string lds maior))

#|
Lista(Números) -> Lista(Strings).
Converte uma lista de números para uma lista de strings.
|#
(examples
 (check-equal? (para-string (list)) empty)
 (check-equal? (para-string (list 1)) (list "1"))
 (check-equal? (para-string (list 1 2 3)) (list "1" "2" "3")))

(define (para-string ldn)
  (cond
    [(empty? ldn) empty]
    [else
     (cond
       [(number? (first ldn)) (cons (number->string (first ldn)) (para-string (rest ldn)))]
       [else (cons (first ldn) (para-string (rest ldn)))])]))

#|
Lista(Strings) -> Inteiro.
Retorna o tamanho da maior string em uma lista de strings.
|#
(examples
 (check-equal? (maior-string (list) 0) 0)
 (check-equal? (maior-string (list "1") 0) 1)
 (check-equal? (maior-string (list "5" "100" "23") 0) 3)
 (check-equal? (maior-string (list "5" "23" "8742") 0) 4))

(define (maior-string lds maior)
  (cond
    [(empty? lds) maior]
    [else
     (if (> (string-length (first lds)) maior)
         (maior-string (rest lds) (string-length (first lds)))
         (maior-string (rest lds) maior))]))

#|
Lista(Strings) Inteiro -> Lista(Strings).
Retorna uma lista de strings com todas as strings do mesmo tamanho.
|#
(examples
 (check-equal? (completa-string (list) 0) empty)
 (check-equal? (completa-string (list "0") 1) (list "0"))
 (check-equal? (completa-string (list "10" "5" "7" "1" "4") 2) (list "10" "05" "07" "01" "04"))
 (check-equal? (completa-string (list "4" "30" "100" "17" "1") 3) (list "004" "030" "100" "017" "001"))
 (check-equal? (completa-string (list "7" "3" "73" "18" "215" "572" "1000") 4) (list "0007" "0003" "0073" "0018" "0215" "0572" "1000")))

(define (completa-string lds maior)
  (cond
    [(empty? lds) empty]
    [else
     (if (< (string-length (first lds)) maior)
         (cons (string-append (make-string (- maior (string-length (first lds))) #\0) (first lds)) (completa-string (rest lds) maior))
         (cons (first lds) (completa-string (rest lds) maior)))]))


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
palavra -> Boolean.
A função verifica se uma string é um palíndromo (leitura da direita pra esquerda é igual a leitura da esquerda para a direita).
Retorna #t caso a string seja um palíndromo, #f caso contrário.
|#

(examples
 (check-equal? (palindromo? "SoCoRrAm-Me SuBi No ÔnIbUs Em MaRrOcOs.") #t)
 (check-equal? (palindromo? "AIBOFOBIA") #t)
 (check-equal? (palindromo? "aNã") #t)
 (check-equal? (palindromo? "sós") #t)
 (check-equal? (palindromo? "A Daniela ama a lei? Nada!") #t)
 (check-equal? (palindromo? "À Rita, sátira!") #t)
 (check-equal? (palindromo? "20/02/2002") #t)
 (check-equal? (palindromo? "Luza Rocelina, a namorada do Manuel, leu na moda da romana: \"anil é cor azul\".") #t)
 (check-equal? (palindromo? "roma") #f))

(define (palindromo? palavra)
  (define palavra-minusculo (string-downcase palavra))
  (define lst-palavra (string-split palavra-minusculo ""))
  (define lst-pal-sem-diacrit (retira-diacriticos lst-palavra))
  (equal? lst-pal-sem-diacrit (reverso lst-pal-sem-diacrit)))

;; Lista(Strings) -> Lista(Strings)
;; Recebe uma lista de strings com sinais diacríticos e retorna uma lista de strings sem sinais diacríticos.
;; OBS: Sinais diacríticos são acentos e pontuações da lingua portuguesa.
(examples
 (check-equal? (retira-diacriticos '()) empty)
 (check-equal? (retira-diacriticos
                '("" "s" "o" "c" "o" "r" "r" "a" "m" "-" "m" "e" " " "s" "u" "b" "i" " " "n" "o" " " "ô" "n" "i" "b" "u" "s" " " "e" "m" " " "m" "a" "r" "r" "o" "c" "o" "s" ""))
               '("" "s" "o" "c" "o" "r" "r" "a" "m" "m" "e" "s" "u" "b" "i" "n" "o" "o" "n" "i" "b" "u" "s" "e" "m" "m" "a" "r" "r" "o" "c" "o" "s" "")))

(define (retira-diacriticos lst-palavra)
  (cond
    [(empty? lst-palavra) empty]
    [else
     (cond
       [(or (equal? (first lst-palavra) "-") (equal? (first lst-palavra) "/") (equal? (first lst-palavra) "?") (equal? (first lst-palavra) "!")
            (equal? (first lst-palavra) ",") (equal? (first lst-palavra) ".") (equal? (first lst-palavra) " ") (equal? (first lst-palavra) #\")
            (equal? (first lst-palavra) ";") (equal? (first lst-palavra) ":") (equal? (first lst-palavra) "\"") (equal? (first lst-palavra) "(")
            (equal? (first lst-palavra) ")") (equal? (first lst-palavra) "[") (equal? (first lst-palavra) "]")) (retira-diacriticos (rest lst-palavra))]
       [else (cons (remove-acentos (first lst-palavra)) (retira-diacriticos (rest lst-palavra)))])]))

(define (remove-acentos lst-palavra)
  (cond
    [(or (equal? lst-palavra "á") (equal? lst-palavra "à") (equal? lst-palavra "ã") (equal? lst-palavra "â")) "a"]
    [(or (equal? lst-palavra "é") (equal? lst-palavra "è") (equal? lst-palavra "ê")) "e"]
    [(or (equal? lst-palavra "í") (equal? lst-palavra "ì") (equal? lst-palavra "î")) "i"]
    [(or (equal? lst-palavra "ó") (equal? lst-palavra "ò") (equal? lst-palavra "õ") (equal? lst-palavra "ô")) "o"]
    [(or (equal? lst-palavra "ú") (equal? lst-palavra "ù") (equal? lst-palavra "û")) "u"]
    [(equal? lst-palavra "ç") "c"]
    [else lst-palavra]))

;; Lista(Strings) -> Lista(Strings)
;; Reverte uma lista de strings, ou seja, o primeiro elemento passa a ser o último o segundo passa a ser o antepenúltimo e assim por diante.

(examples
 (check-equal? (reverso '()) empty)
 (check-equal? (reverso '("" "a" "i" "b" "o" "f" "o" "b" "i" "a" "")) '("" "a" "i" "b" "o" "f" "o" "b" "i" "a" ""))
 (check-equal? (reverso '("" "r" "o" "m" "a" "")) '("" "a" "m" "o" "r" "")))

(define (reverso lst-palavra)
  (cond
    [(empty? lst-palavra) empty]
    [else
     (cons-fim (first lst-palavra) (reverso (rest lst-palavra)))]))

;; String Lista(String) -> Lista(String).
;; Adiciona uma string no final de uma lista de strings.

(examples
 (check-equal? (cons-fim "a" '()) '("a"))
 (check-equal? (cons-fim "r" '("o" "m" "a")) '("o" "m" "a" "r")))

(define (cons-fim str lst-str)
  (cond
    [(empty? lst-str) (cons str empty)]
    [else
     (cons (first lst-str) (cons-fim str (rest lst-str)))]))

;; EXERCÍCIO 5

#| ANÁLISE
Converter uma lista de números para uma lista de strings onde todos os elementos possuam o mesmo número de caracteres
utilizando Acumuladores em situações adequadas.
|#

#| DEFINIÇÃO TIPOS DE DADOS
Informações: lista de números.

Representações:
ldn é uma lista com pelo menos 1 número, podendo ter até n números.
lista-str é a ldn convertida para string com todos os elementos contendo o mesmo tamanho.
|#

#| ESPECIFICAÇÃO
Lista(Números) -> Lista(Strings).
Retorna a lista de string com todos os elementos da lista possuindo o mesmo tamanho (quantidade de caracteres).
|#
(examples
 (check-equal? (ldn-para-lds-acc empty) empty)
 (check-equal? (ldn-para-lds-acc (list 0)) (list "0"))
 (check-equal? (ldn-para-lds-acc (list 10 5 7 1 4)) (list "10" "05" "07" "01" "04"))
 (check-equal? (ldn-para-lds-acc (list 4 30 100 17 1)) (list "004" "030" "100" "017" "001"))
 (check-equal? (ldn-para-lds-acc (list 7 3 73 18 215 572 1000)) (list "0007" "0003" "0073" "0018" "0215" "0572" "1000")))

(define (ldn-para-lds-acc ldn)
  (define lds (para-string ldn))
  (completa-string-acc lds (maior-string-acc lds)))

#|
Lista(Strings) -> Inteiro.
Retorna o tamanho da maior string de uma lista de strings.
|#
(examples
 (check-equal? (maior-string-acc (list)) 0)
 (check-equal? (maior-string-acc (list "1")) 1)
 (check-equal? (maior-string-acc (list "5" "100" "23")) 3)
 (check-equal? (maior-string-acc (list "5" "23" "8742")) 4))

(define (maior-string-acc lst-str0)
  ;; acc = tamanho da maior string já visitada
  (define (iter lst-str acc)
    (cond
      [(empty? lst-str) acc]
      [else
       (if (> (string-length (first lst-str)) acc)
           (iter (rest lst-str) (string-length (first lst-str)))
           (iter (rest lst-str) acc))]))
  (iter lst-str0 0))

#|
Lista(Strings) maior -> Lista(Strings).
Retorna uma lista de strings com todas as strings do mesmo tamanho.
|#
(examples
 (check-equal? (completa-string-acc (list) 0) empty)
 (check-equal? (completa-string-acc (list "0") 1) (list "0"))
 (check-equal? (completa-string-acc (list "10" "5" "7" "1" "4") 2) (list "10" "05" "07" "01" "04"))
 (check-equal? (completa-string-acc (list "4" "30" "100" "17" "1") 3) (list "004" "030" "100" "017" "001"))
 (check-equal? (completa-string-acc (list "7" "3" "73" "18" "215" "572" "1000") 4) (list "0007" "0003" "0073" "0018" "0215" "0572" "1000")))

(define (completa-string-acc lds maior)
  (cond
    [(empty? lds) empty]
    [else
     (if (< (string-length (first lds)) maior)
         (cons (string-append (make-string (- maior (string-length (first lds))) #\0) (first lds)) (completa-string-acc (rest lds) maior))
         (cons (first lds) (completa-string-acc (rest lds) maior)))]))
      
;; EXERCÍCIO 6

#| ANÁLISE
Verificar se uma string é um palíndromo, utilizando as funções map, filter e foldl e sem o uso de recursão.
|#

#| DEFINIÇÃO TIPOS DE DADOS
Informações: entrada é uma string.

Representações:
palavra é uma string.
|#

#| ESPECIFICAÇÃO
palavra -> Boolean.
A função verifica se uma string é um palíndromo (leitura da direita pra esquerda é igual a leitura da esquerda para a direita).
Retorna #t caso a string seja um palíndromo, #f caso contrário.
|#

(examples
 (check-equal? (eh-palindromo? "SoCoRrAm-Me SuBi No ÔnIbUs Em MaRrOcOs.") #t)
 (check-equal? (eh-palindromo? "AIBOFOBIA") #t)
 (check-equal? (eh-palindromo? "aNã") #t)
 (check-equal? (eh-palindromo? "sós") #t)
 (check-equal? (eh-palindromo? "A Daniela ama a lei? Nada!") #t)
 (check-equal? (eh-palindromo? "À Rita, sátira!") #t)
 (check-equal? (eh-palindromo? "Luza Rocelina, a namorada do Manuel, leu na moda da romana: \"anil é cor azul\".") #t)
 (check-equal? (eh-palindromo? "20/02/2002") #t)
 (check-equal? (eh-palindromo? "roma") #f))

(define (eh-palindromo? palavra)
  (define lst-palavra (string-split palavra ""))
  (define minusculo (map string-downcase lst-palavra))
  (define sem-acentos (map remove-acentos minusculo))
  (define lst-limpa (filter (lambda (atual) (not (member atual lst-pontuacao))) sem-acentos))
  (define reverso-lst-limpa (foldl cons '() lst-limpa))
  (equal? lst-limpa reverso-lst-limpa))

;; lista de pontuações, utilizada para removê-las da lista.
(define lst-pontuacao '("-" "/" "?" "!" "," "." " " #\" ";" ":" "\"" "(" ")" "[" "]"))