	.cpu cortex-m4
	.text
	.align 2


# Vector table (See ST DocID022708 section 2.3.4 vector table)
	.word 0x20000000+96*1024    /* 0x00 Initial SP value - top of RAM */
	.word _start                /* 0x04 Reset vector                  */
  # More vector table see Table 38 vector table in DocID025350 ref manual
  .word 0xdeadbeef            /* 0x08 NMI                           */
  .word 0xdeadbeef            /* 0x0c Hard fault                    */
  .word 0xdeadbeef            /* 0x10 MM Fault                      */
  .word 0xdeadbeef            /* 0x14 Bus fault                     */
  .word 0xdeadbeef            /* 0x18 Usage fault                   */
  .word 0xdeadbeef            /* 0x1c Reserved                      */
  .word 0xdeadbeef            /* 0x20 Reserved                      */
  .word 0xdeadbeef            /* 0x24 Reserved                      */
  .word 0xdeadbeef            /* 0x28 Reserved                      */
  .word 0xdeadbeef            /* 0x2c SVC                           */
  .word 0xdeadbeef            /* 0x30 Reversed (for debug)          */
  .word 0xdeadbeef            /* 0x34 Reserved                      */
  .word 0xdeadbeef            /* 0x38 PendSV                        */
  .word handler_systick       /* 0x3c Systick                       */
  .word 0xdeadbeef            /* 0x40 IRQ0 - Window watchdog        */
  .word 0xdeadbeef            /* 0x44 IRQ1 - EXTI line 16           */
  .word 0xdeadbeef            /* 0x48 IRQ2 - EXTI line 21           */
  .word 0xdeadbeef            /* 0x4c IRQ3 - EXTI line 22           */
  .word 0xdeadbeef            /* 0x50 IRQ4 - Flash                  */
  .word 0xdeadbeef            /* 0x54 IRQ5 - RCC                    */
  .word 0xdeadbeef            /* 0x58 IRQ6 - EXTI line 0            */
  .word 0xdeadbeef            /* 0x5c IRQ7 - EXTI line 1            */
  .word 0xdeadbeef            /* 0x60 IRQ8 - EXTI line 2            */
  .word 0xdeadbeef            /* 0x64 IRQ9 - EXTI line 3            */
  .word 0xdeadbeef            /* 0x68 IRQ10 - EXTI line 4           */
  .word 0xdeadbeef            /* 0x6c IRQ11 - DMA1 Stream 0         */
  .word 0xdeadbeef            /* 0x70 IRQ12 - DMA1 Stream 1         */
  .word 0xdeadbeef            /* 0x74 IRQ13 - DMA1 Stream 2         */
  .word 0xdeadbeef            /* 0x78 IRQ14 - DMA1 Stream 3         */
  .word 0xdeadbeef            /* 0x7c IRQ15 - DMA1 Stream 4         */
  .word 0xdeadbeef            /* 0x80 IRQ16 - DMA1 Stream 5         */
  .word 0xdeadbeef            /* 0x84 IRQ17 - DMA1 Stream 6         */
  .word 0xdeadbeef            /* 0x88 IRQ18 - ADC1                  */
  .word 0xdeadbeef            /* 0x8c IRQ19 -                       */
  .word 0xdeadbeef            /* 0x90 IRQ20 -                       */
  .word 0xdeadbeef            /* 0x94 IRQ21 -                       */
  .word 0xdeadbeef            /* 0x98 IRQ22 -                       */
  .word 0xdeadbeef            /* 0x9c IRQ23 - EXTI Line[9:5]        */
  .word 0xdeadbeef            /* 0xa0 IRQ24 - TIM1 Break & TIM9     */
  .word 0xdeadbeef            /* 0xa4 IRQ25 - TIM1 Update & TIM10   */
  .word 0xdeadbeef            /* 0xa8 IRQ26 - TIM1 Trigger & TIM11  */
  .word 0xdeadbeef            /* 0xac IRQ27 - TIM1 Capture Compare  */
  .word 0xdeadbeef            /* 0xb0 IRQ28 - TIM2                  */
  .word 0xdeadbeef            /* 0xb4 IRQ29 - TIM3                  */
  .word 0xdeadbeef            /* 0xb8 IRQ30 - TIM4                  */
  .word 0xdeadbeef            /* 0xbc IRQ31 - I2C1 event            */
  .word 0xdeadbeef            /* 0xc0 IRQ32 - I2C1 error            */
  .word 0xdeadbeef            /* 0xc4 IRQ33 - I2C2 event            */
  .word 0xdeadbeef            /* 0xc8 IRQ34 - I2C2 error            */
  .word 0xdeadbeef            /* 0xcc IRQ35 - SPI1                  */
  .word 0xdeadbeef            /* 0xd0 IRQ36 - SPI2                  */
  .word 0xdeadbeef            /* 0xd4 IRQ37 - USART1                */
  .word handler_usart2        /* 0xd8 IRQ38 - USART2                */
  .word 0xdeadbeef            /* 0xdc IRQ39 -                       */
  .word 0xdeadbeef            /* 0xe0 IRQ40 - EXTI Line[15:10]      */
  .word 0xdeadbeef            /* 0xe4 IRQ41 - EXTI Line 17/RTC      */
  .word 0xdeadbeef            /* 0xe8 IRQ42 - EXII Line 18/USB OTG  */
  .word 0xdeadbeef            /* 0xec IRQ43 -                       */
  .word 0xdeadbeef            /* 0xf0 IRQ44 -                       */
  .word 0xdeadbeef            /* 0xf4 IRQ45 -                       */
  .word 0xdeadbeef            /* 0xf8 IRQ46 -                       */
  .word 0xdeadbeef            /* 0xfc IRQ47 - DMA1 stream 7         */
  .word 0xdeadbeef           /* 0x100 IRQ48 -                       */
  .word 0xdeadbeef           /* 0x104 IRQ49 -                       */
  .word 0xdeadbeef           /* 0x108 IRQ50 - TIM5                  */
  .word 0xdeadbeef           /* 0x10c IRQ51 - SPI3                  */
  .word 0xdeadbeef           /* 0x110 IRQ52 -                       */
  .word 0xdeadbeef           /* 0x114 IRQ53 -                       */
  .word 0xdeadbeef           /* 0x118 IRQ54 -                       */
  .word 0xdeadbeef           /* 0x11c IRQ55 -                       */
  .word 0xdeadbeef           /* 0x120 IRQ56 - DMA2 stream 0         */
  .word 0xdeadbeef           /* 0x124 IRQ57 - DMA2 stream 1         */
  .word 0xdeadbeef           /* 0x128 IRQ58 - DMA2 stream 2         */
  .word 0xdeadbeef           /* 0x12c IRQ59 - DMA2 stream 3         */
  .word 0xdeadbeef           /* 0x130 IRQ60 - DMA2 stream 4         */
  .word 0xdeadbeef           /* 0x134 IRQ61 -                       */
  .word 0xdeadbeef           /* 0x138 IRQ62 -                       */
  .word 0xdeadbeef           /* 0x13c IRQ63 -                       */
  .word 0xdeadbeef           /* 0x140 IRQ64 -                       */
  .word 0xdeadbeef           /* 0x144 IRQ65 -                       */
  .word 0xdeadbeef           /* 0x148 IRQ66 -                       */
  .word 0xdeadbeef           /* 0x14c IRQ67 - USB OTG FS            */
  .word 0xdeadbeef           /* 0x150 IRQ68 - DMA2 stream 5         */
  .word 0xdeadbeef           /* 0x154 IRQ69 - DMA2 stream 6         */
  .word 0xdeadbeef           /* 0x158 IRQ70 - DMA2 stream 7         */
  .word 0xdeadbeef           /* 0x15c IRQ71 - USART6                */
  .word 0xdeadbeef           /* 0x160 IRQ72 - I2C3_EV               */
  .word 0xdeadbeef           /* 0x164 IRQ73 - I2C3_ER               */
  .word 0xdeadbeef           /* 0x168 IRQ74 -                       */
  .word 0xdeadbeef           /* 0x16c IRQ75 -                       */
  .word 0xdeadbeef           /* 0x170 IRQ76 -                       */
  .word 0xdeadbeef           /* 0x174 IRQ77 -                       */
  .word 0xdeadbeef           /* 0x178 IRQ78 -                       */
  .word 0xdeadbeef           /* 0x17c IRQ79 -                       */
  .word 0xdeadbeef           /* 0x180 IRQ80 -                       */
  .word 0xdeadbeef           /* 0x184 IRQ81 - FPU                   */
  .word 0xdeadbeef           /* 0x188 IRQ82 -                       */
  .word 0xdeadbeef           /* 0x18c IRQ83 -                       */
  .word 0xdeadbeef           /* 0x190 IRQ84 - SPI4                  */
  /* Can add more IRQs here */

	.global _start
	.thumb
	.thumb_func
	.type _start,%function

_start:
	b main
