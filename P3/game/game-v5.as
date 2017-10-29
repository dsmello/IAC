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
;START          MID         END                                                                 ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;

;Parameter's about the code :

size            equ         4               ;Tamanho da senha
maxj            equ         12              ;Maximo de jogadas permitidas
msp             equ         FDFFh           ; SP = FDFFh (Padrao)
lmt             equ         '$'             ;Character para final de strings, Não deve ser utilizado a não ser com esse proposito.

IO              equ         FFFEh           ;endereço da saida de texto
NL              equ         000Ah           ;caracter de quebra de linha

                ORIG        8000h           ; (Data)

                ;variaveis

pass            tab         4               ;alocacao de memoria para a senha do jogo
ans             tab         4               ;alocacao de memoria para a resposta do jogador
stat            tab         4               ;alocacao de memoria para a estado da jogada
charo           word        'o'             ;ascii certo porem na ordem errada
charx           word        'x'             ;ascii certo porem na ordem certa

;senhas fixas para teste

pass0           str         6,1,2,3         ; 'str' is a string
pass1           str         1,2,3,4
pass2           str         2,3,4,5
pass3           str         3,4,5,6

;frases usadas no jogo

frase10         str         'Bem vindo ao nosso jogo$'
frase20         str         'O objetivo e descobrir o codigo$'
frase21         str         'No resultado , tera 4 catacteres$'
frase22         str         'Se tiver [ - ] significa espacos de livres$'
frase23         str         'Se tiver [ o ] significa que esta certo porem na ordem errada$'
frase24         str         'Se tiver [ x ] significa que esta certo porem na ordem certa$'
frase30         str         'Digite uma sequencia de 4 digitos$'
frase40         str         'Sequencia invalida$'
frase50         str         'Resultado da rodada$'
frase60         str         'Voce ganhou$'




;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;START          MID         END                                                             ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;

                ORIG        0000h           ; (Code)

;Parametrizacao do programa :

                mov         r1,msp          ;Atribui para r1 o valor de SP [contante => msp]
                mov         sp,r1           ;Passa para sp o valor de r1
;Programa :

start:          mov         r1,pass         ;Teste de resposta do jogador (1-2-3-2)
                mov         r2,1
                mov         m[r1],r2
                inc         r1
                mov         r2,3
                mov         m[r1],r2
                inc         r1
                mov         r2,0
                mov         m[r1],r2
                inc         r1
                mov         r2,4
                mov         m[r1],r2

                mov         r1,ans          ;Teste de senha para o jogo (1-2-4-2)
                mov         r2,1
                mov         m[r1],r2
                inc         r1
                mov         r2,2
                mov         m[r1],r2
                inc         r1
                mov         r2,0
                mov         m[r1],r2
                inc         r1
                mov         r2,3
                mov         m[r1],r2

                call        verficar
                jmp         end


passGen:        jmp         end             ;Gera senha aleatoria para a partida

play:           jmp         end             ;Jogada do jogador

end:            br          end             ;Laço de repetição do fim do programa


;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Rotina : Verificar                                                                         ;
;                                                                                           ;
;Registros e Funções dos mesmos:                                                            ;
;      R1  ==  Endereço da memoria da resposta do jogador                                   ;
;      R2  ==  caracter verificado da resposta do jogador                                   ;
;      R3  ==  Endereço da memoria da senha do jogo                                         ;
;      R4  ==  caracter verificado da senha do jogo                                         ;
;      R5  ==  Endereço da memoria do resultado da partida                                  ;
;      R6  ==  Contador de repetições i                                                     ;
;      R7  ==  Contador de repetições ii                                                    ;
;                                                                                           ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;

;verfMemo : criado para setar a memoria de forma automatica

verfMemo:       mov         r2,m[r1]        ;caracter verificado da resposta do jogador
                mov         r4,m[r3]        ;caracter verificado da senha do jogo
                ret

verfOkeiO:      push        r1
                mov         r1,m[charo]
                mov         m[r5],r1
                pop         r1
                ret

verfOkeiX:      push        r1
                mov         r1,m[charx]
                mov         m[r5],r1
                pop         r1
                ret

verfSet:        mov         r1,ans          ;Endereço da memoria da resposta do jogador
                ; mov         r2,m[r1]        ;caracter verificado da resposta do jogador
                mov         r3,pass          ;Endereço da memoria da senha do jogo
                ; mov         r4,m[r3]        ;caracter verificado da senha do jogo
                call        verfMemo
                mov         r5,stat         ;Endereço da memoria do resultado da partida
                mov         r6,size         ;Contador de repetições i
                ret

verficar:       push        r1              ;Salve registro em uso
                push        r2              ;Salve registro em uso
                push        r3              ;Salve registro em uso
                push        r4              ;Salve registro em uso
                push        r5              ;Salve registro em uso
                push        r6              ;Salve registro em uso
                push        r7              ;Salve registro em uso

                call        verfSet
                ; br          verfMid1

verfMid1:       cmp         r6,r0           ;Implementação correta
                br.z        verficar2
                ; jmp.z        verfEnd       ;Para teste de "x" isolado
                dec         r6              ;reduz o contador de repetições
                cmp         r2,r4
                call.z      verfOkeiX       ;
                inc         r1
                inc         r3
                inc         r5
                call        verfMemo
                br          verfMid1

; verficar2:      call        verfSet         ;Remover na versão final
verficar2:      mov         r7,size         ;Contador de repetições ii
                ; mov         r5,stat
                ; mov         r1,ans
                ; br          verfMid2
                call        verfSet

verfMid2:       cmp         r7,r0           ; For [i]
                br.z        verfEnd
                call        verfMid2a       ; Chamada do For[ii]
                dec         r7
                inc         r5
                ; inc         r1
                br          verfMid2


verfMid2a:      push        r5              ;Guarda r5 na pilha
                push        r1
                call        verfSet         ;rotina que reseta e seta contadores e variaveis
                pop         r1
                pop         r5              ;Retorna r5 da pilha, pois esse é o unico que não deve ser mudado


verfMid2b:      cmp         r6,r0           ;Contador para o For[ii]
                br.z        verfMid2ar
                cmp         r0,m[r5]
                br.nz       verfMid2ar

; ghost:        para uma melhoria da teoria do jogo, deve se incluir
; ghost:        a condição de que se aquele ponto já foi verificado
; ghost:        ele não conta em outras posições, Talvez um modo "Easy"
; ghost:        ou "just True".

                mov         r2,m[r1]
                dec         r6              ;reduz o contador de repetições
                cmp         r2,r4
                call.z      verfOkeiO       ;
                inc         r3
                inc         r1
                mov         r4,m[r3]

                br          verfMid2b


verfMid2ar:     ret                         ;saida do ciclo For[ii] ou o Pass do python



verfEnd:        pop         r7              ;Reestaura o estado do registro
                pop         r6              ;Reestaura o estado do registro
                pop         r5              ;Reestaura o estado do registro
                pop         r4              ;Reestaura o estado do registro
                pop         r3              ;Reestaura o estado do registro
                pop         r2              ;Reestaura o estado do registro
                pop         r1              ;Reestaura o estado do registro
                ret
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Final da Rotina de Verificar                                                               ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;


reposta:        call        end             ;Resposta a verificaçao
endgame:        call        end             ;Final do jogo

game:           call        end             ;Estrutura do jogo

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


;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;START          MID         END                                                             ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
print:          push        r7              ;guardando registros em uso     sp+7 , usar o sp+9
                push        r6              ;guardando registros em uso
                push        r5              ;guardando registros em uso
                push        r4              ;guardando registros em uso
                push        r3              ;guardando registros em uso
                push        r2              ;guardando registros em uso
                push        r1              ;guardando registros em uso     sp+1

                mov         r1,m[sp+9]      ;endereço do inicio da str
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
                pop         r3
                pop         r4
                pop         r5
                pop         r6
                pop         r7
                retn        1

;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;Fim da rotina : Print                                                                      ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;


























;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
