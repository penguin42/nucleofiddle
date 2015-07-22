	.cpu cortex-m4
	.text
	.align 2


# Vector table (See ST DocID022708 section 2.3.4 vector table)
	# Initial SP value - top of RAM
	.word 0x20000000+96*1024
	# Reset vector
	.word _start
	# More vector table should go here

	.global _start
	.thumb
	.thumb_func
	.type _start,%function

_start:
	b main
