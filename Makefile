AS = arm-none-eabi-as
CC = arm-none-eabi-gcc
CFLAGS = -O1 -g -mcpu=cortex-m4 -mthumb -I ./CMSIS/include -c

# Note start.o needs to be first to ensure the vectors are at the start
fiddle: start.o main.o
	arm-none-eabi-ld -Ttext 0x08000000 -Tdata 0x20000000 $^ -o $@
