[BITS 32]

global _start
extern c_start
extern peachos_exit

section .asm

_start:
    call c_start
    call peachos_exit
    ret





; global _start

; _start:

; _loop:
;     call getkey
;     push eax
;     mov eax, 3  ; Command putchar
;     int 0x80
;     add esp, 4
;     jmp _loop

; getkey:
;     mov eax, 2  ; Command
;     int 0x80
;     cmp eax, 0x00
;     je getkey
;     ret

; section .data
; message: db 'I can talk with the kernel', 0