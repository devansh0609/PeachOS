section .asm

extern int21h_handler
extern no_interrupt_handler
extern isr80h_handler
extern interrupt_handler

global idt_load
global no_interrupt
global enable_interrupts
global disable_interrupts
global isr80h_wrapper
global interrupt_pointer_table

enable_interrupts:
    sti
    ret

disable_interrupts:
    cli
    ret


idt_load:
    push ebp
    mov ebp, esp

    mov ebx, [ebp+8]
    lidt [ebx]
    pop ebp    
    ret


no_interrupt:
    pushad
    call no_interrupt_handler
    popad
    iret

%macro interrupt 1
    global int%1
    int%1:
        ; INTERRUPT FRAME START
        ; ALREADY PUSHED TO US BY THE PROCESSOR UPON ENTRY TO THIS INTERRUPT, we have
        ; uint32_t ip
        ; uint32_t cs
        ; uint32_t flags
        ; uint32_t sp
        ; uint32_t ss
        ; Pushes the general purpose registers to the stack
        pushad
        ; Interrupt Frame end
        push esp
        push dword %1
        call interrupt_handler
        add esp, 8
        popad
        iret
%endmacro

%assign i 0
%rep 512
    interrupt i
%assign i i+1
%endrep

isr80h_wrapper:
    ; INTERRUPT FRAME START
    ; ALREADY PUSHED TO US BY THE PROCESSOR UPON ENTRY TO THIS INTERRUPT, we have
    ; uint32_t ip
    ; uint32_t cs
    ; uint32_t flags
    ; uint32_t sp
    ; uint32_t ss
    ; Pushes the general purpose registers to the stack
    pushad

    ; INTERRRUPT FRAME END

    ; Push the stack pointer so that we are pointing to the interrupt frame
    push esp
    
    ; Eax contains the command that are kernel should execute
    ; EAX holds our command lets push it to the stack for isr80h_handler
    push eax
    call isr80h_handler
    mov dword[tmp_res], eax
    ; In 32 bit system, a word is 4 bytes.
    ; Since we have pushed twice above, we will add 8 to stack pointer
    add esp, 8

    ; Restore general purpose registers for user land
    popad
    mov eax, [tmp_res]
    iretd
    
section .data
; Inside here is stored the return result from isr80h_handler
tmp_res: dd 0

%macro interrupt_array_entry 1
    dd int%1
%endmacro
interrupt_pointer_table:
%assign i 0
%rep 512
    interrupt_array_entry i
%assign i i+1
%endrep