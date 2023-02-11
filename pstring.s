//Ahmad Jorban 211437223
    .section	.rodata
    invalid_msg:	.string "invalid input!\n"
    .text
    .global pstrlen
    .type pstrlen, @function

    # This line defines the start of the pstrlen function.
    pstrlen:
    xor %rax, %rax  # This line sets the value of the %rax register to zero.
    # This line moves the value of the first byte (a single byte is referred to as a "movb") pointed to by %rdi into the %al register.
    # %rdi is a register that typically holds the address of the first argument passed to a function.
    movb	(%rdi), %al
    ret     # This line returns control to the calling function.



	.global replaceChar
	.type replaceChar, @function

replaceChar:
    # Initialize %rax to 0 and %rdi to point to the first character of the string
    xor %rax, %rax
    addq $1, %rdi

    # Loop through the string
    loop:
        # Load the current character into %al
        movb (%rdi), %al

        # If the character is null (end of string), go to the end
        cmpb $0, %al
        je end

        # If the current character is equal to %sil, replace it with %dl and go to the next character
        cmpb %al, %sil
        je replace
        addq $1, %rdi

        # If the current character is not equal to %sil, go to the next character
        jmp loop

    replace:
        # Replace the current character with %dl
        movb %dl, (%rdi)

        # Go to the next character
        jmp loop

    end:
        # Reset %rax to 0 and return
        xor %rax, %rax
        ret



    .globl swapCase
    .type swapCase, @function
swapCase:
    movzbq  (%rdi), %rbx        # save the lenght of the pstring in rbx
    addq    $1, %rdi            # go to the start on the string
    movq    $0, %rcx            # crate a counter i
    cmpb    %bl, %cl            # if i < len
    jg      end_swap
    while_swap:                    # while i < len
        cmpb    $90, (%rdi)     # if the letter value > 90 then it may be capital
        jg      capital
        cmpb    $65, (%rdi)     # if the letter value > 90 then its not a letter so skip
        jl      skip
        small:                  # the letter value is 65 - 90 so its capital add 32 to make it small
        addb    $32, (%rdi)     # add 32
        jmp     skip
        capital:
        cmpb    $122, (%rdi)    # if the letter value > 122 then its no a letter
        jg      skip
        cmpb    $97, (%rdi)     # if the letter value < 97 then its no a letter
        jl      skip
        subb    $32, (%rdi)     # the letter value is 97 - 122 so its small sub 32 to make it small
        skip:
        addq    $1, %rdi        # pstr++
        addb    $1, %cl         # i++
    cmpb    %bl, %cl            # while i < len
    jle      while_swap
    end_swap:                      # end of function
    ret

    .globl pstrijcpy
    .type pstrijcpy, @function
pstrijcpy:
    cmpb $0, %cl       # Compare the value in CL with 0
    jl invalid          # If the value in CL is less than 0, jump to the "invalid" label
    cmpb $0, %dl       # Compare the value in DL with 0
    jl invalid          # If the value in DL is less than 0, jump to the "invalid" label
    cmpb %dl, (%rdi)   # Compare the value in DL with the value at the memory address pointed to by RDI
    jle invalid         # If the value in DL is less than or equal to the value at the memory address pointed to by RDI, jump to the "invalid" label
    cmpb (%rdi), %cl   # Compare the value at the memory address pointed to by RDI with the value in CL
    jge invalid         # If the value at the memory address pointed to by RDI is greater than or equal to the value in CL, jump to the "invalid" label
    cmpb %dl, (%rsi)   # Compare the value in DL with the value at the memory address pointed to by RSI
    jle invalid         # If the value in DL is less than or equal to the value at the memory address pointed to by RSI, jump to the "invalid" label
    cmpb (%rsi), %cl   # Compare the value at the memory address pointed to by RSI with the value in CL
    jge invalid         # If the value at the memory address pointed to by RSI is greater than or equal to the value in CL, jump to the "invalid" label
    addq $1, %rdi       # Add 1 to the value in RDI
    addq $1, %rsi       # Add 1 to the value in RSI
    addq %rdx, %rdi     # Add the value in RDX to the value in RDI
    addq %rdx, %rsi     # Add the value in RDX to the value in RSI

    cmpb %cl, %dl       # Compare the value in CL with the value in DL
    jg end_cpy          # If the value in CL is greater than the value in DL, jump to the "end_cpy" label

    while_cpy:          # Label for the start of the while loop
        movb (%rsi), %r10b   # Move the value at the memory address pointed to by RSI into R10B
        movb %r10b, (%rdi)   # Move the value in R10B to the memory address pointed to by RDI
        incb %dl          # Increment the value in DL by 1
        incq %rdi          # Increment the value in RDI by 1
        incq %rsi          # Increment the value in RSI by 1
        cmpb %cl, %dl      # Compare the value in CL with the value in DL
        jle while_cpy      # If the value in CL is less than or equal to the value in DL, jump back to the "while_cpy" label

end_cpy:                # Label for the end of the while loop
    ret                 # Return from the function

    .globl pstrijcmp
    .type pstrijcmp, @function
pstrijcmp:
    # Check if cl (1st string length) is less than 0
    cmpb    $0, %cl
    jl      invalid_2
    # Check if dl (2nd string length) is less than 0
    cmpb    $0, %dl
    jl      invalid_2
    # Check if rdx (1st string offset) is less than or equal to 0
    cmpq    %rdx, (%rdi)
    jle      invalid_2
    # Check if 1st character of 1st string is greater than or equal to 2nd character of 2nd string
    cmpb    (%rdi), %cl
    jge      invalid_2
    # Check if 2nd character of 2nd string is less than or equal to 1st character of 1st string
    cmpb    %dl, (%rsi)
    jle      invalid_2
    # Check if 1st character of 2nd string is greater than or equal to 2nd character of 1st string
    cmpb    (%rsi), %cl
    jge      invalid_2
    # Increment rdi (1st string pointer) by 1
    addq    $1, %rdi
    # Increment rsi (2nd string pointer) by 1
    addq    $1, %rsi
    # Increment rdi by rdx (1st string offset)
    addq    %rdx, %rdi
    # Increment rsi by rdx (2nd string offset)
    addq    %rdx, %rsi
    # Compare cl and dl
    cmpb    %cl, %dl
    # If cl is greater than dl, jump to end_p2
    jg      end_p2
    # Loop until cl is not less than or equal to dl
    while_p2:
        # Set rbx (temporary register) to 0
        movq    $0, %rbx
        # Set r8 (temporary register) to 0
        movq    $0, %r8
        # Load value at rdi into bl (low 8 bits of rbx)
        movb    (%rdi), %bl
        # Load value at rsi into r8b (low 8 bits of r8)
        movb    (%rsi), %r8b
        # Compare r8b and bl
        cmpb    %r8b, %bl
        # If r8b is less than or equal to bl, jump to smaller
        jle     smaller
        # Set rax (result) to 1 and jump to end_p2
        movq    $1, %rax
        jmp     end_p2
        # If r8b is equal to bl, skip to next iteration
        smaller:
        cmpb    %r8b, %bl
        je      skip2
        # Set rax (result) to -1 and jump to end_p2
        movq    $-1, %rax
        jmp     end_p2
        # Skip to next iteration
        skip2:
        # Increment dl by 1
        addb    $1, %dl
        # Increment rdi by 1
        addq    $1, %rdi
        addq    $1, %rsi
    cmpb    %cl, %dl
    jle      while_p2
    movq    $0, %rax
    end_p2:
    ret


invalid:
    leaq    invalid_msg, %rdi
    movq    $0, %rax
    call    printf
    ret

invalid_2:       
    leaq    invalid_msg, %rdi
    movq    $0, %rax
    call    printf
    movq    $-2, %rax
    ret

