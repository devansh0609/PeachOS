[BITS 32]

section .asm


global print:function
global peachos_getkey:function
global peachos_malloc:function
global peachos_free:function
global peachos_putchar:function
global peachos_process_load_start:function

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

; int peachos_getkey()
peachos_getkey:
    push ebp
    mov ebp, esp
    mov eax, 2 ; command getkey
    int 0x80
    pop ebp
    ret

; void putchar(char c)
peachos_putchar:
    push ebp
    mov ebp, esp
    mov eax, 3 ; Command putchar
    push dword[ebp+8] ; Variable "c"
    int 0x80
    add esp, 4
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

; void peachos_free(void* ptr)
peachos_free:
    push ebp
    mov ebp, esp
    mov eax, 5 ; Command Free (Frees the allocated memory for this process)
    push dword[ebp+8]
    int 0x80
    add esp, 4
    pop ebp
    ret

; void peachos_process_load_start(const char* filename)
peachos_process_load_start:
    push ebp
    mov ebp, esp
    mov eax, 6 ; Command 6 process load start (starts a process)
    push dword[ebp+8] ; Variable "filename"
    int 0x80
    ; After this command, we will not return from interrupt. 
    ; When task ends or switches back (somehow) then following code will be executed.
    ; Because the ip is has stored next line of this code.
    ; So we are not actually returning from the interrupt.
    add esp, 4
    pop ebp
    ret
