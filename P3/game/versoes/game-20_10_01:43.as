;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Dados do projeto                                                                           ;
;Aluno: Davi da Silveira Mello                                                              ;
;Numero: 89196                                                                              ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;


;A	lógica	principal	do jogo	a	desenvolver	consiste	na	leitura	de	um	registo	(R1);
;com	a	sequência	de	dígitos	secreta e comparação	com o	conteúdo	de	outro	;
;registo (R2) que	contém	a	jogada	atual	do	jogador	D.                              ;

;
;


;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;START          MID     END                                                                 ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;

                ORIG    8000h ; (Data)

;senhas fixas para teste

pass0           str     6,1,2,3   ; 'str' is a string
pass1           str     1,2,3,4
pass2           str     2,3,4,5
pass3           str     3,4,5,6

;frases usadas no jogo

frase10         str     'Bem vindo ao nosso jogo'
frase20         str     'O objetivo e descobrir o codigo'
frase21         str     'No resultado , tera 4 catacteres'
frase22         str     'Se tiver [ - ] significa espacos de livres'
frase23         str     'Se tiver [ o ] significa que esta certo porem na ordem errada'
frase24         str     'Se tiver [ x ] significa que esta certo porem na ordem certa'
frase30         str     'Digite uma sequencia de 4 digitos'
frase40         str     'Sequencia invalida'
frase50         str     'Resultado da rodada'
frase60         str     'Voce ganhou'

;Constantes

size            equ     4       ;Tamanho da senha
maxj            equ     12      ;Maximo de jogadas permitidas
pass            tab     4       ;alocacao de memoria para a senha do jogo
ans             tab     4       ;alocacao de memoria para a resposta do jogador
stat            tab     4       ;alocacao de memoria para a estado da jogada

;Parameter's about the code :

msp             equ     FDFFh   ; SP = FDFFh (Padrao)


;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;START          MID     END                                                                 ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;

                ORIG    0000h ; (Code)

;Parametrizacao do programa :

                mov     r1,msp  ;Atribui para r1 o valor de SP [contante => msp]
                mov     sp,r1   ;Passa para sp o valor de r1
                mov     r1,r0   ;Limpa a informacao em r1
                br      start

;Programa :

start:          br      end
play:           br      end     ;Jogada do jogador
verficar:       br      end     ;Verifica a jogada do jogador
reposta:        br      end     ;Resposta a verificaçao
endgame:        br      end     ;Final do jogo


end:            br      end     ;Laço de repetição do fim do programa

game:           br      end     ;Estrutura do jogo
