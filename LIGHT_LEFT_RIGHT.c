#include "xparameters.h"
#include "xgpio_l.h"

#define TIME 160

Xuint16 data = 0x0001;

int main(void)
{
    Xuint8 i;

    void DELAY(void);
    void LEFT(void);
    void RIGHT(void);

    DELAY();
    while(1) {
        for(i = 0; i < TIME; i++) {
            DELAY();
            LEFT();
        }

        for(i = 0; i < TIME; i++) {
            DELAY();
            RIGHT();
        }
    }

    return 0;
}

void DELAY(void)
{
    Xuint32 delay;

    XGpio_mSetDataReg(XPAR_LEDS_BASEADDR, 1, ~data);
    for(delay = 0; delay < 0x1ffffff; delay++);
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
