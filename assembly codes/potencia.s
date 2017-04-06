.text
	
	.global main
	main:
				
		movi r16, 7 		   #DEFINE A BASE
		movi r17, 3 		   #DEFINE A POTENCIA
		movi r18, 1 		   #CONTADOR DO LOOP
		mov r8, r16		   #atribui a primeira iteracao, colocando a base em r8
	
		Loop: 
		beq r18, r17, Endfor	   #verifica se o contador do loop e igual a potencia, ou seja, fim de calculo
		mul r8, r8, r16		   #multiplica a base por ela mesmo e armazena em r8
		addi r18, r18, 1	   #incrementa contador
		br Loop			   #volta para o loop, caso contador != potencia
		
		Endfor: 
		movia r9, resultado
		stw r8, 0(r9)		   #guarda o resultado na memoria
.data
resultado:
.word 0
