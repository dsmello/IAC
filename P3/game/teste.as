IO  equ FFFEh
NL  equ 000Ah
    ORIG 0000h
mov R1, 'x'
mov M[IO], R1
mov R1, 'y'
mov M[IO], R1
mov R1, NL
mov M[IO], R1
mov R1, 'z'
mov M[IO], R1
