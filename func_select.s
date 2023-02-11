//Ahmad Jorban 211437223
# This section contains read-only data
    .section    .rodata

# Align data to 8-byte boundary
.align 8

# Table of function pointers for different cases
choose:
    # Case 31
    .quad   len
    # Case 32
    .quad   replace
    # Case 33
    .quad   replace_2
    # Default case
    .quad   default
    # Case 35
    .quad   copy
    # Case 36
    .quad   swap
    # Case 37
    .quad   compare

# This section also contains read-only data
    .section    .rodata

# These are the strings to be printed for different cases
# Case 1
len_print:    .string "first pstring length: %d, second pstring length: %d\n"
# Case 2
case2_print:    .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
# Case 3
case3_print:    .string "length: %d, string: %s\n"
# Case 5
case5_print:    .string "compare result: %d\n"
# Invalid option
inval:    .string "invalid option!\n"

# These are the formats for scanf
# Format for integer input
format:    .string "%d"
# Format for character input
char:      .string " %c"
# Format for string input
str:       .string "%s"

# .text section is where executable code is stored
.text

# Declare run_func as a global symbol and define it as a function
.globl run_func
.type run_func, @function

# Start of the run_func function
run_func:
    # Save the base pointer and set the new base pointer
    pushq	%rbp
	movq	%rsp, %rbp

    # Allocate space on the stack for local variables
    subq    $32, %rsp

    # Save the second and third arguments in local variables
    movq    %rsi, -32(%rbp)
    movq    %rdx, -24(%rbp)

    # Save the first argument in a register
    movq    %rdi, %rbx

    # Subtract 31 from the first argument
    subq    $31, %rbx

    # Compare the first argument to 10
    cmpq    $10,%rbx

    # If the first argument is greater than 10, jump to default
    ja      default

    # Otherwise, jump to the address specified by the choose function
    # using the first argument as an index
    jmp     *choose(,%rbx,8)

# This label represents a case in a switch statement. It is not clear from the code what this case does.

len:
    # This instruction moves the value in the %rsi register to the %rdi register.
    movq    %rsi, %rdi
    # This instruction calls the pstrlen function, which is likely a function that returns the length of a string.
    call    pstrlen
    # This instruction moves the lowest 8 bits of the %al register to the %esi register, zero-extending the value to a full 32-bit value.
    movzbl  %al, %esi
    # This instruction moves the value in the %rdx register to the %rdi register.
    movq    %rdx, %rdi
    # This instruction calls the pstrlen function again, likely to get the length of a second string.
    call    pstrlen
    # This instruction moves the lowest 8 bits of the %al register to the %ecx register, zero-extending the value to a full 32-bit value.
    movzbl  %al, %ecx
    # This instruction loads the address of the case1_print label into the %rdi register.
    leaq    len_print, %rdi
    # This instruction moves the value in the %ecx register to the %edx register.
    movl    %ecx, %edx
    # This instruction moves the value 0 to the %eax register.
    movl    $0, %eax
    # This instruction calls the printf function, likely to print a string to the console.
    call    printf
    # This instruction jumps to the end label, which likely marks the end of the switch statement.
    jmp     end

replace:
    # Read two characters from standard input and store them in variables char and char
    leaq    char, %rdi
    leaq    -8(%rbp), %rsi
    xorq    %rax,%rax
    call    scanf

    leaq    char, %rdi
    leaq    -7(%rbp), %rsi
    xorq    %rax,%rax
    call    scanf

    # Replace the first character with the second character in the string stored in -32(%rbp)
    movq    $0, %rsi    # Set the index to 0
    movq    $0, %rdx    # Set the replacement character to 0
    movb    -8(%rbp), %sil   # Set the character to be replaced to the first character read from standard input
    movb    -7(%rbp), %dl   # Set the replacement character to the second character read from standard input
    movq    -32(%rbp), %rdi     # Set the string to be modified to the one stored in -32(%rbp)
    call    replaceChar     # Call the replaceChar function to replace the character

    # Replace the second character with the first character in the string stored in -24(%rbp)
    movq    -24(%rbp), %rdi     # Set the string to be modified to the one stored in -24(%rbp)
    call    replaceChar     # Call the replaceChar function to replace the character

    # Print the modified strings
    leaq    case2_print, %rdi   # Set the format string for printf
    movq    -32(%rbp), %rcx     # Set the first string to be printed to the one stored in -32(%rbp)
    movq    -24(%rbp), %r8  # Set the second string to be printed to the one stored in -24(%rbp)
    addq    $1, %rcx    # Increment the length of the first string by 1
    addq    $1, %r8     # Increment the length of the second string by 1
    call    printf  # Call printf to print the modified strings
    # Jump to end
    jmp end


replace_2:
    leaq    char, %rdi
    leaq    -8(%rbp), %rsi
    xorq    %rax,%rax
    call    scanf
    leaq    char, %rdi
    leaq    -7(%rbp), %rsi
    xorq    %rax,%rax
    call    scanf
    movq    $0, %rsi
    movq    $0, %rdx
    movb    -8(%rbp), %sil
    movb    -7(%rbp), %dl
    movq    -32(%rbp), %rdi
    call    replaceChar
    movq    -24(%rbp), %rdi
    call    replaceChar
    leaq    case2_print, %rdi
    movq    -32(%rbp), %rcx
    movq    -24(%rbp), %r8
    addq    $1, %rcx
    addq    $1, %r8
    call    printf
    jmp end

copy:
    # Load address of "format" string into rdi
    leaq    format, %rdi
    # Load address of memory at -16(%rbp) into rsi
    leaq    -16(%rbp), %rsi
    # Zero out rax
    xorq    %rax,%rax
    # Call scanf function with rdi and rsi as arguments
    call    scanf
    # Load the byte at -16(%rbp) into bl
    movb    -16(%rbp), %bl
    # Store the value in bl at -8(%rbp)
    movb    %bl, -8(%rbp)
    # Repeat the same steps as before to call scanf and store the value in bl at -7(%rbp)
    leaq    format, %rdi
    leaq    -16(%rbp), %rsi
    xorq    %rax,%rax
    call    scanf
    movb    -16(%rbp), %bl
    movb    %bl, -7(%rbp)
    # Zero out rcx and rdx
    movq    $0, %rcx
    movq    $0, %rdx
    # Load the byte at -8(%rbp) into dl
    movb    -8(%rbp), %dl
    # Load the byte at -7(%rbp) into cl
    movb    -7(%rbp), %cl
    # Load the address of the destination string into rdi
    movq    -32(%rbp), %rdi
    # Load the address of the source string into rsi
    movq    -24(%rbp), %rsi
    # Call pstrijcpy function with rdi, rsi, rcx, and rdx as arguments
    call    pstrijcpy
    # Load the address of the "case3_print" string into rdi
    leaq    case3_print, %rdi
    # Load the address of the destination string into rdx
    movq    -32(%rbp), %rdx
    # Load the first byte of the destination string into rsi
    movzbq  (%rdx), %rsi
    # Increment rdx by 1
    addq    $1, %rdx
    # Zero out rax
    movq    $0, %rax
    # Call printf function with rdi, rsi, and rdx as arguments
    call    printf
    # Repeat the same steps as before to print the first byte of the source string
    leaq    case3_print, %rdi
    movq    -24(%rbp), %rdx
    movzbq  (%rdx), %rsi
    addq    $1, %rdx
    movq    $0, %rax
    call    printf
    # Jump to "end" label
    jmp end


# If the letter is a lowercase alphabetical letter, it will be converted to uppercase.
swap:
    # Load the address of the first string into the rdi register
    movq    -32(%rbp), %rdi
    # Call the swapCase function to perform the case swap on the first string
    call    swapCase

    # Load the address of the second string into the rdi register
    movq    -24(%rbp), %rdi
    # Call the swapCase function to perform the case swap on the second string
    call    swapCase

    # Load the address of the case3_print string into the rdi register
    leaq    case3_print, %rdi
    # Load the address of the first string into the rdx register
    movq    -32(%rbp), %rdx
    # Load the first byte of the first string into the rsi register
    movzbq  (%rdx), %rsi
    # Increment the rdx register by 1
    addq    $1, %rdx
    # Set the rax register to 0
    movq    $0, %rax
    # Call the printf function using the case3_print string, the first byte of the first string, and the value in rax as arguments
    call    printf

    # Load the address of the case3_print string into the rdi register
    leaq    case3_print, %rdi
    # Load the address of the second string into the rdx register
    movq    -24(%rbp), %rdx
    # Load the first byte of the second string into the rsi register
    movzbq  (%rdx), %rsi
    # Increment the rdx register by 1
    addq    $1, %rdx
    # Set the rax register to 0
    movq    $0, %rax
    # Call the printf function using the case3_print string, the first byte of the second string, and the value in rax as arguments
    call    printf

    # Jump to the end label
    jmp end

compare:
    # This code compares two substrings and returns the result of the comparison.
    # The pstrijcmp function is then called to perform the comparison, and the result

    # Load the format string for scanf into %rdi
    leaq    format, %rdi

    # Load the address of the first substring into %rsi
    leaq    -16(%rbp), %rsi

    # Zero out %rax
    xorq    %rax,%rax

    # Call scanf to read in the first substring
    call    scanf

    # Load the first character of the first substring into %al
    movb    -16(%rbp), %al

    # Store the first character of the first substring at -8(%rbp)
    movb    %al, -8(%rbp)

    # Load the format string for scanf into %rdi
    leaq    format, %rdi

    # Load the address of the second substring into %rsi
    leaq    -16(%rbp), %rsi

    # Zero out %rax
    xorq    %rax,%rax

    # Call scanf to read in the second substring
    call    scanf

    # Load the first character of the second substring into %al
    movb    -16(%rbp), %al

    # Store the first character of the second substring at -7(%rbp)
    movb    %al, -7(%rbp)

    # Zero out %rcx and %rdx
    movq    $0, %rcx
    movq    $0, %rdx

    # Load the first character of the second substring into %dl
    movb    -8(%rbp), %dl

    # Load the first character of the first substring into %cl
    movb    -7(%rbp), %cl

    # Load the address of the second substring into %rdi
    movq    -32(%rbp), %rdi

    # Load the address of the first substring into %rsi
    movq    -24(%rbp), %rsi

    # Call pstrijcmp to compare the two substrings
    call    pstrijcmp

    # Load the address of the "case5_print" string into %rdi
    leaq    case5_print, %rdi

    # Load the result of the comparison into %rsi
    movq    %rax, %rsi

    # Zero out %rax
    movq    $0, %rax

    # Call printf to print the result of the comparison
    call    printf

    # Jump to the end of the code
    jmp end

default:
    leaq    inval,%rdi
    movq    $0, %rax
    call    printf
    jmp end

end:
    leave
    ret
