#include "xparameters.h"
#include "xgpio_l.h"

#define TIME 3000

Xuint8 array[] = {0xC0, 0xF9, 0xA8, 0xB0, 0x99, 0x90, 0x82, 0xD8, 0x80, 0x90};

//Left Right Fast Slow Data
void main(void)
{
    void DELAY(register Xuint8);

    Xuint8 i;

    DELAY(5);
    XGpio_mSetDataReg(XPAR_LEDS_1_BASEADDR, 1, 0xEF);
    for(;;) {
        for(i = 0; i < 10; i++) {
            DELAY(TIME);
            XGpio_mSetDataReg(XPAR_LEDS_BASEADDR, 1, array[i]);
        }
    }
}

void DELAY(register Xuint8 delay_time)
{
    Xuint32 time;

    for(; delay_time > 0; delay_time--)
        for(time = 0; time < 900000; time++);
}
