[BITS 32]

section .asm

global restore_general_purpose_registers
global task_return
global user_registers

; void task_return(struct registers* reg);
task_return:
    mov ebp, esp
    ; PUSH THE DATA SEGMENT (SS WILL BE FINE)
    ; PUSH THE STACK ADDRESS
    ; PUSH THE FLAGS 
    ; PUSH THE CODE SEGMENT
    ; PUSH THE IP

    ; Let's access the structure passed to us
    mov ebx, [ebp + 4]
    ; push the data/stack selector (ss)
    push dword [ebx + 44]
    ; push the stack pointer
    push dword [ebx + 40]

    ; push the flags
    pushf
    pop eax         ; pop flags in eax register
    or eax, 0x200   ; For interrupts which will be called in iret instruction
    push eax

    ; push the code segment 
    push dword [ebx + 32]

    ; Push the ip to execute
    push dword [ebx + 28]       ; It will look for virtual address, since paging is enabled

    ; Setup some segment registers
    mov ax, [ebx + 44]
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    push dword [ebp + 4]
    call restore_general_purpose_registers
    add esp, 4                              ; Basically, poping the address of function called (restore_generel.. one)

    ; Let's leave kernel land and execute user land!
    iretd

; void restore_general_purpose_registers(struct registers* reg); 
restore_general_purpose_registers:
    push ebp
    mov ebp, esp
    mov ebx, [ebp + 8]
    mov edi, [ebx]
    mov esi, [ebx + 4]
    mov ebp, [ebx + 8]
    mov edx, [ebx + 16]
    mov ecx, [ebx + 20]
    mov eax, [ebx + 24]
    mov ebx, [ebx + 12]
    pop ebp
    ret

; void user_registers();
user_registers:
    mov ax, 0x23
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    ret