.model small
.stack 100h
.data
    message_input  db "Enter a line for sorting: $"
    message_result db "Result of sort: $"
    message_error  db "Error! $"
    message_line db "Your line: $"
    endline        db 10, 13, '$'

    line db 200 dup ('$')
.code

init macro
    mov ax, @data
    mov ds, ax
    mov es, ax
endm

clr_console macro
    push ax

    mov ax, 03h
    int 10h

    pop ax
endm

exit macro
    mov ah, 4Ch
    int 21h
endm

check_enter macro string
    local check
    local output_error_exit

    push ax
    jmp check

    output_error_exit:
        mov ax, 03h
        int 10h
        print_str message_error
        pop ax
        exit
    check:
        cmp string[0], '$'
        je output_error_exit
        pop ax
endm

input_correct_str macro in_str
    local input
    local input_cont
    local cnhg_tab_to_space
    local exit

    push ax
    push si

    mov si, offset in_str

    input:
        mov ah, 01h
        int 21h
        cmp al, 0Dh
        je  exit
        cmp al, 09h
        je cnhg_tab_to_space
        jmp input_cont

    input_cont:
        mov [si], al
        inc si
        jmp input

    cnhg_tab_to_space:
        mov al, " "
        jmp input_cont

    exit:
        pop si
        pop ax
endm

print_str macro out_str
    push ax
    push dx

    mov dx, offset out_str
    mov ah, 09h
    int 21h

    pop dx
    pop ax
endm

sort_string_words macro string
    jmp main_loop
    go_end:
        the_end string
    search_first_word:
        cmp byte ptr[si], ' '
        jne check_compare

        inc si

        cmp byte ptr[si], '$'
        je go_end

        jmp search_first_word
    check_compare:
        cmp dx, 0
        jne compare 

        push si 
        mov dx, 1
        jmp loop_in_line
    loop_in_line:
        inc si

        cmp byte ptr[si], ' '
        je check_whitespace 

        cmp byte ptr[si], '$'
        jne loop_in_line

        cmp ax, 0
        jne main_loop

        jmp go_end 
    check_whitespace:
        cmp byte ptr[si+1], ' '
        je loop_in_line 

        inc si 

        jmp check_compare
    compare:
        pop di 
        push si
        push di
        mov cx, si
        sub cx, di
        repe cmpsb 
        dec si
        dec di
        xor bx, bx
        mov bl, byte ptr[di]
        cmp bl, byte ptr[si]
        jg change 
        pop di
        pop si
        push si

        jmp loop_in_line
    main_loop:
        print_str string
        print_str endline
        xor si, si
        xor di, di
        xor ax, ax
        xor dx, dx
        mov si, offset string
        jmp search_first_word
    change:
        inc al
        pop di
        pop si

        xor cx, cx
        xor bx, bx
        mov dx, si 
        jmp set_before_end_of_first_word
    set_before_end_of_first_word: 
        dec si
        inc cx

        cmp byte ptr [si-1], ' '
        je set_before_end_of_first_word

        jmp bring_in_stack_second_word
    bring_in_stack_second_word:
        dec si
        mov bl, byte ptr [si]
        push bx
        inc ah 
        cmp si, di
        jne bring_in_stack_second_word

        mov si, dx 

        jmp set_second_word_on_first_word_place
    set_second_word_on_first_word_place:  
        cmp byte ptr [si], "$"
        je set_all_spaces_between_words

        mov bl, byte ptr [si]
        xchg byte ptr [di], bl

        inc si
        inc di

        cmp  byte ptr [si], ' '
        jne set_second_word_on_first_word_place

        jmp set_all_spaces_between_words
    set_all_spaces_between_words:
        mov byte ptr[di], ' '
        inc di
        loop set_all_spaces_between_words

        mov si, di
        mov dx, si
        dec si

        jmp set_first_word_on_second_word_place
    set_first_word_on_second_word_place:
        inc si
        cmp byte ptr[si], '$'
        je main_loop

        pop bx
        mov byte ptr[si], bl

        dec ah

        cmp ah, 0
        je go_to_next_word

        jmp set_first_word_on_second_word_place
    go_to_next_word:
        push dx
        mov dx, 1
        xor cx, cx
        jmp loop_in_line
endm

the_end macro string
    print_str endline
    print_str message_result
    print_str string

    exit
endm

start:
    init

    print_str message_input
    input_correct_str line

    check_enter line

    clr_console
    print_str message_line
    print_str line
    print_str endline
    print_str endline

    sort_string_words line

    print_str line

    exit
end start
