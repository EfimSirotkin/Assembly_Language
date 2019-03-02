;   Educational Example 
;How to implement Assembly cycles
;This programm is inititally prints the symbol with ascii-code al(register) to the screen 2000 times


CSEG segment   ;    Define the segment being used
org 100h       ;    The starting offset for a programm instructions

Begin:
    mov ax, 0B800h  ;   Loading the ax register
    mov es, ax      ;   Loading es via ax, because we can't get access to es directly
    mov di, 0       ;   Loading di. It's used to move through the screen
    mov al, 6       ;   Loading symbol's attribute
    mov ah, 31      ;   Loading the ascii-code of the symbol
    mov cx, 2000    ;   Loading counter register(number of repetition)
    
Next_face:          ;   Defining the loop("the head")    
    mov es:[di], ax ;   Loading the contets of ax to the es-segment with di-offset
    add di, 2       ;   Adding 2 to the di, so that we move the cursor to the next position on the screen
    loop Next_face  ;   The end of the loop("the tail")
    
    mov ah, 10h     ;   Loading the function-number for 16 interruption
    int 16h         ;   Loading interruption
    int 20h
    
CSEG ends
end Begin