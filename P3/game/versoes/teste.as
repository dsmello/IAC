IO  equ FFFEh
NL  equ 000Ah
    ORIG 0000h

    mov r1,10
    mov r4,6
    div r1,r4

fim: br  fim
