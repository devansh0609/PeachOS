section .asm
global gdt_load

gdt_load:
    mov eax, [esp+4]
    mov [gdt_descriptor + 2], eax           ; Loads dd (start address) part of gdt_descriptor 
    mov ax, [esp+8]
    mov [gdt_descriptor], ax                ; Loads dw (size) part of gdt_descriptor
    lgdt [gdt_descriptor]
    ret

section .data
gdt_descriptor:
    dw 0x00     ; Size
    dd 0x00     ; GDT start address