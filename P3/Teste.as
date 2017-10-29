

tempTime        equ FFF6h       ; em escrita ele define o tempo, e em leitura ele verifica o tempo
tempStart       equ FFF7h       ; 1 para comecar e 0 para parar

        orig 8000h

ver     str     0030h
ver2    str     '0'
        mov r7,'0'

        mov r1,10
        mov m[tempTime],r1
        mov r1,1
        mov m[tempStart],r1

lp:     mov r3,m[tempTime]
        cmp r0,m[tempTime]
        br.nz lp
        mov r2,2

fim: br fim
