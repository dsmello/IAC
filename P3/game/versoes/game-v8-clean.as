
size            equ         4               ;Tamanho da senha
maxj            equ         12              ;Maximo de jogadas permitidas
msp             equ         FDFFh           ; SP = FDFFh (Padrao)
lmt             equ         '$'             ;Character para final de strings, Não deve ser utilizado a não ser com esse proposito.
IO              equ         FFFEh           ;endereço da saida de texto
NL              equ         000Ah           ;caracter de quebra de linha
tempTime        equ         FFF6h           ; em escrita ele define o tempo, e em leitura ele verifica o tempo
tempStart       equ         FFF7h           ; 1 para comecar e 0 para parar

                ORIG        8000h           ; (Data)

charx           word        'x'             ;ascii certo porem na ordem certa
pass            tab         4               ;alocacao de memoria para a senha do jogo
ans             tab         4               ;alocacao de memoria para a resposta do jogador
stat            tab         4               ;alocacao de memoria para a estado da jogada
roll            tab         1               ;alocacao de memoria para a contagem de estados
winer           tab         1
charo           word        'o'             ;ascii certo porem na ordem errada
random1         str         1,2,3,4,5,6
random2         str         4,5,6,1,2,3
random3         str         6,4,3,2,1,5
pass0           str         6,1,2,3         ; 'str' is a string
pass1           str         1,2,3,4
pass2           str         2,3,4,5
pass3           str         3,4,5,6
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
                ORIG        0000h           ; (Code)
                mov         r1,msp          ;Atribui para r1 o valor de SP [contante => msp]
                mov         sp,r1           ;Passa para sp o valor de r1
                mov         r1,312          ;Criar entrada aleatoria do estado da função random
                mov         m[roll],r1
                mov         r6,r0           ;contador jogadas
                mov         r7,r0           ;condição de vitória
start:          mov         r1,frase10      ;'Bem vindo ao nosso jogo$'
                push        r1
                call        print
                call        newl
                mov         r1,frase20      ;'O objetivo e descobrir o codigo$'
                push        r1
                call        print
                call        newl
                mov         r1,frase21      ;'No resultado , tera 4 catacteres$'
                push        r1
                call        print
                call        newl
                ; mov         r1,frase22
                ; push        r1
                ; call        print
                ; call        newl
                mov         r1,frase23      ;'Se tiver [ o ] significa que esta certo porem na ordem errada$'
                push        r1
                call        print
                call        newl
                mov         r1,frase24      ;'Se tiver [ x ] significa que esta certo porem na ordem certa$'
                push        r1
                call        print
                call        newl
                mov         r1,frase25      ;'Se tiver [ x ] significa que esta certo porem na ordem certa$'
                push        r1
                call        print
                call        newl
                call        random
                ;;;;;;;inicio da jogada
play:           mov         r1,frase30      ;'Digite uma sequencia de 4 digitos$'
                push        r1
                call        print
                call        newl
                mov         r1,frase31      ;'Voce tem 15 s$'
                push        r1
                call        print
                call        newl
                mov         r1,frase32      ;'Dev: A entrada deve ser feita usando o escreve registro$'
                push        r1
                call        print
                call        newl
                mov         r1,frase33      ;''Dev: A sua resposta sera (R1 - R2 - R3 -R4)$'
                push        r1
                call        print
                call        newl
                mov         r1,150          ;parametros do input * atraso de execução
                push        r1
                call        input           ;Executa a leitura dos registros tem um atraso de 15s para execução
                call        verficar        ;Verifica a resposta
                call        printGame       ;gera a saida da jogada
                call        winCond         ;vericica se foi atingido a condição de vitória
                mov         r5,88FFh        ;POnto unico para debug
                cmp         r7,r0
                jmp.nz      win             ;vai para a vitória
                cmp         r6,maxj
                jmp.z       lost            ;vai para a derrotá
                push        r1
                mov         r1,stat
                mov         m[r1],r0
                inc         r1
                mov         m[r1],r0
                inc         r1
                mov         m[r1],r0
                inc         r1
                mov         m[r1],r0
                mov         m[winer],r0
                pop         r1
                inc         r6
                jmp         play            ;retorna a jogada
win:            mov         r1,frase60      ;'Voce ganhou$'
                push        r1
                call        print
                call        newl
                br          end
lost:           mov         r1,frase61      ;'Voce perdeu$'
                push        r1
                call        print
                call        newl
                br          end
end:            br          end             ;Laço de repetição do fim do programa
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
                mov         r3,pass          ;Endereço da memoria da senha do jogo
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
verfMid1:       cmp         r6,r0           ;Implementação correta
                br.z        verficar2
                dec         r6              ;reduz o contador de repetições
                cmp         r2,r4
                call.z      verfOkeiX       ;
                cmp         r2,r4
                call.nz     setWiner
                inc         r1
                inc         r3
                inc         r5
                call        verfMemo
                br          verfMid1
setWiner:       push        r1
                mov         r1,1
                mov         m[winer],r1
                pop         r1
                ret
verficar2:      mov         r7,size         ;Contador de repetições ii
                call        verfSet
verfMid2:       cmp         r7,r0           ; For [i]
                br.z        verfEnd
                call        verfMid2a       ; Chamada do For[ii]
                dec         r7
                inc         r5
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
reposta:        call        end             ;Resposta a verificaçao
endgame:        call        end             ;Final do jogo
game:           call        end             ;Estrutura do jogo
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
newl:           push        r1
                mov         r1, NL
                mov         M[IO], R1
                pop         r1
                ret
random:         push        r1              ;Salve registro em uso
                push        r2              ;Salve registro em uso
                push        r3              ;Salve registro em uso
                push        r4              ;Salve registro em uso
                push        r5              ;Salve registro em uso
                push        r6              ;Salve registro em uso
                mov         r1,1337         ;Set o tempo para o contador
                mov         r2,1            ;Comando de Liga ou Desliga
                mov         r3,0            ;registro aonde se encontrara o tempo restante
                mov         r4,6            ;Dividendo da operação
                mov         r5,pass         ;Endereço da memoria da senha do jogo
                mov         m[tempTime],r1
                mov         r2,1
                mov         m[tempStart],r2
                mov         r3,m[tempTime]  ;Numeros aleatorios para a senha do jogo
                mov         r4,6
                div         r3,r4
                mov         m[r5],r4
                inc         r5
                mov         r4,6
                div         r3,r4
                mov         m[r5],r4
                inc         r5
                mov         r4,6
                div         r3,r4
                mov         m[r5],r4
                inc         r5
                mov         r4,6
                div         r3,r4
                mov         m[r5],r4
                mov         r2,0
                mov         m[tempStart],r2
randomEnd:      pop         r6              ;Reestaura o estado do registro
                pop         r5              ;Reestaura o estado do registro
                pop         r4              ;Reestaura o estado do registro
                pop         r3              ;Reestaura o estado do registro
                pop         r2              ;Reestaura o estado do registro
                pop         r1              ;Reestaura o estado do registro
                ret
delay:          push        r7
                mov         r7,m[sp+3]
                mov         m[tempTime],r7
                mov         r7,1
                mov         m[tempStart],r7
delayLp:        cmp         r0,m[tempTime]
                br.nz       delayLp
                pop         r7
                retn        1
input:          push        r1              ;Salve registro em uso
                push        r2              ;Salve registro em uso
                push        r3              ;Salve registro em uso
                push        r4              ;Salve registro em uso
                push        r5              ;Salve registro em uso
                mov         r1,r0           ;Limpar qualquer informação
                mov         r2,r0           ;
                mov         r3,r0           ;
                mov         r4,r0           ;
                mov         r5,m[sp+7]
                push        r5
                call        delay
                mov         r5,ans          ;não foi criado nenhum loop, pois não haveria grandes ganhos
                mov         m[r5],r1
                inc         r5
                mov         m[r5],r2
                inc         r5
                mov         m[r5],r3
                inc         r5
                mov         m[r5],r4
inputEnd:       pop         r5              ;Reestaura o estado do registro
                pop         r4              ;Reestaura o estado do registro
                pop         r3              ;Reestaura o estado do registro
                pop         r2              ;Reestaura o estado do registro
                pop         r1              ;Reestaura o estado do registro
                ret
printGame:      push        r1              ;Salve registro em uso
                push        r2              ;Salve registro em uso
                push        r3              ;Salve registro em uso
                push        r4              ;Salve registro em uso
                push        r5              ;Salve registro em uso
                push        r6              ;Salve registro em uso
                push        r7              ;Salve registro em uso
                mov         r1,frase50      ;'Resultado da rodada$'
                push        r1
                call        print
                call        newl
                mov         r1,frase51      ;'-> Sua entrada : $'
                push        r1
                call        print
                call        newl
                mov         r5,ans          ;não foi criado nenhum loop, pois não haveria grandes ganhos
                mov         r1,m[r5]
                add         r1,0030h
                mov         m[IO],r1
                inc         r5
                mov         r1,m[r5]
                add         r1,0030h
                mov         m[IO],r1
                inc         r5
                mov         r1,m[r5]
                add         r1,0030h
                mov         m[IO],r1
                inc         r5
                mov         r1,m[r5]
                add         r1,0030h
                mov         m[IO],r1
                call        newl
                mov         r1,frase52      ;'-> Resultado   : $'
                push        r1
                call        print
                call        newl
                mov         r6,size
                mov         r5,stat         ;
                mov         r7,r0
pGameL:         cmp         r6,r0
                br.z        pGameLA2
                mov         r1,m[r5]
                cmp         r1,r0
                br.z        pGameLA
                mov         m[IO],r1
                inc         r7
pGameLA:        inc         r5
                dec         r6
                br          pGameL
pGameLA2:       cmp         r7,size
                br.z        pGameEnd
                inc         r7
                mov         r1,'-'
                mov         m[IO],r1
                br          pGameLA2
pGameEnd:       call        newl
                pop         r7              ;Reestaura o estado do registro
                pop         r6              ;Reestaura o estado do registro
                pop         r5              ;Reestaura o estado do registro
                pop         r4              ;Reestaura o estado do registro
                pop         r3              ;Reestaura o estado do registro
                pop         r2              ;Reestaura o estado do registro
                pop         r1              ;Reestaura o estado do registro
                ret
winCond:        push        r4
                push        r3
                push        r2
                push        r1
                mov         r1,charx
                mov         r2,stat
                mov         r4,size
                cmp         r0,m[winer]
                br.nz       winCondEnd
winCondEnd1:    mov         r7,1
winCondEnd:     pop         r1
                pop         r2
                pop         r3
                pop         r4
                ret
