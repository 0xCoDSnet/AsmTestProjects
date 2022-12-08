%include "io.inc"

extern _ReadConsoleA@20 ; 20 - 5 args, 4 bytes - 1 args, => 5*4 = 20
extern _WriteConsoleA@20 
extern _GetStdHandle@4
extern _ExitProcess@4
extern _printf

section .bss
written dd ?
text dd ?
input_buffer:   resb 4                      ;reserve 64 bits for user input
char_written:   resb    4
chars:   resb 4                             ;reversed for use with write operation

section .text

STD_OUTPUT_HANDLE equ -11
STD_INPUT_HANDLE equ -10

console_text dw "123", 0xA,0xD
textlen equ $ - console_text 

global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    call zero_regist  
    
    call get_handler_write
    call console_write
    
    call zero_regist 
    
    call get_handler_read
    call console_read
    
    call zero_regist
    
    call get_handler_write
    
    push 0 ; lpReserved
    push 0 ; push dword written ; Pointer - written ; lpNumberOfCharsWritten
    push 20 ; nNumberOfCharsToWrite
    push dword input_buffer ; Pointer - text ; *lpBuffer 
    push ebx ; hConsoleOutput
    call _WriteConsoleA@20 
    
    
    call quit
console_read:
;BOOL WINAPI ReadConsoleA(
;  _In_     HANDLE  hConsoleInput,
;  _Out_    LPVOID  lpBuffer,
;  _In_     DWORD   nNumberOfCharsToRead,
;  _Out_    LPDWORD lpNumberOfCharsRead,
;  _In_opt_ LPVOID  pInputControl)
    push 0 ; always NULL
    push dword written ; lpNumberOfCharsRead
    push 20 ; nNumberOfCharsToRead
    push dword input_buffer ; buffer for text
    push ebx ; add STD_INPUT_HANDLE = -10
    call _ReadConsoleA@20
    ret
    

console_write:
;BOOL WINAPI WriteConsoleA(
;  _In_             HANDLE  hConsoleOutput,
;  _In_       const VOID    *lpBuffer,
;  _In_             DWORD   nNumberOfCharsToWrite,
;  _Out_opt_        LPDWORD lpNumberOfCharsWritten,
;  _Reserved_       LPVOID  lpReserved )
;
    push 0 ; lpReserved
    push 0 ; push dword written ; Pointer - written ; lpNumberOfCharsWritten
    push textlen ; nNumberOfCharsToWrite
    push dword console_text ; Pointer - text ; *lpBuffer 
    push ebx ; hConsoleOutput
    call _WriteConsoleA@20 
    ret
    
zero_regist:
    mov eax, 0
    mov ecx, 0
    mov edx, 0
    mov ebx, 0
    ret

get_handler_read:
    push STD_INPUT_HANDLE ; -10
    call _GetStdHandle@4
    mov ebx, eax
    ret
get_handler_write:
    push STD_OUTPUT_HANDLE ; -11
    call _GetStdHandle@4
    mov ebx, eax
    ret
        
quit:
    push 0
    call _ExitProcess@4