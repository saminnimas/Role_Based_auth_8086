; Make sure each function is called; otherwise program will end up in an infinite loop

.MODEL SMALL
.STACK 100H
.DATA                         
    ; DEFINE YOUR VARIABLES
    
    registered_users db "lara$", "victor$", "bruce$", "%" ; for varifying if the user_input for username is valid
    incorrect_input db 0AH, 0DH, "Incorrect Username/Password$"
    l dw ?  
    
    enter_username dw "Enter Username: $" ; Output text prompting username
    enter_pass dw "Enter Password: $"     ; Output text prompting password
    
    entered_username db 20 dup(?)    ; Temporary array for storing and comparing prompted username with registered users 
    entered_password dw 20 dup(?)    ; Temporary array for storing and comparing prompted username with registered users password
    
    length dw ?   ; Temporary variable
    username_length dw ?    ; returned length from the "lencounter" procedure will be sotred here
    password_length dw ?    ; returned length from the "lencounter" procedure will be sotred here
    
    elem_num db ?
    new_line db 0AH, 0DH, "$"   ; prepared an arr to print new_line                      
    output db 0AH, 0DH, "Your Entered Stirng: $"
     
   
.CODE  
    MAIN PROC
        
        MOV AX, @DATA
        MOV DS, AX
        
        ; YOUR CODE STARTS HERE
        
        
        lea dx, enter_username
        mov ah, 9
        int 21h
        
        
        lea si, entered_username
        call take_input
        
        lea si, entered_username  ; getting offset of username input 
        mov bx, 0                 ; counter
        call lencounter
        mov dx, length
        mov username_length, dx
        
        
        lea dx, output
        mov ah, 9
        int 21h
        
        lea si, entered_username
        call print
        
        mov dx, 0
        
        lea dx, new_line
        mov ah, 9
        int 21h
        
        lea dx, enter_pass
        mov ah, 9
        int 21h
        
        
        lea si, entered_password
        call take_input
        
        lea si, entered_password  ; getting offset of username input 
        mov bx, 0                 ; counter
        call lencounter
        mov dx, length
        mov password_length, dx
        
        lea dx, output
        mov ah, 9
        int 21h
        
        lea si, entered_password
        call print
        
        lea si, registered_users
        ;add username_length, 1
        mov ax, username_length
        add ax, 1
        call check_valid_username
        mov l, cx
        jmp exit
        
        
        jmp exit
        
        
        ; Define all the functions here
        take_input proc
            ;mov bx, 0
            mov ah, 1
            while_input:
                int 21h
                ;mov entered_username[bx], al
                mov [si], al
                inc si
                cmp al, 13
                jne while_input
            dec si
            ;mov entered_username[bx], "$"
            mov [si], "$"
        ret
        take_input endp
        
                
        mov ah, 2
        mov dl, 10
        int 21h
        mov dl, 13
        int 21h
        
        
        print proc
            mov dx, [si]
            cmp dl, "$"
            je exit_print
            mov ah, 2
            int 21h
            inc si
            jmp print
        
        exit_print:    
        ret
        print endp    

        lencounter proc
            looop:
            mov al, [si]
            cmp al, "$"
            je endcount
            inc bx
            inc si
            jmp looop
    
            endcount:
            mov length, bx
            ret            
        lencounter endp
        
        check_valid_username proc
            outer_loop:
                
                cmp cx, ax
                je exit_outer
                
                mov cx, 1 ; for tracking actual length for username input
                lea di, entered_username
                
                inner_loop:
                    mov dl, [si]
                    cmp dl, "$"
                    je for_bigger_input ;fbi
                    cmp dl, "%"
                    je return_false
                    mov bl, [di]
                    cmp bl, "$"
                    je for_smaller_input
                    cmp dl, bl
                    jne continue
                    inc cx
                    inc si
                    inc di
                    jmp inner_loop
                    
                continue:
                    mov dl, [si]
                    inc si
                    cmp dl, "$"
                    je outer_loop
                    jmp continue
                    
                for_smaller_input:
                    jmp return_false
                    
                for_bigger_input:
                    cmp ax, cx
                    jg return_false
                    jmp outer_loop
                
 
                ;mov ah, 2
                ;int 21h
                jmp outer_loop
        
        
        exit_outer:    
        ret
        check_valid_username endp

        
        return_false:
            lea dx, incorrect_input
            mov ah, 9
            int 21h
        
        ; YOUR CODE ENDS HERE
        exit:
        MOV AX, 4C00H
        INT 21H

        
    ;MAIN ENDP
    END MAIN                   