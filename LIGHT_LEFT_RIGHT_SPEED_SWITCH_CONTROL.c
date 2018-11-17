#include "xparameters.h"
#include "xgpio_l.h"

#define TIMES 64

Xuint8 switch_old = 0x01, j, switch_new;
Xuint8 direction = 0x00;
Xuint16 data1[] = {0x0000, 0x0001, 0x0003, 0x0007, 0x000F, 0x001F, 0x003F, 0x007F, 0x00FF, 0x01FF, 0x03FF, 0x07FF, 0x0FFF, 0x1FFF, 0x3FFF, 0x7FFF};
Xuint16 data;

int main(void)
{
    void DELAY_FAST(void);
    void DELAY_SLOW(void);
    void LEFT(void);
    void RIGHT(void);

    DELAY_SLOW();
    data = 0x0000;
    while(1) {
        for(j = 0; j < TIMES; j++) {
            switch_new = XGpio_mGetDataReg(XPAR_SWITCH_BASEADDR, 1);
            if(switch_old != switch_new && switch_new != 0) {
                switch_old = switch_new;
                data = data1[switch_old];
            }

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
        direction++;
    }

    return 0;
}

void DELAY_FAST(void)
{
    Xuint32 delay;

    XGpio_mSetDataReg(XPAR_LEDS_BASEADDR, 1, ~data);
    for(delay = 0; delay < 0x01fff000; delay++);
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
