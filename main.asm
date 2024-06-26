; Make sure each function is called; otherwise program will end up in an infinite loop

.MODEL SMALL
.STACK 100H
.DATA                         
    ; DEFINE YOUR VARIABLES
    
    registered_users db "victor$", "bruce$", "lara$", "clerk$", "joy$", "jim$", "%" ; for varifying if the user_input for username is valid
    password_arr db "vic$", "Batcave28$", "raider$", "lane$", "enjoy$", "pam$", "%"  ; for varifying if the user_input for password is valid
    user_role db "t", "t", "s", "s", "s", "s", "%"  ; For Distinguishing between teachers and students
    id_s db "0", "0", "1", "2", "3", "4", "%"
    marks db "0$$", "0$$", "86$$", "80$$", "100$", "79$$", "%"
    
    incorrect_input db 0AH, 0DH, "Incorrect Username/Password$"
    validated db 0AH, 0DH, "!!WELCOME!!$"
    exit_text db 0AH, 0DH, "BYE  :($"
    l dw ?
    title_tags db 0AH, 0DH, "ID         Name        Marks$"  
    
    enter_username dw "Enter Username: $" ; Output text prompting username
    enter_pass dw "Enter Password: $"     ; Output text prompting password
    view_update dw "View Grades / Update Grades (v/u): $"
    logout_student dw "Logout (y): $"
    logout_teacher dw "Logout? (y/n): $"
    end_program dw "End Program? (y/n): $"
    id_for_update dw "Enter ID: $"
    enter_marks dw "Enter Marks: $"
    
    entered_username db 20 dup(?)    ; Temporary array for storing and comparing prompted username with registered users 
    entered_password db 20 dup(?)    ; Temporary array for storing and comparing prompted username with registered users password
    is_authenticated dw ?  ; For checking authentication status, 0 or 1 (i.e. True or False)
    set_role db ?
    set_id db ?
    set_marks dw ?
    loggedout db ?
    options db ?
    entered_end_program db ?
    
    length dw ?   ; Temporary variable
    username_length dw ?    ; returned length from the "lencounter" procedure will be sotred here
    password_length db ?    ; returned length from the "lencounter" procedure will be sotred here
    loaded_pass_length dw ?
    loading_pass db 1   ; By default laoding_pass is successful (1). But is 0 if conditions not met. check load_pass
    
    new_line db 0AH, 0DH, "$"   ; prepared an arr to print new_line
    space db 32, "$"            ; prepared an arr to print space
    output db 0AH, 0DH, "Your Entered Stirng: $"
    
    elem_num db 0  ; for matching index number of registered_users with the prompted username. (getting the right user and their password)
    store_pass_start_idx dw 0  ; for storing the si, calculated from load_pass func
    store_pass_last_idx dw 0  ; for storing the last si, calculated from load_pass func, to get the stored pass's length
    student_username_si dw ?
    student_id_si dw ?
    student_mark_si dw ?
    loop_var db ?
    strlen db ?
    str db 5 dup(?)  ; Updated marks will be saved here temporarily
    update_id db ?
    mark_si_for_update db ?
     
   
.CODE  
    MAIN PROC
        
        MOV AX, @DATA
        MOV DS, AX
        
        ; YOUR CODE STARTS HERE
        
        ;call debug_si

        
        program_flow:
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
            
            
            ;lea dx, output
            ;mov ah, 9
            ;int 21h
            
            ;lea si, entered_username
            ;call print
            
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
            mov password_length, dl
            
            
            loggedin_flow:
            
                ;lea dx, output             ; uncomment
                ;mov ah, 9                  ; uncomment
                ;int 21h                    ; uncomment
                
                ;lea si, entered_password   ; uncomment
                ;call print                 ; uncomment
                
                lea si, registered_users
                mov ax, username_length
                add ax, 1
                call check_valid_username
                mov l, cx
                
                call load_pass
                lea dx, new_line
                mov ah, 9
                int 21h
                
                mov si, store_pass_start_idx
                ;call print
                
                mov bx, store_pass_last_idx
                sub bx, store_pass_start_idx
                
                mov loaded_pass_length, bx
                
                call authenticate
                
                if_authenticated:
                    mov bx, is_authenticated
                    cmp bx, 0
                    je else_not_authenticated
                    
                    lea dx, new_line
                    mov ah, 9
                    int 21h
                    lea si, entered_username
                    call print
                
                    lea dx, new_line
                    mov ah, 9
                    int 21h
                
                    call get_role_id_marks
                    mov dl, set_role
                    cmp dl, "s"
                    je loggedin_student_info
                    jmp loggedin_teacher
                    
                    loggedin_student_info:
                                
                        lea dx, title_tags
                        mov ah, 9
                        int 21h
                        
                        lea dx, new_line
                        mov ah, 9
                        int 21h
                        
                        mov dl, set_id
                        mov ah, 2
                        int 21h
                        
                        ;lea dx, space
                        ;mov ah, 9
                        ;int 21h
                        call print_spaces
                        
                        lea si, entered_username
                        call print
                        
                        ;lea dx, space
                        ;mov ah, 9
                        ;int 21h
                        call print_spaces
                        
                        
                        mov si, set_marks
                        mov ah, 2
                        
                        print_marks:
                            mov dx, [si]
                            cmp dl, "$"
                            je exit_print_marks
                            inc si
                            int 21h
                            jmp print_marks
                        
                        exit_print_marks:
                        jmp logout_option_stu
                    
                    loggedin_teacher:
                        call view_grades
                        ;mov si, student_username_si
                        ;call print
                        ;mov student_username_si, si
                        lea dx, view_update
                        ;call print
                        mov ah, 9
                        int 21h
                        
                        
                        lea si, options
                        call take_input
                        
                        lea si, options
                        mov bx, [si]
                        cmp bl, "v"
                        je jump_to_view
                        cmp bl, "u"
                        je jump_to_update
                        jmp invalid_key
                        
                        jump_to_view:
                            ;mov si, student_username_si
                            ;call print
                                
                            lea dx, title_tags
                            mov ah, 9
                            int 21h
                            
                            lea dx, new_line
                            mov ah, 9
                            int 21h
                            
                            mov loop_var, 4
                            print_view_loop:
                                mov bl, loop_var
                                cmp bl, 0
                                je exit_print_view_loop
                                mov si, student_id_si
                                mov dx, [si]
                                mov ah, 2
                                int 21h
                                add student_id_si, 1
                                
                                mov bx, 0
                                call print_spaces
                                mov si, student_username_si
                                add si, 1
                                call lencounter
                                
                                mov si, student_username_si
                                add si, 1
                                
                                call print
                                mov student_username_si, si
                                
                                
                                ;call print_spaces
                                
                                mov ax, 10
                                sub length, 3
                                sub ax, length
                                mov cx, ax
                                custom_keep_spacing:
                                    lea dx, space
                                    mov ah, 9
                                    int 21h
                                loop custom_keep_spacing
                                
                                
                                
                                mov si, student_mark_si
                                mov bl, 1
                                call custom_perse_for_marks
                                mov student_mark_si, si
                                
                                
                                lea dx, new_line
                                mov ah, 9
                                int 21h
                                mov bl, loop_var
                                dec bx
                                mov loop_var, bl
                                jmp print_view_loop
                            exit_print_view_loop:
                            jmp exit_options
                        
                        jump_to_update:
                            lea dx, new_line
                            mov ah, 9
                            int 21h
                            lea dx, id_for_update
                            mov ah, 9
                            int 21h
                            lea si, update_id
                            call take_input
                            
                            
                            
                            
                            lea si, update_id
                            
                            set_si_for_update:
                                mov bx, [si]
                                cmp bl, "1"
                                je six
                                cmp bl, "2"
                                je ten 
                                cmp bl, "3"
                                je fourteen 
                                cmp bl, "4"
                                je eighteen
                            
                            six:     
                                mov mark_si_for_update, 6
                                lea dx, new_line
                                mov ah, 9
                                int 21h
                                lea dx, enter_marks
                                mov ah, 9
                                int 21h
                                lea si, str
                                call take_input
                                jmp exit_set_si_for_update 
                            ten:     
                                mov mark_si_for_update, 10
                                lea dx, new_line
                                mov ah, 9
                                int 21h
                                lea dx, enter_marks
                                mov ah, 9
                                int 21h
                                lea si, str
                                call take_input
                                jmp exit_set_si_for_update
                            fourteen:     
                                mov mark_si_for_update, 14
                                lea dx, new_line
                                mov ah, 9
                                int 21h
                                lea dx, enter_marks
                                mov ah, 9
                                int 21h
                                lea si, str
                                call take_input
                                jmp exit_set_si_for_update
                            eighteen:     
                                mov mark_si_for_update, 18
                                lea dx, new_line
                                mov ah, 9
                                int 21h
                                lea dx, enter_marks
                                mov ah, 9
                                int 21h
                                lea si, str
                                call take_input
                                jmp exit_set_si_for_update
                            exit_set_si_for_update:
                            call update
                            jmp exit_options
                        
                        invalid_key:
                            jmp exit_options
                        
                        
                        exit_options:
                        lea dx, new_line
                        mov ah, 9
                        int 21h
                        
                        lea dx, logout_teacher
                        mov ah, 9
                        int 21h
                        
                        lea si, loggedout
                        call take_input
                        
                        lea si, loggedout
                        mov bx, [si]
                        cmp bl, "y"
                        je break_loggedin_flow
                        
                        lea dx, new_line
                        mov ah, 9
                        int 21h
                        jmp if_authenticated
                    
                    
                    logout_option_stu:
                    ; out of 2 loops the inner "break" statement will go here
                    ; only add 'y' for student
                        lea dx, new_line
                        mov ah, 9
                        int 21h
                        lea dx, logout_student
                        mov ah, 9
                        int 21h
                        lea si, loggedout
                        call take_input
                        lea si, loggedout
                        mov bx, [si]
                        cmp bl, "y"
                        je break_loggedin_flow
                        lea dx, new_line
                        mov ah, 9
                        int 21h
                        jmp if_authenticated
            
            break_loggedin_flow:
                lea dx, new_line
                mov ah, 9
                int 21h
                lea dx, end_program
                mov ah, 9
                int 21h
                lea si, entered_end_program
                call take_input
                
                lea si, entered_end_program
                mov bx, [si]
                cmp bl, "y"
                je break_program_flow
                lea dx, new_line
                mov ah, 9
                int 21h
                jmp program_flow
            
            else_not_authenticated:
                lea dx, new_line
                mov ah, 9
                int 21h
                lea dx, end_program
                mov ah, 9
                int 21h
                lea si, entered_end_program
                call take_input
                
                lea si, entered_end_program
                mov bx, [si]
                cmp bl, "y"
                je break_program_flow
                lea dx, new_line
                mov ah, 9
                int 21h
                jmp program_flow

        break_program_flow:
        lea dx, exit_text
        mov ah, 9
        int 21h
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
                
                jmp outer_loop
        
        
        exit_outer:
            add elem_num, 1
            jmp exit_func
        
        return_false:
            mov elem_num, 0
            
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
                ;call print
                
                traverse_to_end_si:
                    mov dx, [si]
                    cmp dl, "$"
                    je exit_traverse_to_end_si
                    inc si
                    jmp traverse_to_end_si
                
                exit_traverse_to_end_si:
                mov store_pass_last_idx, si
                jmp exit_load_pass
                
            no_matching_username:
               mov loading_pass, 0
               ;lea dx, incorrect_input
               ;mov ah, 9
               ;int 21h
                
        exit_load_pass:
        ret
        load_pass endp
        ; load_pass start
                         
        
        ; authenticate start
        ;use elem_num, si from load_pass, the prompted password
        ;return by storing returned value in is_authenticated
        authenticate proc
            mov bl, elem_num
            cmp bl, 0
            jle authentication_false
            
            mov bl, loading_pass
            cmp bl, 0
            je authentication_false
            
            mov bl, password_length
            mov cx, loaded_pass_length
            cmp bl, cl
            jl authentication_false
            
            mov bl, password_length
            mov cx, loaded_pass_length
            cmp bl, cl
            jg authentication_false
            
            mov cx, loaded_pass_length
            
            authenticate_loop:
                lea bx, entered_password
                mov si, store_pass_start_idx
                
                mov ax, [bx]
                mov dl, [si]
                
                cmp al, dl
                jne authentication_false

                
                inc bx
                inc si
                
                loop authenticate_loop
            loop_terminated:
                mov is_authenticated, 1
                cmp cl, 0
                je exit_authenticate
            
            
           
            authentication_false:
                mov is_authenticated, 0
                jmp exit_authenticate
                
        exit_authenticate:
            mov bx, is_authenticated
            cmp bl, 1
            je authenticated
            lea dx, incorrect_input
            mov ah, 9
            int 21h
            jmp final_exit
            authenticated:
                lea dx, validated
                mov ah, 9
                int 21h
                jmp final_exit
        final_exit:    
        ret
        authenticate endp
        ; authenticate end
                                 
                                 
        ; get_role_id_marks start
        ;make sure this func in invoked only is is_authenticated is 1
        get_role_id_marks proc
            lea si, user_role
            mov bl, elem_num  ; looping variable
            
            while_for_role:
                cmp bl, 0
                je exit_while_for_role
                mov dx, [si]
                inc si
                dec bl
                jmp while_for_role
            
            exit_while_for_role:
            mov set_role, dl
            
            lea si, id_s
            mov bl, elem_num
            
            while_for_id:
                cmp bl, 0
                je exit_while_for_id
                mov dx, [si]
                inc si
                dec bl
                jmp while_for_id
            
            exit_while_for_id:
            mov set_id, dl
            
            lea si, marks
            mov bl, elem_num
            
            while_for_marks:
                cmp bl, 1
                je exit_while_for_marks
                inner_while:
                    mov dx, [si]
                    cmp dl, "$"
                    je iterate_dollar
                    inc si
                    jmp inner_while
                
                iterate_dollar:
                    inc si
                    mov dx, [si]
                    
                    cmp dl, "$"
                    je iterate_dollar
                    jmp exit_inner_while
                    
                exit_inner_while:
                dec bl
                jmp while_for_marks
                
            exit_while_for_marks:
            ;sub si, 1
            mov set_marks, si
            
 
        
        ret
        get_role_id_marks endp
        ; get_role_id_marks end
        
        custom_perse_for_marks proc
            
            cwhile_for_marks:
                cmp bl, 0
                je cexit_while_for_marks
                mov ah, 2
                cinner_while:
                    mov dx, [si]
                    cmp dl, "$"
                    je citerate_dollar
                    inc si
                    int 21h
                    jmp cinner_while
                
                citerate_dollar:
                    inc si
                    mov dx, [si]
                    
                    cmp dl, "$"
                    je citerate_dollar
                    jmp cexit_inner_while
                    
                cexit_inner_while:
                dec bl
                jmp cwhile_for_marks
                
            cexit_while_for_marks:
                ;sub si, 1
                ;mov set_marks, si
        ret    
        custom_perse_for_marks endp
        
        
        ; algorithm for updating start
        update proc
            mov bx, 0
            lea si, str  ; save the updated marks here
            call lencounter
            mov bx, length
            mov strlen, bl
            
            lea si, marks
            mov bl, strlen
            add bl, 1
            mov cx, bx
            mov bx, 0
            mov bl, mark_si_for_update
            add si, bx
            mov bx, 0
            ;mov dl, mark_si_for_update
            
            while:
                mov al, str[bx]
                mov [si], al
                inc bx
                inc si
            loop while
        ret
        update endp
        ; algorithm for updating end
        
        view_grades proc
            lea si, registered_users
            mov bx, 2  ; counter
            for_stu_si:
                cmp bl, 0
                je exit_for_stu_si
                mov dx, [si]
                cmp dl, "$"
                je decrement_counter
                inc si
                jmp for_stu_si
                
                decrement_counter:
                    dec bx
                    inc si
                    jmp for_stu_si
                exit_for_stu_si:
                    dec si
                    mov student_username_si, si
            
            lea si, id_s
            mov bx, 2  ; counter
            for_id_si:
                cmp bl, 0
                je exit_for_id_si
                inc si
                dec bx
                exit_for_id_si:
                    inc si
                    mov student_id_si, si
                    
                    
            lea si, marks
            mov bl, 2
            
            for_mark_si:
                cmp bl, 0
                je exit_for_mark_si
                inner_while_loop:
                    mov dx, [si]
                    cmp dl, "$"
                    je iterate_dollars
                    inc si
                    jmp inner_while_loop
                
                iterate_dollars:
                    inc si
                    mov dx, [si]
                    
                    cmp dl, "$"
                    je iterate_dollars
                    jmp exit_inner_while_loop
                    
                exit_inner_while_loop:
                dec bl
                jmp for_mark_si
                
            exit_for_mark_si:
            ;sub si, 1
            mov student_mark_si, si
                
            ;mov si, student_username_si
            ;mov ah, 2
            
            ;while1:
            ;    mov dx, [si]
            ;    cmp dl, "%"
            ;    je exit_while1
            ;    inc si
            ;    int 21h
            ;    jmp while1
        
            ;exit_while1:
            
            
        ret
        view_grades endp
        
        
        print_spaces proc
            mov cx, 10
            keep_spacing:
                lea dx, space
                mov ah, 9
                int 21h
            loop keep_spacing
            
        ret
        print_spaces endp
        
        
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