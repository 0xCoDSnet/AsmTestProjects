; build with
;   1. nasm -fwin32 default.asm
;   2. gcc default.obj "$LIBPATH/kernel32.lib" "$LIBPATH/user32.lib" -nostdlib -s -Xlinker -e_main -mwindows
 
%include "io.inc"
[BITS 32]
extern _ExitProcess@4
extern _SendMessageA@16
extern _MessageBoxA@16


section .data
title dd 'Опросник',0
text dd 'да/нет? ',0
text_yes dd ':YES',0
text_no dd ':NO',0
SC_MONITORPOWER dd 0xF170
WM_SYSCOMMAND dd 0x0112
MONITOR_ON dd -1
MONITOR_OFF dd 2
MONITOR_STANBY dd 1

;section .bss     bss   align=4  ;read/write
;section .rdata rdata align=4    ;read
section .text
 
global _main

extern _printf
_main:
    mov ebp, esp; for correct debugging

    ;0 - 4
    ;text - 3
    ;title - 2
    ;0x00000024 - 1
    ;кладём всё в стек в оюратном порядке, так как win32api берёт всё из стека для взаимодействия с системой
    
    push 0x00000024 ;Выбор кастомизации окна, кнопки, иконки
    push title ;Огрлавление, название окошка
    push text ;текст внутри
    push 0 ;Владелец окна  
    call _MessageBoxA@16 ;Вызов функции
    call PRINT_UDEC 4, eax ; Смотрим в регистр eax и выводим код значения, полученный из  _MessageBoxA, возвращает какая кнопка была нажата
    
    mov ecx,6
    cmp eax,ecx
    je func_yes
    jmp func_no
    
func_yes:
     add esp, 4            ; clear the stack
     push text_yes
     call _printf
     call quit
func_no:
     add esp, 4            ; clear the stack
     push text_no
     call _printf
     call quit

    
quit:
    push dword 0 ; return 0, как в C/C++
    call _ExitProcess@4 