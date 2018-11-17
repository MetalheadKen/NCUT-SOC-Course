#include "xparameters.h"
#include "xgpio_l.h"

#define TIME 160

Xuint16 data = 0x0001;

int main(void)
{
    Xuint8 i, direction = 0x00;

    void DELAY(Xuint32);
    void LEFT(void);
    void RIGHT(void);

    DELAY(0x00ffffff);
    while(1) {
        for(i = 0; i < TIME; i++) {
            if(direction == 0x00 || direction == 0x01) {
                if(direction == 0x00) {
                    DELAY(0x00fff000);
                    LEFT();
                } else if(direction == 0x01) {
                    DELAY(0x00ffffff);
                    LEFT();
                }
            } else if(direction == 0x010 || direction == 0x11) {
                if(direction == 0x10) {
                    DELAY(0x00fff000);
                    RIGHT();
                } else if(direction == 0x11) {
                    DELAY(0x00ffffff);
                    RIGHT();
                }
            }
        }

        direction++;
    }

    return 0;
}

void DELAY(Xuint32 times)
{
    Xuint32 delay;

    XGpio_mSetDataReg(XPAR_LEDS_BASEADDR, 1, ~data);
    for(delay = 0; delay < times; delay++);
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
