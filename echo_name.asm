;echo_name.asm
section .data
    
    userMsg db 'Please, enter a name:',0 
    lenUserMsg equ $-userMsg             
    
    msg db "Hello, ",0
    msglen EQU $-msg
    
    leninput equ 32
section .bss
    input resb leninput+1
section .text
	global main
main:
    mov rax,1
    mov rsi,userMsg
    mov rdx,lenUserMsg
    syscall
    
    mov rax,0
    mov rsi,input
    mov rdx, 32
    syscall
    
    mov rax,1
    mov rsi,msg
    mov rdx,msglen
    syscall
    
    mov rax,1
    mov rsi,input
    mov rdx,32
    syscall
    
    ret
    
    
