//Ahmad Jorban 211437223
    .section    .rodata
inputI: .string "%d"
inputS: .string "%s"
    .text
    .globl run_main
    .type run_main  , @function
run_main:
    pushq %rbp   # save the old frame pointer
    movq %rsp, %rbp  # set the new frame pointer
    subq $528, %rsp  #allocate space on the stack for local variables
    leaq -256(%rbp), %rsi   # load the address of the input string into %rsi
    leaq inputI, %rdi   # load the format string for integer input into %rdi
    movl $0, %eax   # clear the %eax register
    call scanf  # call the scanf function to read an integer from input
    movl -256(%rbp), %eax # Load the value at -256(%rbp) into %eax
    movl $0, -256(%rbp) # Set the value at -256(%rbp) to 0
    movb %al, -256(%rbp) # Move the lower byte of %al to -256(%rbp)
    movl $0, %eax # Set %eax to 0
    leaq -255(%rbp), %rsi # Load the address of -255(%rbp) into %rsi
    leaq inputS, %rdi # Load the address of inputS into %rdi
    call scanf # Call the scanf function
    movq $0, %rax # Set %rax to 0
    movb -256(%rbp), %al # Move the value at -256(%rbp) into %al
    addb $1, %al # Increment %al by 1
    leaq -255(%rbp, %rax), %rax # Load the address of -255(%rbp) + %rax into %rax
    movb $0, (%rax) # Set the value at %rax to 0
    movq $0, %rax # Set %rax to 0
    leaq -512(%rbp), %rsi # Load the address of -512(%rbp) into %rsi
    leaq inputI, %rdi # Load the address of inputI into %rdi
    movl $0, %eax # Set %eax to 0
    call scanf # Call the scanf function
    movl -512(%rbp), %eax # move the value at memory address -512(%rbp) to %eax register
    movl $0, -512(%rbp) # move the value 0 to memory address -512(%rbp)
    movb %al, -512(%rbp) # move the least significant byte of %al to memory address -512(%rbp)
    movl $0, %eax # move the value 0 to %eax register
    leaq -511(%rbp), %rsi # load the address of the memory location -511(%rbp) into %rsi
    leaq inputS, %rdi # load the address of the inputS variable into %rdi
    call scanf # call the scanf function to read in user input
    movq $0, %rax # move the value 0 to %rax register
    movb -512(%rbp), %al # move the least significant byte at memory address -512(%rbp) to %al
    addb $1, %al # add 1 to the value in %al
    leaq -511(%rbp, %rax), %rax # load the address of the memory location -511(%rbp) + value in %rax into %rax
    movb $0, (%rax) # move the value 0 to the memory location at the address in %rax
    movq $0, %rax # move the value 0 to %rax register

    movq $0, -520(%rbp) # move the value 0 to memory address -520(%rbp)
    leaq inputI, %rdi # load the address of the inputI variable into %rdi
    leaq -520(%rbp), %rsi # load the address of the memory location -520(%rbp) into %rsi
    call scanf # call the scanf function to read in user input

	movq	$0, %rax

	movl -520(%rbp), %edi			# save the option in rdi
	leaq -256(%rbp), %rsi			# save the pointer of the psring1 in rsi
	leaq -512(%rbp), %rdx			# save the pointer of the psring2 in rdx

	call run_func					# call run_func
	leave
	ret
