section .asm

extern int21h_handler
extern no_interrupt_handler
extern isr80h_handler

global int21h
global idt_load
global no_interrupt
global enable_interrupts
global disable_interrupts
global isr80h_wrapper

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


int21h:
    pushad
    call int21h_handler
    popad
    iret

no_interrupt:
    pushad
    call no_interrupt_handler
    popad
    iret

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