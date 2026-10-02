#include "xparameters.h"
#include "xgpio.h"
#include "xil_io.h"

#define BTN_BASE    XPAR_AXI_GPIO_1_BASEADDR
#define DMA_BASE    XPAR_AXI_DMA_0_BASEADDR
#define BRAM_BASE   0xC0000000u
#define GPIO_CH     1
#define FRAME_BYTES (320u * 200u)

#define S2MM_DMACR  (DMA_BASE + 0x30u)
#define S2MM_DMASR  (DMA_BASE + 0x34u)
#define S2MM_DA     (DMA_BASE + 0x48u)
#define S2MM_LENGTH (DMA_BASE + 0x58u)
#define DMACR_RS    0x00000001u
#define DMASR_IDLE  0x00000002u

static XGpio Btn;

static u8 button_pressed(void)
{
    return (u8)((~XGpio_DiscreteRead(&Btn, GPIO_CH)) & 0x1u);
}

int main(void)
{
    XGpio_Initialize(&Btn, BTN_BASE);
    XGpio_SetDataDirection(&Btn, GPIO_CH, 0x1u);

    Xil_Out32(S2MM_DMACR, DMACR_RS);

    for (;;) {
        while (!button_pressed()) { }

        Xil_Out32(S2MM_DA, (u32)BRAM_BASE);
        Xil_Out32(S2MM_LENGTH, FRAME_BYTES);
        while ((Xil_In32(S2MM_DMASR) & DMASR_IDLE) == 0u) { }

        while (button_pressed()) { }
    }
    return 0;
}
