.data
hello_string: .asciz "Hello world"

.text
.global main

myfunc:
	move $a0, $zero
	jal  exit

main:

	dla $a0, hello_string
	jal puts

	jal myfunc
