    #noam spokoini 301291001
    
.section    .rodata
wr_inp: .string "invalid input!\n"


.text	#the beginnig of the code

.globl	pstrlen	                       #the label "pstrlen" is used to state the initial point of this program
	.type	pstrlen, @function      # the label "pstrlen" representing the beginning of a function
pstrlen:	                                # the pstrlen function: receives a string and sends back its length

    movzbq      (%rdi),%rax
    ret

.globl	replaceChar	               #the label "replaceChar" is used to state the initial point of this program
	.type	replaceChar, @function # the label "replaceChar" representing the beginning of a function
replaceChar:	                       # the replaceChar function: gets 2 chars' and every time the first char is in
                                        # the string' it swaps it with the second char
                                        
    movq        %rsi,%r9                 #save old char in r9
    movq        %rdx,%r10                #save new char in r10
    leaq        1(%rdi),%rdi             # move to start of string
    movq        %rdi,%r11                #save string's address in r11
.is_end:
    cmpl        $0,(%rdi)               #if reached /0 then its the end of the string
    je          .end_char
    movb       (%rdi),%r8b
    cmpq        %r8,%r9               #if the char in this place is the char we need to replace
    je          .replace
    leaq        1(%rdi),%rdi             #else, move to next place on string' and do it all over again
    jmp         .is_end
.replace:
    movb        %r10b,(%rdi)             #replace char inside address of r11 to new char
    leaq        1(%rdi),%rdi             #move to next place on string' and do it all over again
    jmp         .is_end
.end_char:
    movq       $0, %rax     #clear rax
    movq       %r11, %rax     #enter string address to rax
    ret


.globl	pstrijcpy	                #the label "pstrijcpy" is used to state the initial point of this program
	.type	pstrijcpy, @function	# the label "pstrijcpy" representing the beginning of a function
pstrijcpy:	                         # the pstrijcpy function: receives to variables.one for start second for end
                                          # the function takes the part of source str according to i,j 
                                          #  and puts it inside dst string
    pushq	%r12			#save calee register                                      
    movl        %ecx,%r10d                #save j in r10
    movzbq      (%rsi),%r8               #insert the length of src string to r8
    movzbq      (%rdi),%r9               #insert the length of pstring1  to r8
    movq        %rsi,%r12                 #save string's address in r9
    movq        %rdi,%r11                #save string's address in r11
    cmpq        %r8,%r10                # Compare j(r10) to string length(r8)
    ja         .invalid_input            # if <, goto invalid input
    cmpq        %r9,%r10                # Compare j(r10) to second string length(r9)
    ja         .invalid_input            # if <, goto invalid input
    leaq        1(%rdi),%rdi             # move to start of string
    
    leaq        1(%rsi),%rsi             # move to start of  second string
    movq        %rsi,%r12                 #save string's address in r9
    movq        %rdi,%r11                 #save string's address in r9
    movq        $0,%r8
    movq        %rdx,%r8
    jmp         .is_end_copy
.is_end_copy:
    movq        %r12,%rsi
    movq        %r11,%rdi
    addq        %r8,%rsi            # move the pointer to point on the i index in dst string
    addq        %r8,%rdi            # move the pointer to point on the i index in src string

    cmpq        %r10,%r8            # Compare index(r8) to j
    ja         .end_cpy             # if >, goto end
    jmp        .copy_string
.copy_string:
    movb        (%rdi),%cl
    movb        %cl,(%rsi)           # copy char from src to dst
    addq        $1,%r8               # increase rdx (index) with 1 and do again
    jmp         .is_end_copy             
.end_cpy:
    movq       $0, %rax                  #clear rax
    subq       $1,%r12        
    movq       %r12,%rax
    popq	%r12
    ret
   
.invalid_input:                          #case if the j input is invalid
    movq    $wr_inp,%rdi
    movq    $0,%rax                      #clear rax
    call    printf
    addq    $1,%r12
    jmp     .end_cpy


.globl	swapCase	                         #the label "swapCase" is used to state the initial point of this program
	.type	swapCase, @function	# the label "swapCase" representing the beginning of a function
swapCase:	                         # the swapCase function: changes the char from lower to upper case and the opposite

    movq    %rdi,%r11                     # save the adress of string    
    addq    $1,%r11
.start:
    movzbq  (%r11),%r8
    cmpb    $0,%r8b                    # if 0, then end of string
    je      .end_case
    movq    $0,%r10
    addq    $91,%r10
    cmpq    %r10,%r8                  # 90, ascii value of upper case z
    jb      .check_if_upper              # if >, then we need to check if upper,else its lower case
    jmp     .check_if_lower_a
.check_if_upper:
    cmpq    $64,%r8                 # 65, ascii value of upper case a
    ja      .change_to_lower              # if <, then its a upper case char
    addq    $1,%r11                        # add 1 to index and do again
    jmp .start

.check_if_lower_a:
    cmpq    $123,%r8                   # 122, ascii value of lower case z
    jb      .check_if_lower_b              # if >, then its a lower case char
    addq    $1,%r11                        # add 1 to index and do again
    jmp .start
.check_if_lower_b:
    cmpq   $96, %r8                    # 97, ascii value of lower case a
    ja      .change_to_upper              # if <, then its a lower case char
    addq    $1,%r11                        # add 1 to index and do again
    jmp .start
.change_to_upper:
    subb    $32,%r8b                    #32 is the difference between upper and lower case                    
    movb    %r8b,(%r11)
    addq    $1,%r11                        # add 1 to index and do again
    jmp     .start          
.change_to_lower:
    addb    $32,%r8b                    #32 is the difference between upper and lower case
    movb    %r8b,(%r11)
    addq    $1,%r11                        # add 1 to index and do again
    jmp     .start 
.end_case:
    movq       $0, %rax                  #clear rax
    movq    %rdi,%rax
    ret

.globl	pstrijcmp	                 #the label "pstrijcmp" is used to state the initial point of this program
	.type	pstrijcmp, @function	# the label "pstrijcmp" representing the beginning of a function
pstrijcmp:	                         # the pstrijcmp function: receives i and j compars between string lixoraphiclly 

    movq        %rcx,%r10                #save j in r10
    movzbq      (%rsi),%r8               #insert the length of pstring1  to r8
    cmpq        %r8,%r10                # Compare j(r10) to string length(r8)
    ja         .invalid_input_cmp            # if >, goto invalid input
    movzbq      (%rdi),%r9               #insert the length of pstring1  to r8
    cmpq        %r9,%r10                # Compare j(r10) to string length(r8)
    ja         .invalid_input_cmp            # if <, goto invalid input
    movq        %rdx,%r10                #save i in r10
    cmpq        %r10,%r8                 # Compare i(rdx) to string length(r8)
    jb         .invalid_input_cmp        # if <, goto invalid_input_cmp
    cmpq        %r10,%r9                 # Compare i(rdx) to string length(r8)
    jb         .invalid_input_cmp        # if <, goto invalid_input_cmp
    addq        $1,%rsi             # move to start of string
    movq        %rsi,%r11                #save string's address in r11
    addq        $1,%rdi             # move to start of  second string
    movq        %rdi,%r9                 #save string's address in r9
    movq        $0,%r10                  #clear r10
    movq        $0,%r8                   #clear r8
    jmp         .is_end_cmp
.is_end_cmp:
    movq        %r11,%rsi                 # save string's address in r11
    movq        %r9,%rdi                  # save string's address in r11
    addq        %rdx,%rsi                 # move the pointer to point on the i index in dst string
    addq        %rdx,%rdi                 # move the pointer to point on the i index in src string
    cmpq        %rdx,%rcx                 # Compare index(rdx) to j
    jb         .end_cmp                   # if >, goto end
    jmp        .cmp_string
.cmp_string:
    movzbq      (%rsi),%r8
    addq        %r8,%r10            # add lixographic value of first string's char
    movzbq      (%rdi),%r8            # add lixographic value of second string's char
    subq        %r8,%r10            # add lixographic value of first string's char
    addq        $1,%rdx
    cmpq        $0,%r10                 #check value of %r10
    je         .is_end_cmp               # if =0, first and second are equal so continue until i=j 
    jmp         .end_cmp            #else check which is greater and finish 
.end_cmp:
    cmpq        $0,%r10                 #check value of %r10
    jl         .end_cmp_n1             # if 0>, second string is lix greater
    cmpq        $0,%r10                 #check value of %r10
    jg         .end_cmp_1               # if >0, first string is lix greater
    cmpq        $0,%r10                 #check value of %r10
    je         .end_cmp_0               # if =0, first an second are equal 
.end_cmp_0:
    movq       $0, %rax                  #clear rax
    ret
.end_cmp_1:
    movq       $1, %rax                  #clear rax
    ret

.end_cmp_n1:
    movq       $-1, %rax                  #clear rax
    ret
   
.invalid_input_cmp:                      #case if the j input is invalid
    movq    $wr_inp,%rdi
    movq    $0,%rax                      #clear rax
    call    printf
    movq    $-2,%rax
    ret
    
