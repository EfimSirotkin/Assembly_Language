; The programm prints all 254 ascii-symbols 2000 times(80x25) on the screen using procedure call and cycle hierarcy

seg segment     ;    Define the used segment
assume cs:seg, ds:seg, es:seg, ss:seg   ;   associate segment registers with used segment
org 100h    ;                               The starting offset

start:
    mov ax,0B800h   ;   Loading the ax register
    mov es, ax      ;   Loading es - non-direct access register   
    mov al, 1       ;   Loading the ASCII-code of symbol being output
    mov ah, 31      ;   Loading symbol's attribute
    mov cx, 254     ;   Loading counter register for our main loop     
    
Next_screen:        ;   The head of the main loop
    mov di, 0       ;   Moving the cursor on the screen to the beginning(top-left corner)
    call Out_chars  ;   Calling Out_chars procedure
    inc al          ;   Incrementing the contents of al(so preparing to print the following ASCII-symbol
    loop Next_screen;   The end of the main loop
    
    mov ah, 10h
    int 16h
    
    int 20h         ;   Returning to the operating system control
    
Out_chars proc      ;   The definition of procedure
    mov dx, cx      ;   Saving the contents of cx for use in main loop
    mov cx, 2000    ;   Reassigning the value of counter register
Next_face:
    mov es:[di], ax ;   Loading the sybmol's attributes to the es-segment with di offset
    add di, 2       ;   Moving the cursor to the next position on the screen
    loop Next_face  
    
    mov cx, dx      ;   Returning the value of cx back to use in main loop
    ret             ;   Returning to the 15 line after procedure call
Out_chars endp

seg ends
end start