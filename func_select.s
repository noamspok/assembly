    #noam spokoini 301291001

.section .rodata
size_s: .string "%d"
char_s: .string " %c"
l_50a:  .string "first pstring length: %d"
l_50b:  .string ", second pstring length: %d\n"
l_51:   .string "old char: %c, new char: %c, first string: %s, second string: %s\n"
l_52:   .string "length: %d, string: %s\n"
l_53:   .string "length: %d, string: %s\n"
l_54:   .string "compare result: %d\n"
def_st: .string "invalid option!\n"


.align 8      # Align address to multiple of 8
.runfun:
   .quad .L0     #case 50, print the length of the 2 strings
   .quad .L1     #case 51, replacing old char with new char
   .quad .L2     #case 52, copying part of string to the other
   .quad .L3     #case 53, switching low case with up case and the other way around
   .quad .L4     #case 54, copying part of string to the other
   .quad .L5     #default case
   
	.text	#the beginnig of the code
.globl	run_func	#the label "run_func" is used to state the initial point of this program
	.type	run_func, @function	# the label "run_func" representing the beginning of a function
run_func:	# the run_func function:

    pushq   %r12           #saving a callee save register. 
    pushq   %r13           #saving a callee save register. 
    pushq   %r14           #saving a callee save register. 
    pushq   %r15           #saving a callee save register. 


    # Set up the jump table access
    
    leaq    -50(%rdi),%rcx         #Compute xi = x-50
    cmpq    $4,%rcx                # Compare xi:4
    ja      .L5                    # if <, goto default-case
    jmp *.runfun(,%rcx,8)          # Goto jt[xi]

        #case 50,print the length of the 2 strings
.L0:                                 

    movq    %rsi,%r12               # save pointer to first string's address
    movq    %rdx,%r13               # save pointer to second string's address
                                    # prepare for pstrlen
    movq    %r12,%rdi               #insert the address of first string to rdi
    movq    $0,%rax                 #clear rax
    call    pstrlen
                                    #getting ready for printf
    movq    $l_50a,%rdi
    movq    %rax,%rsi               #insert recieved value from strlen function into rsi
    movq    $0,%rax                 #clear rax
    call    printf
                                    # prepare for pstrlen    
    movq    %r13,%rdi               #insert the address of second string to rdi
    movq    $0,%rax                 #clear rax
    call    pstrlen
                                    #getting ready for printf
    movq    $l_50b,%rdi
    movq    %rax,%rsi               #insert recieved value from strlen function into rsi
    movq    $0,%rax                 #clear rax
    call    printf
    jmp .return
    

        #case 51, replacing old char with new char

.L1:                
    movq    %rsi,%r12               # send pointer to first string's address
    movq    %rdx,%r13               # send pointer to second string's address

    leaq    -2(%rsp),%rsp           #allocate memory for char to recieve
                                    #getting ready for scanf
    movq    $char_s,%rdi
    movq    %rsp,%rsi
    movq    $0,%rax                 #clear rax
    call    scanf
    movzbq  (%rsp),%r14              #save the char in register
    
                                    #getting ready for scanf
    movq     $char_s,%rdi
    movq     %rsp,%rsi
    movq     $0,%rax               #clear rax
    call     scanf
    movzbq   (%rsp),%r15           #save the char in register
    leaq    2(%rsp),%rsp           #return the stack pointer to top
                                   #prepare to call replaceChar for first prstring
    movq    %r12,%rdi              # send pointer to first string's address
    movq    %r14,%rsi             #insert old char into %rsi
    movq    %r15,%rdx              #insert new char into %rdx
    call    replaceChar
    movq    %rax,%r12              #get address of new string from replace char
    
                                   #prepare to call replaceChar for second prstring
    movq    %r13,%rdi              #send pointer to second string's address
    movq    %r14,%rsi             #insert old char into %rsi
    movq    %r15,%rdx              #insert new char into %rdx
    call    replaceChar
    movq    %rax,%r13              #get address of new string from replace char
                                   #prepare to call printf  
                                 
    movq    $l_51,%rdi             # insert "old char: %c, new char: %c,
                                   # first string: %s, second string: %s\n" to rdi
    movb    %r14b,%sil             #insert old char into %rsi
    movb    %r15b,%dl              #insert new char into %rdx
    movq    %r12,%rcx              #insert address of first string to %rcx
    movq    %r13,%r8               #insert address of first string to %r8
    movq    $0,%rax                #clear rax
    call    printf

    
    
    jmp .return

        #case 52, copying part of string to the other

.L2:
    movq    %rsi,%r12               # save pointer to first string's address
    movq    %rdx,%r13               # save pointer to second string's address
    call    int_input
    movq    %rax,%r14             #save i in register
    call    int_input    
    movq    %rax,%r11             #save j in register
    
                                  #prepare to call pstrijcpy
    movq    %r14,%rdx            #insert i into %rdx
    movb    %r11b,%cl            #insert j into %rcx
    movq    %r12,%rsi             # send pointer to first string's address
    movq    %r13,%rdi             #send pointer to second string's address
    call    pstrijcpy
    movq    %rax,%r12 
                                    #prepare to call pstrlen
    movq    %r12,%rdi
    movq    $0,%rax                 #clear rax
    call    pstrlen
    addq    $1,%r12                                 

                                    #prepare to call printf
    movq    $l_52,%rdi              # insert "length: %d, string: %s\n" to rdi              
    movq    %rax,%rsi               #enter the sting's length into rsi
    movq    %r12,%rdx               #enter the address of dest to rdx
    movq    $0,%rax                 #clear rax
    call    printf
    
                                    #prepare to call pstrlen
    movq    %r13,%rdi
    movq    $0,%rax                 #clear rax
    call    pstrlen
    addq    $1,%r13   
                                    #prepare to call printf
    movq    $l_52,%rdi              # insert "length: %d, string: %s\n" to rdi
    movq    %rax,%rsi               #enter the sting's length into rsi
    movq    %r13,%rdx               #enter the address of src to rdx
    movq    $0,%rax                 #clear rax
    call    printf                  

    jmp .return

        #case 53, switching lower case letters with upper case and the other way around

.L3:
    movq    %rsi,%r12               # save pointer to first string's address
    movq    %rdx,%r13               # save pointer to second string's address

                                    # preprae to call swapCase for first string
    movq    %r12,%rdi               # send pointer to first string's address
    call    swapCase
    movq    %rax,%r12               #get pointer to string after swapcase 
                                    #prepare to call pstrlen
    movq    %r12,%rdi
    movq    $0,%rax                 #clear rax
    call    pstrlen
    addq    $1,%r12                 # put r12 on start of string               
                                    #prepare to call printf
    movq    $l_53,%rdi              # insert "length: %d, string: %s\n" to rdi              
    movq    %rax,%rsi               #enter the sting's length into rsi
    movq    %r12,%rdx               #enter the address of first string to rdx
    movq    $0,%rax                 #clear rax
    call    printf
    
                                    #swapcase for second string
    movq    %r13,%rdi               # send pointer to second string's address
    call    swapCase
    movq    %rax,%r13               #get pointer to string after swapcase
                                    #prepare to call pstrlen
    movq    %r13,%rdi               
    movq    $0,%rax                 #clear rax
    call    pstrlen
    addq    $1,%r13                 #put r13 in start of string
                                    #prepare to call printf
    movq    $l_53,%rdi              # insert "length: %d, string: %s\n" to rdi
    movq    %rax,%rsi               #enter the sting's length into rsi  
    movq    %r13,%rdx               #enter the address of second string to rdx
    movq    $0,%rax                 #clear rax
    call    printf                  

    jmp .return

        #case 54, comparing part of string to the other

.L4:

    movq    %rsi,%r12               # save pointer to first string's address
    movq    %rdx,%r13               # save pointer to second string's address
    call    int_input
    movq    %rax,%r14               #save i in register
    call    int_input    
    movq    %rax,%r11              #save j in register
    
                                   # prepare to call pstrijcpy
    movq    %r14,%rdx              # insert i into %rdx
    movq    %r11,%rcx              # insert j into %rcx
    movq    %r12,%rsi              # send pointer to first string's address
    movq    %r13,%rdi              # send pointer to second string's address
    call    pstrijcmp 
    movq    %rax,%rsi              #insert the int recieved from pstrjcmp to rdi
    movq    $l_54,%rdi             # insert "compare result: %d\n" to rdi
    movq    $0,%rax                #clear rax
    call    printf                 

    jmp .return

        #defualt case

.L5:
    movq    $def_st,%rdi            # insert "invalid option" to rdi
    movq    $0,%rax                 # clear rax
    call    printf

    jmp .return



        #returning to caller function
        
.return:

	#end of the function:
        movq	$0, %rax         #return value is zero
        popq	%r15		#restore old frame pointer (the caller function frame)
        popq    	%r14		#restore old frame pointer (the caller function frame)
        popq	%r13		#restore old frame pointer (the caller function frame)
        popq    	%r12		#restore old frame pointer (the caller function frame)
	ret			#return to caller function (main)

	.type	int_input, @function	# the label "int_input" representing the beginning of a function
                                    #this function recieves an int input
int_input:

    leaq    -4(%rsp),%rsp           #allocate memory for first int to recieve
                                    #getting ready for scanf
    movq    $size_s,%rdi
    movq    %rsp,%rsi
    movq    $0,%rax                 #clear %rax
    call    scanf
    movzbq  (%rsp),%rax
    leaq    4(%rsp),%rsp           #return rsp to its place in the stack
    ret

