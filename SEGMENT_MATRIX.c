#include "xparameters.h"
#include "xgpio_l.h"

#define TIME 20

Xuint8 array[] = {0x00, 0x00, 0x00, 0x18, 0x18, 0x00, 0x00, 0x00,
                  0x00, 0x00, 0x3C, 0x24, 0x24, 0x3C, 0x00, 0x00,
                  0x00, 0x7E, 0x42, 0x42, 0x42, 0x42, 0x7E, 0x00,
                  0xFF, 0x81, 0x81, 0x81, 0x81, 0x81, 0x81, 0xFF
                 };

Xuint8 col[] = {0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01};

int main(void)
{
    void DELAY(void);

    Xuint8 i, ptr, row;

    DELAY();
    XGpio_mSetDataReg(XPAR_LEDS_2_BASEADDR, 1, 0xFF);
    for(;;) {
        for(ptr = 0; ptr <= 24; ptr += 8) { //image
            for(i = 0; i < TIME; i++) {	//times
                for(row = 0; row < 8; row++) {	//row
                    XGpio_mSetDataReg(XPAR_LEDS_BASEADDR, 1, ~col[row]); //SCAN
                    XGpio_mSetDataReg(XPAR_LEDS_1_BASEADDR, 1, ~array[ptr + row]); //TYPE AND COLUMN
                    DELAY();
                }
            }
        }
    }
    return 0;
}

void DELAY(void)
{
    Xuint32 delay_time;

    for(delay_time = 0; delay_time < 900000; delay_time++);
}
