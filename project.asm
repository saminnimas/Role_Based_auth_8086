; Make sure each function is called; otherwise program will end up in an infinite loop

.MODEL SMALL
.STACK 100H
.DATA                         
    ; DEFINE YOUR VARIABLES
    
    registered_users db "lara$", "victor$", "bruce$", "%" ; for varifying if the user_input for username is valid
    password_arr db "raider$", "vic$", "Batcave28$", "%"     ; for varifying if the user_input for password is valid
    incorrect_input db 0AH, 0DH, "Incorrect Username/Password$"
    l dw ?  
    
    enter_username dw "Enter Username: $" ; Output text prompting username
    enter_pass dw "Enter Password: $"     ; Output text prompting password
    
    entered_username db 20 dup(?)    ; Temporary array for storing and comparing prompted username with registered users 
    entered_password dw 20 dup(?)    ; Temporary array for storing and comparing prompted username with registered users password
    
    length dw ?   ; Temporary variable
    username_length dw ?    ; returned length from the "lencounter" procedure will be sotred here
    password_length dw ?    ; returned length from the "lencounter" procedure will be sotred here
    loaded_pass_length dw ?
    
    new_line db 0AH, 0DH, "$"   ; prepared an arr to print new_line                      
    output db 0AH, 0DH, "Your Entered Stirng: $"
    
    elem_num db 0  ; for matching index number of registered_users with the prompted username. (getting the right user and their password)
    store_pass_start_idx dw 0  ; for storing the si, calculated from load_pass func
    store_pass_last_idx dw 0  ; for storing the last si, calculated from load_pass func, to get the stored pass's length
     
   
.CODE  
    MAIN PROC
        
        MOV AX, @DATA
        MOV DS, AX
        
        ; YOUR CODE STARTS HERE
        
        ;call debug_si
        
        
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
        
        call load_pass
        lea dx, new_line
        mov ah, 9
        int 21h
        
        mov si, store_pass_start_idx
        call print
        
        mov bx, store_pass_last_idx
        sub bx, store_pass_start_idx
        
        mov loaded_pass_length, bx
        
        
        jmp exit
        
        
        
        
        ; Define all the functions / Procedures from here
        
        ;take_input start
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
            mov [si], "$"
        ret
        take_input endp
        ;take_input end
        

        
        
        ;print start
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
        ;print start
        
        
        ; lencounter start
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
        ; lencounter end
        
        
        ;check_valid_username start
        check_valid_username proc
            mov elem_num, 0
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
                    je outer
                    jmp continue
                    
                outer:
                    add elem_num, 1
                    jmp outer_loop
                    
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
            add elem_num, 1
            jmp exit_func
        
        return_false:
            mov elem_num, 0
            lea dx, incorrect_input
            mov ah, 9
            int 21h
            
        exit_func:    
        ret
        check_valid_username endp
        ;check_valid_username end
        
        
        ; load_pass start
        load_pass proc
            lea si, password_arr
            mov bl, elem_num
            
            cmp bl, 0
            jg return_mapped_password
            
            jmp no_matching_username
            
            return_mapped_password:
                sub bx, 1
                get_index_of_pass:
                    per_pass:
                        mov dx, [si]
                        inc si
                        cmp dl, "$"
                        je dec_bx
                        cmp bl, 0
                        je exit_per_pass
                        jmp per_pass
                        dec_bx:
                            dec bx
                            jmp per_pass
                exit_per_pass:
                sub si, 1
                mov store_pass_start_idx, si           
                call print
                mov store_pass_last_idx, si
                jmp exit_load_pass
                
            no_matching_username:
               lea dx, incorrect_input
               mov ah, 9
               int 21h
                
        exit_load_pass:
        ret
        load_pass endp
        ; load_pass start
        
        
        
        
        
        
        
        
        debug_si proc
            lea si, password_arr
            mov ah, 2
            loooop:
                mov dx, [si]
                int 21h
                cmp dl, "%"
                je exit_loooop
                inc si
                jmp loooop
            
        exit_loooop:
        ret
        debug_si endp
        
        
        
        ; YOUR CODE ENDS HERE
        exit:
        MOV AX, 4C00H
        INT 21H

        
    ;MAIN ENDP
    END MAIN                   