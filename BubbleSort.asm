## Alunos: Luiz Felipe de Oliveira
##			  Gabriel Alexandre dos Santos
#------------------------------------------------------------------------------
# Programa BubleSort: ordenação pelo método da bolha
#------------------------------------------------------------------------------
# Para visualização correta do programa fonte, configure editor no MARS:
#		Ir em Settings -> Editor
#		Selecionar Tab Size = 3 (dar Apply and Close)
#------------------------------------------------------------------------------
						.text										# Área de código
#------------------------------------------------------------------------------
												# Inicialização
main:		addi	$v0, $zero, 4			# Chamada ao sistema para escrever string na tela
			la	$a0, msg1					# $a0 = endereço da string a ser escrita na tela
			syscall	
	
			addi $s0, $zero, 1			## $s0: trocou = true
			la   $s6, n						## $s6 = endereço de n
			lw   $s6, 0($s6)				## $s6 = conteudo de n				
			jal mostra_vetor																									
			addi $s1, $s6, -1				## $s1:limite = n-1
	
while:	slt  $s2, $zero, $s1			## limite > 0
			bne  $s2, $s0, fim			## while (limite > 0) AND (trocou)
			add  $s0, $zero, $zero		## trocou = false
			la   $t8, vetor				## $t8 = endereço inicial do vetor na memoria
		
			add  $s3, $zero, $zero		## $s3: i = 0
			addi $t8, $t8, -4				## $t8 = vetor[i-1]
	
for:		addi $t8, $t8, 4				## $t8 = vetor[i++]
			slt  $s2, $s3, $s1			## i < limite
			beq  $s2, $zero, fimfor
			addi $s3, $s3, 1				## i++
			
			lw   $a0, 0($t8) 				## $a0 = vetor[i] / lê da memoria 
			lw   $a1, 4($t8) 				## $a1 = vetor[i+1] / lê da memoria
			slt  $s2, $a1, $a0			## if vetor[i] > vetor[i+1]
			beq  $s2, $zero, for			## proxima interação do for se não entrar no if
			jal  troca						## chamada da rotina troca passando $a0 e $a1 como parametros
			sw   $v0, 0($t8)				## vetor[i] = $v0 / coloca na memoria os dados trocados
			sw   $v1, 4($t8)				## vetor[i + 1/ / coloca na memoria os dados trocados
	
			addi $s0, $zero, 1			## trocou = true	
			j    for 						## proxima interação for se entrar no if
			
fimfor:	jal mostra_vetor				## chamada da rotina mostra_vetor
			addi $s1, $s1, -1				## limite--
			j    while						## proxima interação do while
	
fim:		addi	$v0, $zero, 4			# Chamada ao sistema para escrever string na tela
			la	$a0, msg2					# $a0 = endereço da string a ser escrita na tela
			syscall	

			addi $v0, $zero, 10			# Chamada ao sistema para encerrar programa
			syscall
#------------------------------------------------------------------------------
troca:	addi $v0, $a0, 0	
			addi $v1, $a1, 0	
			addi $s5, $v0, 0				## aux = $v0
			addi $v0, $v1, 0				## $v0 = $v1
			addi $v1, $s5, 0				## $v1 = aux
			jr $ra 							## retorna de onde foi chamado											
#------------------------------------------------------------------------------
mostra_vetor: addi $sp, $sp, -4		## aloca espaço na pilha
              sw $ra, 0($sp)  		## salva $ra da main na pilha
              
              addi $s4, $zero, 0		## $s4:j = 0
        
for1:         slt $s2, $s4, $s6		## j < n
              beq $s2, $zero, fimfor1

              add $a0, $zero, $s4	## $a0 = $s4
              jal mostra_elemento_vetor	## chamada da rotina mostra_elemento_vetor passando $a0 como parametro

              addi $s4, $s4, 1		## $s4:j++
              j for1						## proxima interação do for

fimfor1:      lw $ra, 0($sp)  		## restaura o $ra da main
             
              addi $sp, $sp, 4		
              jr $ra  					## retorna pra main
#------------------------------------------------------------------------------
																	# Prólogo
mostra_elemento_vetor:	addi	$sp, $sp, -28			# Aloca espaço para 7 palavras na pilha
								sw		$t0, 0 ($sp)					# Salva $t0, $t1, $t2, $t3, $t4, $t5, $t6 na pilha
								sw		$t1, 4 ($sp)
								sw		$t2, 8 ($sp)
								sw		$t3, 12 ($sp)
								sw		$t4, 16 ($sp)
								sw		$t5, 20 ($sp)
								sw		$t6, 24 ($sp)
																	# Lê vetor[índice] da memória
								la		$t0, vetor						# $t0 = endereço inicial de vetor na memória
								sll	$t1, $a0, 2						# $t1 = índice * 4
								add	$t1, $t0, $t1					# $t1 = endereço de vetor[índice] na memória
								lw		$t2, 0 ($t1)					# $t2 = vetor[índice] (índice da cor com que elemento é desenhado)
																	# Lê escala_ azul[vetor[índice]] da memória
								la		$t3, escala_azul				# $t3 = endereço inicial do vetor escala_ azul na memória
								sll	$t4, $t2, 2						# $t4 = vetor[índice] * 4
								add	$t4, $t3, $t4					# $t4 = endereço de escala_ azul[vetor[índice]] na memória
								lw		$t5, 0 ($t4)					# $t5 = escala_ azul[vetor[índice]] (cor com que elemento é desenhado)
																	# Calcula endereço no display onde elemento do vetor deve ser desenhado
								sll	$t6, $a0, 2						# $t6 = índice * 4
								add	$t6, $gp, $t6					# $t6 = endereço inicial do display + índice * 4
								sw		$t5, 0 ($t6)					# Escreve cor do elemento do vetor na área de memória do display bitmap: mostrado no display
																	# Epílogo
								lw		$t0, 0 ($sp)					# Restaura $t0, $t1, $t2, $t3, $t4, $t5, $t6 da pilha
								lw		$t1, 4 ($sp)
								lw		$t2, 8 ($sp)
								lw		$t3, 12 ($sp)
								lw		$t4, 16 ($sp)
								lw		$t5, 20 ($sp)
								lw		$t6, 24 ($sp)
								addi	$sp, $sp, 28					# Libera espaço de 7 palavras na pilha
								jr		$ra								# Retorna da rotina
#------------------------------------------------------------------------------
						.data										# Área de dados
#------------------------------------------------------------------------------
																	# Variáveis e estruturas de dados do programa
n:						.word 16									# Número de elementos do vetor (no máximo 16)
																	# Vetor a ser ordenado (com 16 valores entre 0 e 15)
vetor:				.word 9 1 10 2 6 13 15 0 12 5 7 14 4 3 11 8
#vetor:				.word 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
#vetor:				.word 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
#vetor:				.word 9 1 10 2 9 6 13 15 13 0 12 5 6 0 5 7
																	# Strings para impressão de mensagens
msg1:					.asciiz "\nOrdenação\n"
msg2:					.asciiz "Tecle enter"
																	# Escala de 16 cores em azul
escala_azul:		.word 0x00CCFFFF, 0x00BEEEFB, 0x00B0DDF8, 0x00A3CCF4, 0x0095BBF1, 0x0088AAEE, 0x007A99EA, 0x006C88E7, 0x005F77E3, 0x005166E0, 0x004455DD, 0x003644D9, 0x002833D6, 0x001B22D2, 0x000D11CF, 0x000000CC
#------------------------------------------------------------------------------
