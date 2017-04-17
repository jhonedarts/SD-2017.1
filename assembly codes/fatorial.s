.global main
.data
  saida:
  .word 0
  msgprompt: .asciz "Positive integer: "
  msgres1: .asciz "The value of factorial("
  msgres2: .asciz ") i "

.text
main:
  movia r20, saida
  # printing the prompt
  #printf("Positive integer: ");
  movia      r8, msgprompt    # load address of msgprompt into r8
  ldw      r4, 0(r8)       # load data from address in r8 into r4
  movi      r2, 4            # call code for print_string
  #syscall                   # run the print_string #syscall

  # reading the input int
  # scanf("%d", &number);
  movi      r2, 5            # call code for read_int
  #syscall                   # run the read_int #syscall
  movi    r8, 5          # store input in r8-------------------------------

  mov    r4, r8          # mov input to argument register r4
  addi    r27, r27, -12     # mov stackpointer up 3 words
  stw      r8, 0(r27)       # store input in top of stack
  stw      r31, 8(r27)       # store counter at bottom of stack
  call     factorial         # call factorial

  # when we get here, we have the final return value in 4(r27)

  ldw      r16, 4(r27)       # load final return val into r16

  # printf("The value of 'factorial(%d)' is:  %d\n",
  movia      r9, msgres1      # load msgres1 address into r9
  ldw      r4, 0(r9)       # load msgres1_data value into r4
  movi      r2, 4            # system call for print_string
  #syscall                   # print value of msgres1_data to screen

  ldw      r4, 0(r27)       # load original value into r4
  movi      r2, 1            # system call for print_int
  #syscall                   # print original value to screen

  movia      r10, msgres2      #load msgres2 address into r9
  ldw      r4, 0(r10)       # load msgres_data value into r4
  movi      r2, 4            # system call for print_string
  #syscall                   # print value of msgres2_data to screen

  mov    r4, r16          # mov final return value from r16 to r4 for return
  movi      r2, 1            # system call for print_int
  #syscall                   # print final return value to screen
  stw r16, 0(r20)

  addi    r27, r27, 12      # mov stack pointer back down where we started

  # return 0;
  movi      r2, 10           # system call for exit
  #syscall                   # exit!
  br exit

.text
factorial:
  # base  case - still in parent's stack segment
  ldw      r8, 0(r27)       # load input from top of stack into register r8
  #if (x == 0)
  beq     r8, r0, returnOne # if r8 is equal to 0, branch to returnOne
  addi    r8, r8, -1      # subtract 1 from r8 if not equal to 0

  # recursive case - mov to this call's stack segment
  addi    r27, r27, -12     # mov stack pointer up 3 words
  stw      r8, 0(r27)       # store current working number into the top of the stack segment
  stw      r31, 8(r27)       # store counter at bottom of stack segment

  call     factorial         # recursive call

  # if we get here, then we have the child return value in 4(r27)
  ldw      r31, 8(r27)       # load this call's r31 again(we just got back from a jump)
  ldw      r9, 4(r27)       # load child's return value into r9

  ldw      r10, 12(r27)      # load parent's start value into r10
# return x * factorial(x-1); (not the return statement, but the multiplication)
  mul     r11, r9, r10     # multiply child's return value by parent's working value, store in r11.

  stw      r11, 16(r27)      # take result(in r11), store in parent's return value.

  addi    r27, r27, 12      # mov stackpointer back down for the parent call

  jmp      r31               # jump to parent call

.text
#return 1;
returnOne:
  movi      r8, 1            # load 1 into register r8
  stw      r8, 4(r27)       # store 1 into the parent's return value register
  jmp      r31               # jump to parent call
  
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
