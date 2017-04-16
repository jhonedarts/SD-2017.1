.text
      movia r16, nums
      movia r21, size        # load address of size variable
      ldw r21, 0(r21)	    # load value of size

      ##################################################################
      # AT THIS POINT: r16 is the address of the start of the array
      #                r21 is the size (= 12)
      #################################################################
      
      ##################################################################
      # PUT CODE HERE FOR CALL
      ##############################
      # SAVE $a registers and r31 and $s registers
      ##############################
      addi r27, r27, -20
      stw r4, 0(r27)
      stw r5, 4(r27)
      stw r31, 8(r27)
      stw r16, 12(r27)
      stw r21, 16(r27)
      ##############################
      # Change $a registers
      ##############################
      add r4, r0, r16
      add r5, r0, r21
      ##############################
      # call
      ##############################
      call bubblesort
      ##############################
      # RELOAD $a registers and r31 and $s registers
      ##############################
      ldw r4, 0(r27)
      ldw r5, 4(r27)
      ldw r31, 8(r27)
      ldw r16, 12(r27)
      ldw r21, 16(r27)
      addi r27, r27, 20
      ##################################################################

                         
      ##################################################################
      # DO NOT MODIFY
      movia   r4, nums        # first argument for print (array)
      add  r5, r21, r0      # second argument for print (size)
      call  print            # call print routine. 
      movi   r2, 10          # system call for exit
      #syscall               # we are out of here.
      ##################################################################


########################################################################
# PUT CODE HERE FOR FUNCTION
bubblesort: # int[] arr(a0), int n(a1) 
      ##################################################################
      # IF STATEMENT
      movi r22, 1
      beq r5, r22, endsort 	# if n == 1 then goto over
      ############################
      # RETURN FROM FUNCTION
      ############################
      ##################################################################
      
      ##################################################################
      # FOR LOOP
      ##################################################################
      	add r17, r0, r0 	# br = 0
            add r8, r0, r0 	# target
       
            addi r18, r5, -1  	# n - 1
      while:			# while
      	cmplt r8, r17, r18	# br < n-1
      	bne r8, r22, done	# if br < n - 1 THEN continue, else GOTO done
      	
      	# Need arr[br] -> index = br * 4 so IF br = 4 THEN index = 16 (remember word size is 4)
      	add r9, r17, r17	# t1 = br + br
      	add r9, r9, r9	# t1 = br + br (br is now mulitplied by 4)
      	add r9, r4, r9
      		# r9 = index 0 + index br
      	ldw r10, 0(r9)		# load word at t1 which is arr[br]
      	
      	# Need arr[br+1] -> index = (br+1) * 4 so IF br = 4 THEN index = 20 (4+1=5 -> 5*4=20)
      	addi r11, r17, 1	# t3 = br + 1
      	add r11, r11, r11	# t3 = (br+1) + (br+1)
      	add r11, r11, r11	# t3 = (br+1) + (br+1) (br+1 is now multiplied by 4)
      	add r11, r16, r11	# t3 = index 0 + index br + 1
      	ldw r12, 0(r11)		# load word at t3 which is arr[br+1]
      	
      	add r8, r0, r0   # target
      	cmplt r8, r12, r10	# arr[br+1] < arr[br]
      	bne r8, r22, endif	# if cmplt NOT true, end of if
      	stw r10, 0(r11)		# swap br and br+1 -> br goes into br + 1 (address location)
      	stw r12, 0(r9)		# swap br+1 and br -> br + 1 goes into br (address location)
      endif:
      ##################################################################
      # RECURSIVE CALL
      	addi r17, r17, 1	# increment br
      	br while			# jump to the top of the loop
      done:
      ######################################
      # SAVE $a registers, r31
      ######################################
      	addi r27, r27, -12	
	stw r4, 0(r27)				
      	stw r5, 4(r27)				
      	stw r31, 8(r27)				
      ######################################
      # CHANGE $a registers
      ######################################
      	addi r5, r5, -1		# decrement the size of the array to search from 12, 11, 10 etc. 	
      ######################################
      # call
      ######################################
        call bubblesort     		# call bubblesort again
      ######################################
      # RELOAD $a registers, r31
      ######################################
        ldw r4, 0(r27)			
      	ldw r5, 4(r27)			
      	ldw r31, 8(r27)			
      	addi r27, r27, 12		
      ################################################################## 
      endsort:
      	jmp r31
      ##################################################################
      # RETURN FROM FUNCTION
      ##################################################################


.data
nums: .word 55,88,0,22,77,44,99,33,110,66,121,11            # "array" of 12 words to contain values
size: .word  12                                             # size of "array" 

########################################################################
#########  routine to print the numbers on one line. 
#########  don't touch anything below this line!!!!

      
.text
      print:
      add  r16, r0, r4  # starting address of array
      add  r9, r0, r5  # initialize loop counter to array size
      #movia   r4, head        # load address of print heading
      #movi   r2, 4           # specify Print String service
      ##syscall               # print heading
      
      out:  
      ldw   r4, 0(r16)      # load number for #syscall
      movi   r2, 1           # specify Print Integer service
      ##syscall               # print number
      
      #movia   r4, space       # load address of spacer for #syscall
      #movi   r2, 4           # specify Print String service
      ##syscall               # output string
      addi r16, r16, 4      # increment address
      addi r9, r9, -1     # decrement loop counter
      bge r9, r0, out         # repeat if not finished
      jmp   r31              # return
########################################################################

.data
saida:
#space:.asciiz  " "          # space to insert between numbers
#head: .asciiz  "Sorted array:\n"