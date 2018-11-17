#include "xparameters.h"
#include "xgpio_l.h"

Xuint16 data = 0x0001;

int main(void)
{
    Xuint8 direction = 0x00;

    void DELAY_FAST(void);
    void DELAY_SLOW(void);
    void LEFT(void);
    void RIGHT(void);

    DELAY_SLOW();
    while(1) {
        direction = XGpio_mGetDataReg(XPAR_SWITCH_BASEADDR, 1);
        switch(direction) {
            case 0:
                DELAY_FAST();
                LEFT();
                break;
            case 1:
                DELAY_SLOW();
                LEFT();
                break;
            case 2:
                DELAY_FAST();
                RIGHT();
                break;
            case 3:
                DELAY_SLOW();
                RIGHT();
                break;
        }
    }

    return 0;
}

void DELAY_FAST(void)
{
    Xuint32 delay;

    XGpio_mSetDataReg(XPAR_LEDS_BASEADDR, 1, ~data);
    for(delay = 0; delay < 0x00fff000; delay++);
}

void DELAY_SLOW(void)
{
    Xuint32 delay;

    XGpio_mSetDataReg(XPAR_LEDS_BASEADDR, 1, ~data);
    for(delay = 0; delay < 0x00ffffff; delay++);
}

void LEFT(void)
{
    if(data & 0x8000) {
        data <<= 1;
        data |= 0x0001;
    } else
        data <<= 1;
}

void RIGHT(void)
{
    if(data & 0x0001) {
        data >>= 1;
        data |= 0x8000;
    } else
        data >>= 1;
}
