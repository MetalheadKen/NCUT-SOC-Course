#include "xparameters.h"
#include "xgpio_l.h"

Xuint16 data = 0x0001;
int main(void)
{

    void DELAY(void);
    void RIGHT(void);

    DELAY();
    while(1) {
        XGpio_mSetDataReg(XPAR_LEDS_BASEADDR, 1, ~data);
        RIGHT();
        DELAY();
    }

    return 0;
}

void DELAY(void)
{
    Xuint32 delay;

    for(delay = 0; delay < 0x1ffffff; delay++);
}

void RIGHT(void)
{
    if(data & 0x0001) {
        data >>= 1;
        data |= 0x8000;
    } else
        data >>= 1;
}
