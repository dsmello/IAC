;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Dados do projeto                                                                           ;
;Aluno: Davi da Silveira Mello                                                              ;
;Numero: 89196                                                                              ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;                                                                                           ;
;                                                                                           ;
;A	lógica	principal	do jogo	a	desenvolver	consiste	na	leitura	de	um	registo	(R1);
;com	a	sequência	de	dígitos	secreta e comparação	com o	conteúdo	de	outro	;
;registo (R2) que	contém	a	jogada	atual	do	jogador	D.                              ;
;                                                                                           ;
;                                                                                           ;
;                                                                                           ;
;                                                                                           ;
;                                                                                           ;
;                                                                                           ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;START          MID         END                                                                 ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;

;Parameter's about the code :

size            equ         4               ;Tamanho da senha
maxj            equ         12              ;Maximo de jogadas permitidas
msp             equ         FDFFh           ; SP = FDFFh (Padrao)
lmt             equ         '$'             ;Character para final de strings, Não deve ser utilizado a não ser com esse proposito.

IO              equ         FFFEh           ;endereço da saida de texto
NL              equ         000Ah           ;caracter de quebra de linha

tempTime        equ         FFF6h           ; em escrita ele define o tempo, e em leitura ele verifica o tempo
tempStart       equ         FFF7h           ; 1 para comecar e 0 para parar


                ORIG        8000h           ; (Data)

                ;variaveis
charx           word        'x'             ;ascii certo porem na ordem certa

pass            tab         4               ;alocacao de memoria para a senha do jogo
ans             tab         4               ;alocacao de memoria para a resposta do jogador
stat            tab         4               ;alocacao de memoria para a estado da jogada
; string          tab         32              ;alocacao de memoria para a geração de strings dinamicas  ; não implementado
roll            tab         1               ;alocacao de memoria para a contagem de estados
winer           tab         1

charo           word        'o'             ;ascii certo porem na ordem errada


random1         str         1,2,3,4,5,6
random2         str         4,5,6,1,2,3
random3         str         6,4,3,2,1,5

;senhas fixas para teste

pass0           str         6,1,2,3         ; 'str' is a string
pass1           str         1,2,3,4
pass2           str         2,3,4,5
pass3           str         3,4,5,6

                ORIG        0000h           ; (Code)

;Parametrizacao do programa :

                mov         r1,msp          ;Atribui para r1 o valor de SP [contante => msp]
                mov         sp,r1           ;Passa para sp o valor de r1

                mov         r1,312          ;Criar entrada aleatoria do estado da função random
                mov         m[roll],r1

                mov         r6,r0           ;contador jogadas
                mov         r7,r0           ;condição de vitória



;;;;verifica













































































































;The end of code
