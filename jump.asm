; jump.asm
extern printf
section .data
    n1 dq 54
section .data
 number1 dq 66
 number2 dq 50
 fmt1 db "NUMBER1 > = NUMBER2",10,0
 fmt2 db "NUMBER1 < NUMBER2",10,0
section .bss
section .text
 global main
main:
    mov rbp, rsp; for correct debugging
 push rbp
 mov rbp,rsp
 mov rax, [number1] ; Передача чисел в регистры.
 mov rbx, [number2]
 cmp rax,rbx ; Сравнение регистров rax и rbx.
 jge greater ; Если rax больше или равен, то перейти к метке greater:.
 mov rdi,fmt2 ; Если rax меньше, продолжить здесь.
 mov rax,0 ; Регистр xmm не используется.
 call printf ; Вывод строки fmt2.
 jmp exit ; Переход к метке exit:.
greater:
 mov rdi,fmt1 ; Регистр rax больше.
 mov rax,0 ; Регистр xmm не используется.
 call printf ; Вывод строки fmt1.
exit:
 mov rsp,rbp
 pop rbp
 ret
