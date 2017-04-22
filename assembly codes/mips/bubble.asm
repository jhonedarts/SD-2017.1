.global main
.data
.equ UART0, 0x860
  saida:
  .word 0
  swap: #64 words
  .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
  msgprompt: .asciz "Digite o numero para calcular o fatorial: "
  msgres1: .asciz "Fatorial = "
  msgres2: .asciz ") i "

.text
main:
  movia r20, swap		#memoria para swap
  addi r20, r20, 256 	#posiciona no final 64x4 =256
  movi r19, 10
movia r5, UART0

  movia r4, msgprompt    #print input2
  call nr_uart_txstring

  call scanf
  
  mov      r2, r22        # call code for read_int
  #syscall                # run the read_int #syscall
  mov    r8, r22       	  # store input in r8-------------------------------

  mov r4, r8        	  # mov input to argument register r4
  addi r27, r27, -4		  # mov stackpointer up 1 word
  addi r20, r20 -8			# mov swappointer up 2 word
  stw      r8, 0(r20)       # store input in top of stack
  stw      r31, 0(r27)       # store counter at bottom of stack
  call     factorial         # call factorial

  # when we get here, we have the final return value in 4(r27)

  ldw      r16, 4(r20)       # load final return val into r16


  ldw      r4, 0(r20)       # load original value into r4
  movi      r2, 1            # system call for print_int
  #syscall                   # print original value to screen

  mov    r4, r16          # mov final return value from r16 to r4 for return
  
  

  addi    r27, r27, 4      # mov stack pointer back down where we started
  addi r20,r20,8
  
  movia r4, msgres1    #print input2
  call nr_uart_txstring
  br printf
  


factorial: 
  # base  case - still in parent's stack segment
  ldw      r8, 0(r20)       # load input from top of stack into register r8
  #if (x == 0)
  beq     r8, r0, returnOne # if r8 is equal to 0, branch to returnOne
  addi    r8, r8, -1      # subtract 1 from r8 if not equal to 0

  # recursive case - mov to this call's stack segment
  addi    r27, r27, -4     # mov stack pointer up 1 word
  addi		r20, r20, -8	# mov swap pointer up 2 word
  stw      r8, 0(r20)       # store current working number into the top of the stack segment
  stw      r31, 0(r27)       # store counter at bottom of stack segment

  call     factorial         # recursive call

  # if we get here, then we have the child return value in 4(r20)
  ldw      r31, 0(r27)       # load this call's r31 again(we just got back from a jump)
  ldw      r9, 4(r20)       # load child's return value into r9

  ldw      r10, 8(r20)      # load parent's start value into r10
# return x * factorial(x-1); (not the return statement, but the multiplication)
  mul     r11, r9, r10     # multiply child's return value by parent's working value, store in r11.

  stw      r11, 12(r27)      # take result(in r11), store in parent's return value.

  addi    r27, r27, 4      # mov stackpointer back down for the parent call
  addi r20, r20, 8

  jmp r31               # jump to parent call

.text
#return 1;
returnOne:
  movi      r8, 1            # load 1 into register r8
  stw      r8, 4(r20)       # store 1 into the parent's return value register
  jmp      r31               # jump to parent call

scanf:  mov r23, r31
  sloop:  movia r4, UART0   
    call nr_uart_rxchar
    blt r2, r0, sloop
    mov r4, r2
    call nr_uart_txchar   
    bne r4, r19, cont #apertou enter sai do scanf 
    jmp r23 
  cont: mul r22, r22, r19
    subi r2, r2, 0x30
    add r22, r22, r2
    br sloop

printf:  
  mov r4, r16    ## printf result
  call nr_uart_txhex  ##
  
  
  exit:
  
  
# every function call has a stack segment of 12 bytes, or 3 words.
# the space is reserved as follows:
#   0(r27) is reserved for the initial value given to this call
# 4(r27) is the space reserved for a return value
# 8(r27) is the space reserved for the return address.
# calls may manipulate their parent's data, but parents may not
# manipulate their child's data.
# i.e: if we have a call A who has a child call B:
# B may run:
#   stw r8, 16(r27)
# which would store data from r8 into the parent's return value register
#   A, however, should not(and, in all cases I can think of, cannot) manipulate
#   any data that belongs to a child call.
# reference:
# https://gist.github.com/dcalacci/3747521
