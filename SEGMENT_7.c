#include "xparameters.h"
#include "xgpio_l.h"

#define TIME 80

Xuint8 count_high, count_low, speed, position;
Xuint8 enable[2] = {0xFE, 0xFD};
Xuint8 word[10] = {0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90};

int main(void)
{
    void DELAY(void);
    void UP(void);
    void DOWN(void);

    Xuint8 count;

    DELAY();
    while(1) {
        count = 1;
        while(count--)
            UP();

        count = 1;
        while(count--)
            DOWN();
    }

    return 0;
}

void DELAY(void)
{
    Xuint32 delay_time;

    for(delay_time = 0; delay_time < 900000; delay_time++);
}

void UP(void)
{
    for(count_high = 0; count_high < 6; count_high++) {
        for(count_low = 0; count_low < 10; count_low++) {
            for(speed = 0; speed < TIME; speed++) {
                for(position = 0; position < 2; position++) {
                    XGpio_mSetDataReg(XPAR_LEDS_1_BASEADDR, 1, enable[position]);

                    switch(position) {
                        case 0:
                            XGpio_mSetDataReg(XPAR_LEDS_BASEADDR, 1, word[count_low]);
                            break;
                        case 1:
                            XGpio_mSetDataReg(XPAR_LEDS_BASEADDR, 1, word[count_high]);
                            break;
                    }
                    DELAY();
                }
            }
        }
    }
}

void DOWN(void)
{
    for(count_high = 5; count_high <= 0; count_high--) {
        for(count_low = 9; count_low <= 0; count_low--) {
            for(speed = 0; speed < TIME; speed++) {
                for(position = 0; position < 2; position++) {
                    XGpio_mSetDataReg(XPAR_LEDS_1_BASEADDR, 1, enable[position]);

                    switch(position) {
                        case 0:
                            XGpio_mSetDataReg(XPAR_LEDS_BASEADDR, 1, word[count_low]);
                            break;
                        case 1:
                            XGpio_mSetDataReg(XPAR_LEDS_BASEADDR, 1, word[count_high]);
                            break;
                    }
                    DELAY();
                }
            }
        }
    }
}
