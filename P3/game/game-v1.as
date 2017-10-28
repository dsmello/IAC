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
size            equ         4               ;Tamanho da senha
maxj            equ         12              ;Maximo de jogadas permitidas
msp             equ         FDFFh           ; SP = FDFFh (Padrao)

                ORIG        8000h           ; (Data)

;senhas fixas para teste

pass0           str         6,1,2,3         ; 'str' is a string
pass1           str         1,2,3,4
pass2           str         2,3,4,5
pass3           str         3,4,5,6

;frases usadas no jogo

frase10         str         'Bem vindo ao nosso jogo'
frase20         str         'O objetivo e descobrir o codigo'
frase21         str         'No resultado , tera 4 catacteres'
frase22         str         'Se tiver [ - ] significa espacos de livres'
frase23         str         'Se tiver [ o ] significa que esta certo porem na ordem errada'
frase24         str         'Se tiver [ x ] significa que esta certo porem na ordem certa'
frase30         str         'Digite uma sequencia de 4 digitos'
frase40         str         'Sequencia invalida'
frase50         str         'Resultado da rodada'
frase60         str         'Voce ganhou'

;variaveis

pass            tab         4               ;alocacao de memoria para a senha do jogo
ans             tab         4               ;alocacao de memoria para a resposta do jogador
stat            tab         4               ;alocacao de memoria para a estado da jogada
charo           word        'o'             ;ascii certo porem na ordem errada
charx           word        'x'             ;ascii certo porem na ordem certa

;Parameter's about the code :

;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;
;START          MID         END                                                             ;
;-==-   -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-    -==-;

                ORIG        0000h           ; (Code)

;Parametrizacao do programa :

                mov         r1,msp          ;Atribui para r1 o valor de SP [contante => msp]
                mov         sp,r1           ;Passa para sp o valor de r1
;Programa :

start:          mov         r1,pass
                mov         r2,1
                mov         m[r1],r2
                inc         r1
                mov         r2,2
                mov         m[r1],r2
                inc         r1
                mov         r2,3
                mov         m[r1],r2
                inc         r1
                mov         r2,2
                mov         m[r1],r2

                mov         r1,ans
                mov         r2,3
                mov         m[r1],r2
                inc         r1
                mov         r2,2
                mov         m[r1],r2
                inc         r1
                mov         r2,4
                mov         m[r1],r2
                inc         r1
                mov         r2,2
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

verfSet:       mov         r1,ans          ;Endereço da memoria da resposta do jogador
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
                br          verfMid1

verfMid1:       cmp         r6,r0           ;Implementação correta
                br.z        verficar2
                dec         r6              ;reduz o Numero de repetições
                cmp         r2,r4
                call.z      verfOkeiX       ;
                inc         r1
                inc         r3
                inc         r5
                call        verfMemo
                br          verfMid1

verficar2:      call        verfSet
                mov         r7,size         ;Contador de repetições ii
                br          verfMid2

verfMid2:       cmp         r7,r0           ; For [i] ; /* FIXME */
                br.z        verfEnd
                call        verfMid2a
                dec         r7
                inc         r5
                br          verfMid2

verfMid2a:      cmp         r6,r0           ; For [ii]
                br.z        verfMid2ar
                dec         r6
                cmp         r2,r4
                call.z      verfOkeiO       ;
                inc         r1
                inc         r3

                call        verfMemo
                br          verfMid2a

verfMid2ar:     ret



verfEnd:        pop         r7              ;Reestaura o estado do registro
                pop         r6              ;Reestaura o estado do registro
                pop         r5              ;Reestaura o estado do registro
                pop         r4              ;Reestaura o estado do registro
                pop         r3              ;Reestaura o estado do registro
                pop         r2              ;Reestaura o estado do registro
                pop         r1              ;Reestaura o estado do registro
                ret

;Final da Rotina de Verificar

reposta:        call        end             ;Resposta a verificaçao
endgame:        call        end             ;Final do jogo

game:           call        end             ;Estrutura do jogo
