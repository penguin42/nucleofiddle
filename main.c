#include "stm32f401xe.h"

/* (c) Dr. David Alan Gilbert (dave@treblig.org) 2015
 *   GPL v2 or above
 */

volatile unsigned char last_rx = 'B';

static int delay(void)
{
    unsigned int x, total;
    for(x=0;x<1000000;x++) {
        total+= GPIOA->MODER;
    }

    return total;
}

static void setup_usart(void)
{
  int dummy;
  /* The USART2 hangs off APB1 (42 MHz) that hangs off AHB1 */
  /* PA2 is output, PA3 is input both using Alternate function 7 */
  GPIOA->MODER &= ~(GPIO_MODER_MODER2 | GPIO_MODER_MODER3);
  GPIOA->MODER |= GPIO_MODER_MODER2_1 | GPIO_MODER_MODER3_1; /* set bit 1, i.e. mode2->alternate func */
  GPIOA->OTYPER &= ~GPIO_OTYPER_OT_2; /* Push pull */
  GPIOA->AFR[0] |= (7 << (2*4)) | (7 << (3*4));

  /* Enable clocks to UART */
  RCC->APB1ENR |= RCC_APB1ENR_USART2EN;

  /* See P.503 section 19.3.2 of stm32f401 ref manual */
  USART2->CR1 |= USART_CR1_UE; /* Usart enable */
  /* No parity, leave M bit in USART_CR1 off - so get 8 bits */
  /* 1 stop, so leave CR2 M bit as default 00 */
  /* We're also in oversampling x 16 mode by default */
  /* Set baud rate using USART_BRR - 42MHz pclk1, 9600 baud, with
   * oversample gives us division of 273.4375. .4375*16=7 so that's the fraction
   * and 273=0x111 goes straight into the mantissa, so 0x1117 */
  USART2->BRR = 0x1117;
  /* Set TE in USART_CR1 to send idle as 1st transmission */
  USART2->CR1 |= USART_CR1_TE;

  /* Get the UART to interrupt on overruns or receive ready */
  USART2->CR1 |= USART_CR1_RE | USART_CR1_RXNEIE;
  /* Clear pending rx interrupts */
  dummy=USART2->SR;
  dummy=USART2->DR;
  /* Let the NVIC respond to UART2 interrupts */
  NVIC_EnableIRQ(USART2_IRQn);
}

/* Interrupt handler for USART2 */
void handler_usart2(void)
{
  unsigned int sr = USART2->SR;
  unsigned int dr = USART2->DR; /* Reading DR clears RXNE, reading it after SR clears ORE */

  if (sr & USART_SR_RXNE) {
    /* Real data */
    last_rx = dr & 255;
  } else {
    /* Overrun is the only other thing enabled */
    last_rx = 'X';
  }
}

/* Set up clock debug - this sets up the PLL/5 to PA8, and sysclock/4 to PC9
 * useful to see if the clock is actually running at the frequency you
 * expect.
 */
void clock_debug(void)
{
  /* Set MCO1 (PA8) as PLL/5 = 16.8 */
  RCC->CFGR |= RCC_CFGR_MCO1 | RCC_CFGR_MCO1PRE;
  /* Set up PA8 for MC01 - AF */
  GPIOA->MODER |= GPIO_MODER_MODER8_1; /* set bit 1, i.e. mode2->alternate func */
  GPIOA->OSPEEDR |= GPIO_OSPEEDER_OSPEEDR8; /* High speed */
  /* AFR0 - the default - is the MC0_1 - so we're OK */

  /* Set MCO2 (PC9) output as sysclock/4=21MHz */
  RCC->CFGR |= RCC_CFGR_MCO2PRE_1 | RCC_CFGR_MCO2PRE_2;
  GPIOC->MODER |= GPIO_MODER_MODER9_1; /* set bit 1, i.e. mode2->alternate func */
  GPIOC->OSPEEDR |= GPIO_OSPEEDER_OSPEEDR9; /* High speed */
  /* AFR0 - the default is the MCO_2 - so we're OK */
}

/* Setup the main clock to 84MHz; we assume 8MHz clock input from ST-Link and
 * assume 2.7v-3.6v for wait cycle and allowing us to enable prefetch.
 */
void setup_clocks_etc(void)
{
  /* To be able to switch to a faster clock we're going to need to increase the flash latency */
  /* Table 6 of ref manual says for 2.7-3.6v that 2WS (3 CPU cycles) should be enough for 84MHz
   * - are we on 2.7-3.6v? */
  FLASH->ACR |= FLASH_ACR_LATENCY_2WS;
  /* Apparently we need to read ACR to check it happened */
  while ((FLASH->ACR & FLASH_ACR_LATENCY) != FLASH_ACR_LATENCY_2WS) { /* Twiddle */ };

  /* I think we're on 16MHz internal RC at this point, set the RCC to take it's input from the 8MHz we're
   * getting from ST-Link
   * Turn on the high speed external clock input
   */
  RCC->CR |= RCC_CR_HSEON | RCC_CR_HSEBYP;
  /* Set up PLL */
  RCC->PLLCFGR = (RCC->PLLCFGR & ~(RCC_PLLCFGR_PLLM|RCC_PLLCFGR_PLLN|
                                   RCC_PLLCFGR_PLLP|RCC_PLLCFGR_PLLSRC|RCC_PLLCFGR_PLLQ)) |
                 /* 8MHz input / 4 -> 2MHz into PLL (recommended rate) */
                 (4*RCC_PLLCFGR_PLLM_0) |
                 /* 2MHz * 168-> 336MHz VCO  - has to be between 192..432 */
                 (168*RCC_PLLCFGR_PLLN_0) |
                 /* 336/4=84 (PLLP=4->code 1) 84MHz is max CPU clock */
                 (1*RCC_PLLCFGR_PLLP_0) |
                 /* 336/7=48MHz peripheral clocks - needed for USB */
                 (7*RCC_PLLCFGR_PLLQ_0) | RCC_PLLCFGR_PLLSRC_HSE;
  /* Enable PLL */
  RCC->CR |= RCC_CR_PLLON;
  /* Wait for PLLRDY */
  while (!(RCC->CR & RCC_CR_PLLRDY)) { /* Yawn */ };
  /* Set bus dividers; APB1 must not exceed 42MHz - so divide our 84MHz/2 */
  RCC->CFGR |= RCC_CFGR_PPRE1_DIV2;

  /* Enable caches */
  FLASH->ACR |= FLASH_ACR_ICEN | FLASH_ACR_DCEN | FLASH_ACR_PRFTEN;

  /* Flip onto PLL for main clock */
  RCC->CFGR |= RCC_CFGR_SW_PLL;
}

void setup_interrupts(void)
{
  /* Enable interrupts */
  __set_PRIMASK(0);
  __enable_irq();
}

int main(void)
{
  /* Disable interrupts until we've got everything sorted */
  __disable_irq();
  __set_PRIMASK(1);
  setup_clocks_etc();

  /* Enable clocks to GPIO */
  RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN | RCC_AHB1ENR_GPIOBEN | RCC_AHB1ENR_GPIOCEN | RCC_AHB1ENR_GPIODEN;

  /* The LED is on PA5; mode 01 is 'General purpose output' */
  GPIOA->MODER &= ~GPIO_MODER_MODER5;
  GPIOA->MODER |= GPIO_MODER_MODER5_0;
  /* Make it 'push pull' rather than open drain */
  GPIOA->OTYPER &= ~GPIO_OTYPER_OT_5;

  setup_interrupts();

  setup_usart();

  /* clock_debug(); */

  while (1) {
    GPIOA->ODR &= ~GPIO_ODR_ODR_5;
    delay();
    USART2->DR = 'A';
    GPIOA->ODR |= GPIO_ODR_ODR_5;
    delay();
    USART2->DR = last_rx;
  };
}

