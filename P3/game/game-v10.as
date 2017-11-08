;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;           Dados do projeto                                                                ;
;Aluno  :   Davi da Silveira Mello                                                          ;
;Numero :   89196                                                                           ;
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
ENDSP           equ         FDFFh           ; Endereço do StackPoint   ENDSP = FDFFh (Padrao)
lmt             equ         '$'             ;Character para final de strings, Não deve ser utilizado a não ser com esse proposito.

IO              equ         FFFEh           ;endereço da saida de texto
NL              equ         000Ah           ;caracter de quebra de linha

tempTime        equ         FFF6h           ; em escrita ele define o tempo, e em leitura ele verifica o tempo
tempStart       equ         FFF7h           ; 1 para comecar e 0 para parar
mask            equ         000Fh           ; Mascara para comparar as respostas
maskX           equ         AAAAh           ; Mascara para comparar as respostas
maskO           equ         DDDDh           ; Mascara para comparar as respostas


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


;senhas fixas para teste

pass0           str         6,1,2,3         ; 'str' is a string
pass1           str         1,2,3,4
pass2           str         2,3,4,5
pass3           str         3,4,5,6


;frases usadas no jogo

frase10         str         'Bem vindo ao nosso jogo$'
frase20         str         'O objetivo e descobrir o codigo em 12 tentativas$'
frase21         str         'No resultado , tera 4 catacteres$'
frase22         str         'Se tiver [ - ] significa espacos de livres$'
frase23         str         'Se tiver [ o ] significa que esta certo porem na ordem errada$'
frase24         str         'Se tiver [ x ] significa que esta certo porem na ordem certa$'
frase25         str         'O codigo sera composto pelos numeros de 1 a 6$'
frase30         str         'Digite uma sequencia de 4 digitos$'
frase31         str         'Voce tem 15 s$'
frase32         str         'Dev: A entrada deve ser feita usando o escreve registro$'
frase33         str         'Dev: A sua resposta sera (R1 - R2 - R3 -R4)$'
frase40         str         'Sequencia invalida$'
frase50         str         'Resultado da rodada$'
frase51         str         '-> Sua entrada : $'
frase52         str         '-> Resultado   : $'
frase60         str         'Voce ganhou$'
frase61         str         'Voce perdeu$'

;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
;...........................................................................................;
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;R1 => SENHA DO JOGO                                                                        ;
;R2 => JOGADA DO JOGADOR                                                                    ;
;                                                                                           ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;START          MID         END             ;Comments                                       ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;

                ORIG        0000h           ; (Code)

;Parametrizacao do programa :

                mov         r1,ENDSP        ;Atribui para r1 o valor de ENDSP [contante => ENDSP]
                mov         sp,r1           ;Passa para sp o valor de r1
                mov         r1,1122h        ;Senha do jogo


                mov         r2,2211h

;ERROS:



; ciclo:          cmp         r2,r0
;                 br.z        ciclo
;                 mov         r3,frase60
;                 push        r3
;                 call        print






ciclo:          push        r0
                push        r1
                push        r2
                call        verifica
                pop         r7
                br          FIM








FIM:            br          FIM

;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
;...........................................................................................;
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Rotina : Print                                                                             ;
;                                                                                           ;
;Função print, só para facilitar a implementação                                            ;
;                                                                                           ;
;caracter especial de parada definido pela constante  "lmt", para uso deve se passar pela   ;
;pilha o endereço da string que deverá conter no final da str, o char "lmt".                ;
;                                                                                           ;
;versão basica, utilizar com cuidado.                                                       ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;START          MID         END                                                             ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
print:          push        r2              ;guardando registros em uso
                push        r1              ;guardando registros em uso     sp+1
                mov         r1,m[sp+4]      ;endereço do inicio da str
                mov         r2,m[r1]        ;caracter no endereço de r1

printer:        cmp         r2,lmt
                jmp.z       printEnd
                cmp         r2,r0
                jmp.z       printjmp
                mov         m[IO],r2
printjmp:       inc         r1
                mov         r2,m[r1]
                br          printer

printEnd:       pop         r1
                pop         r2
                retn        1

;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Fim da rotina : Print                                                                      ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;...........................................................................................;
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;rotina : nl *adiciona uma quebra de lina no texto                                          ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
newl:           push        r1
                mov         r1, NL
                mov         M[IO], R1
                pop         r1
                ret

;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Fim da rotina : nl                                                                         ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;...........................................................................................;
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;verifica :                                                                                 ;
;Stack Pile:    m[sp+11] = resposta                                                         ;
;               m[sp+10] = senha da partida                                                 ;
;               m[sp+9] = resposta do jogador                                               ;
;                                                                                           ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;START          MID         END             ;Comments                                                ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;

verifica:       push        r1
                push        r2
                push        r3
                push        r4
                push        r5
                push        r6
                push        r7

                mov         r1,m[sp+10]     ;senha da partida
                mov         r2,m[sp+9]      ;resposta do jogador
                mov         r3,mask
                mov         r4,r0           ;variavel de comparação r1
                mov         r5,r0           ;variavel de comparação r2
                mov         r6,r0           ;resposta
                mov         r7,size         ;contador de ciclos de repetiçãoS

verifXLoop:     cmp         r7,r0
                br.z        verifInter
                mov         r4,r1
                mov         r5,r2
                and         r4,r3
                and         r5,r3
                cmp         r4,r5
                br.nz       verfXFalse

verfXTrue:      push        r2
                mov         r2,maskX
                and         r2,r3
                add         r6,r2
                pop         r2
                com         r3
                and         r2,r3
                com         r3
                rol         r3,4
                dec         r7
                br          verifXLoop


verfXFalse:     rol         r3,4
                dec         r7
                br          verifXLoop

;R2 = Só com os valores que não retornaram true
;R6 = Contem os as posições que retornaram True

verifInter:     mov         r3,mask
                mov         r7,size         ;contador de ciclos de repetiçãoS
                push        r7
                br          verifOML

verifOML:       pop         r7              ;Loop Externo
                cmp         r7,r0
                jmp.z       verifFilter
                dec         r7
                push        r7
                mov         r7,size


verifOLoop:     cmp         r7,r0           ;Loop interno
                br.z        verifOLStep
                mov         r4,r1
                mov         r5,r2
                and         r4,r3
                and         r5,r3
                cmp         r4,r5
                br.nz       verifOLF0

verifOLT0:      push        r2
                mov         r2,maskO
                and         r2,r3
                add         r6,r2
                pop         r2
                com         r3
                and         r2,r3
                com         r3
                rol         r1,4
                dec         r7
                br          verifOLoop

verifOLF0:      rol         r1,4
                dec         r7
                br          verifOLoop

verifOLStep:    rol         r3,4
                jmp         verifOML

;verificar Filter Loop X
;R1 ~ R5 , R7 "Estão Livres" Manter R6 => Resposta do Jogo
verifFilter:    mov         r1,r6           ;nova Resposta temporaria
                mov         r4,r0           ;nova Resposta final
                mov         r5,mask         ;Mascara da jogada
                mov         r6,size         ;Loop Interno
                mov         r7,size         ;Loop Externo


verifFLX:       cmp         r6,r0
                br.z        verifFLRes
                mov         r2,r1
                mov         r3,maskX
                and         r2,r5
                and         r3,r5
                cmp         r2,r3
                br.nz       verifFLXF

verifFLXT:      add         r4,r2
                rol         r4,4
                com         r5
                and         r1,r5
                com         r5
                rol         r1,4
                dec         r6
                dec         r7
                br          verifFLX


verifFLXF:      rol         r1,4
                dec         r6
                br          verifFLX


;verificar Filter Loop O
verifFLRes:     mov         r6,size

verifFLO:       cmp         r6,r0
                br.z        verificaFim
                mov         r2,r1
                mov         r3,maskO
                and         r2,r5
                and         r3,r5
                cmp         r2,r3
                br.nz       verifFLOF

verifFLOT:      add         r4,r2
                rol         r4,4
                com         r5
                and         r1,r5
                com         r5
                rol         r1,4
                dec         r6
                dec         r7
                br          verifFLO


verifFLOF:      rol         r1,4
                dec         r6
                br          verifFLO




verificaFim:    cmp         r7,r0
                br.nz       verificaFim1
                rol         r4,12
                cmp         r7,r0
                br.nz       verificaFimm

verificaFim1:   dec         r7
verificaFim2:   cmp         r7,r0
                br.z        verificaFimm
                rol         r4,4
                dec         r7
                br          verificaFim2

verificaFimm:   mov         m[sp+11],r4
                pop         r7
                pop         r6
                pop         r5
                pop         r4
                pop         r3
                pop         r2
                pop         r1
                retn        2


;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Fim da rotina : verifica                                                                   ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;...........................................................................................;
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Rotina : delay    *atrasa a execução , recebe um numero de delay pela ultima instrução da  ;
;                   pilha                                                                   ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;

delay:          push        r7
                mov         r7,m[sp+3]
                mov         m[tempTime],r7
                mov         r7,1
                mov         m[tempStart],r7

delayLp:        cmp         r0,m[tempTime]
                br.nz       delayLp
                pop         r7
                retn        1

;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Fim da rotina : delay                                                                      ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;...........................................................................................;
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Rotina : input    *passa os valores encontrados em R1 - R2 - R3 - R4 para a resposta do    ;
;                   jagador                                                                 ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;





;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Fim da rotina : input                                                                      ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;...........................................................................................;
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Rotina : printGame                                                                         ;
;                                                                                           ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;





;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Fim da rotina : printGame                                                                  ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;...........................................................................................;
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Rotina : winCond   *funcão de ação global no jogo (não restaura o valor de r7              ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;





;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Fim da rotina : winCond                                                                    ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;...........................................................................................;
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;






;Conjunto de esqueletos uteis para a criação de funções:
;
; Função:         push        r1
;                 push        r2
;                 push        r3
;                 push        r4
;                 push        r5
;                 push        r6
;                 push        r7
;
; FunçãoFim:      pop         r7
;                 pop         r6
;                 pop         r5
;                 pop         r4
;                 pop         r3
;                 pop         r2
;                 pop         r1
