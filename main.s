    #noam spokoini 301291001

.section	   .rodata
size_s: .string "%d"
string_s: .string "%s"

	.text	#the beginnig of the code
.globl	main	#the label "run_func" is used to state the initial point of this program
	.type	main, @function	# the label "main" representing the beginning of a function
main:	# the main function:

        pushq	%rbp		#save the old frame pointer
	movq	%rsp, %rbp	#create the new frame pointer
        pushq   %r12             #saving a callee save register. 
        pushq   %r13             #saving a callee save register. 
        
                 #first string

call int_input

movq    %rax,%r8             #save the int value as char in register
subq    %r8,%rsp               #allocate memory for string to recieve
subq    $2,%rsp                 #allocate memory for size of string and \0

movb    %r8b,(%rsp)               #insert the size of string in bottom of stack
movq    %rsp,%rsi
movq    %rsp,%r12
                                #getting ready for scanf
movq    $string_s,%rdi
addq    $1,%rsi
movq    $0,%rax                 #clear rax
call    scanf
                 #second string

call    int_input
movq    %rax,%r9             #save the int value as char in register
subq    %r9,%rsp               #allocate memory for string to recieve
subq    $2,%rsp                 #allocate memory for size of string and \0

movb    %r9b,(%rsp)               #insert the size of string in bottom of stack
movq    %rsp,%rsi
movq    %rsp,%r13
                                #getting ready for scanf
movq    $string_s,%rdi
addq    $1,%rsi
movq    $0,%rax                 #clear rax
call    scanf

        #getting user's choice


call   int_input 

movq    %rax,%rdi                 #send integer recieved in scanf
movq    %r12,%rsi                 # send pointer to first string's adress
movq    %r13,%rdx                 # send pointer to second string's adress
call    run_func

                        	#end of the main function:
    movq    $0, %rax     #return value is zero (just like in c - we tell the OS that this program finished seccessfully)
    popq    %r13		#restore old frame pointer (the caller function frame)
    popq    %r12		#restore old frame pointer (the caller function frame)
    movq    %rbp, %rsp	#restore the old stack pointer - release all used memory.
    popq    %rbp		#restore old frame pointer (the caller function frame)        
    ret			#return to caller function (OS)


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
	
