#include "xparameters.h"
#include "xgpio.h"
#include "xtmrctr.h"
#include "xscugic.h"
#include "xil_exception.h"

#define LED_GPIO_ID   XPAR_AXI_GPIO_0_BASEADDR
#define BTN_GPIO_ID   XPAR_AXI_GPIO_1_BASEADDR
#define TIMER_ID      XPAR_AXI_TIMER_0_BASEADDR
#define GIC_ID        XPAR_XSCUGIC_0_BASEADDR
#define GIC_SPI_BASE  32u
#define TIMER_IRQ_ID  (XPAR_FABRIC_AXI_TIMER_0_INTR + GIC_SPI_BASE)

#define GPIO_CH        1
#define TMR_NR         0
#define TIMER_RELOAD   500000u

#define NUM_SPEEDS 3
static const u32 speed_ticks[NUM_SPEEDS] = { 50u, 20u, 8u };

#define NUM_SEG 6
#define ALL_OFF 0x3Fu

static XGpio   Led, Btn;
static XTmrCtr Timer;
static XScuGic Gic;

static volatile u32 pattern = 0x01u;
static volatile int dir     = 1;
static volatile int paused  = 0;
static volatile u32 speed_i = 0;
static volatile u32 tick    = 0;

static u8 db_last = 0, db_cnt = 0;
static u8 btn_prev = 0;
static u8 chord = 0;

static void process_buttons(u8 cur)
{
    if ((cur & 0x3) == 0x3 && (btn_prev & 0x3) != 0x3) {
        dir   = -dir;
        chord = 1;
    }

    u8 released = btn_prev & (u8)~cur;
    if ((released & 0x1) && !chord) paused  = !paused;
    if ((released & 0x2) && !chord) speed_i = (speed_i + 1) % NUM_SPEEDS;

    if ((cur & 0x3) == 0) chord = 0;
    btn_prev = cur;
}

static void TimerCallback(void *ref, u8 tmr_nr)
{
    (void)ref; (void)tmr_nr;

    u8 raw = (u8)((~XGpio_DiscreteRead(&Btn, GPIO_CH)) & 0x3);
    if (raw != db_last) {
        db_last = raw;
        db_cnt  = 0;
    } else if (db_cnt < 2) {
        db_cnt++;
        if (db_cnt == 2) process_buttons(raw);
    }

    if (!paused) {
        if (++tick >= speed_ticks[speed_i]) {
            tick = 0;
            if (dir > 0)
                pattern = ((pattern << 1) | (pattern >> (NUM_SEG - 1))) & ALL_OFF;
            else
                pattern = ((pattern >> 1) | (pattern << (NUM_SEG - 1))) & ALL_OFF;
            XGpio_DiscreteWrite(&Led, GPIO_CH, ALL_OFF & ~pattern);
        }
    }
}

int main(void)
{
    XGpio_Initialize(&Led, LED_GPIO_ID);
    XGpio_SetDataDirection(&Led, GPIO_CH, 0x0);
    XGpio_DiscreteWrite(&Led, GPIO_CH, ALL_OFF & ~pattern);

    XGpio_Initialize(&Btn, BTN_GPIO_ID);
    XGpio_SetDataDirection(&Btn, GPIO_CH, 0xF);

    XTmrCtr_Initialize(&Timer, TIMER_ID);
    XTmrCtr_SetHandler(&Timer, TimerCallback, &Timer);
    XTmrCtr_SetOptions(&Timer, TMR_NR,
                       XTC_INT_MODE_OPTION | XTC_AUTO_RELOAD_OPTION | XTC_DOWN_COUNT_OPTION);
    XTmrCtr_SetResetValue(&Timer, TMR_NR, TIMER_RELOAD);

    XScuGic_Config *cfg = XScuGic_LookupConfig(GIC_ID);
    XScuGic_CfgInitialize(&Gic, cfg, cfg->CpuBaseAddress);

    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_IRQ_INT,
                                 (Xil_ExceptionHandler)XScuGic_InterruptHandler, &Gic);

    XScuGic_Connect(&Gic, TIMER_IRQ_ID,
                    (Xil_ExceptionHandler)XTmrCtr_InterruptHandler, &Timer);
    XScuGic_Enable(&Gic, TIMER_IRQ_ID);

    Xil_ExceptionEnable();

    XTmrCtr_Start(&Timer, TMR_NR);

    for (;;) {
    }
    return 0;
}
