[BITS 32]

global print:function
global getkey:function
global peachos_malloc:function

; void print(const char* message)
print:
    push ebp
    mov ebp, esp
    ; Why +8? because ebp pushed (4 bytes) and where print was called, that address was pushed (4 bytes)
    ; this +8 would lead to message (first argument) provided to us.
    push dword[ebp+8]
    mov eax, 1  ; command print
    int 0x80
    add esp, 4
    pop ebp
    ret

; int getkey()
getkey:
    push ebp
    mov ebp, esp
    mov eax, 2 ; command getkey
    int 0x80
    pop ebp
    ret

; void* peachos_malloc(size_t size)
peachos_malloc:
    push ebp
    mov ebp, esp
    mov eax, 4 ; command malloc (Allocates memory for the process)
    push dword[ebp+8]   ; Variable "size"
    int 0x80
    add esp, 4
    pop ebp
    ret