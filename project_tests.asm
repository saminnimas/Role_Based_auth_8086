
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

; Make sure each fucntion is returned(ret) after call; otherwise program will end up in an infinite loop

.MODEL SMALL
.STACK 100H
.DATA                         
    ; DEFINE YOUR VARIABLES  
    
    strings db "victor$", "bruce$", "%"
    user db "victor"
    err dw "no match found$"
    
    l dw ? 
   
.CODE  
    MAIN PROC
        
        MOV AX, @DATA
        MOV DS, AX
        
        ; YOUR CODE STARTS HERE
        
        lea si, strings
        call check_valid_username
        mov l, cx
        jmp exit
        
        
        check_valid_username proc
            outer_loop:
                cmp cx, 7
                je exit_outer
                mov cx, 1 ; for tracking actual length for username input
                lea di, user
                
                inner_loop:
                    mov dl, [si]
                    cmp dl, "$"
                    je outer_loop
                    cmp dl, "%"
                    je return_false
                    mov bl, [di]
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
                
 
                mov ah, 2
                int 21h
                jmp outer_loop
        
        
        exit_outer:    
        ret
        check_valid_username endp

        
        return_false:
            lea dx, err
            mov ah, 9
            int 21h
        
        exit:
        ; YOUR CODE ENDS HERE
        MOV AX, 4C00H
        INT 21H

        
    ;MAIN ENDP
    END MAIN                   

ret




