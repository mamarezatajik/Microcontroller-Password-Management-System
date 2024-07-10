#include <mega32.h>
#include <delay.h>
#include <string.h>

#define C1 PIND.2
#define C2 PIND.1
#define C3 PIND.0

#define A PORTD.3
#define B PORTD.4
#define C PORTD.5
#define D PORTD.6

#define correct_pass PORTD.7
#define MAX_PASSWORDS 20
#define MAX_SAVE  50
#define PASSWORD_LENGTH 5

int time = 0, delay = 0, password_count = 6, save_count = 0;
char passwords[MAX_PASSWORDS][PASSWORD_LENGTH] =
    {"0000", "1234", "4321", "1111", "1380", "1382"};
char Seconds[MAX_SAVE], Minutes[MAX_SAVE], Hours[MAX_SAVE],
    one[MAX_SAVE], two[MAX_SAVE], three[MAX_SAVE], four[MAX_SAVE],
    mode = 0, entered_password[PASSWORD_LENGTH] = "";


unsigned char ReadKeypad(void) {
    unsigned char result = 10;
    PORTD = 0x7F;

    A = 0;
    delay_ms(3);
    if (C1 == 0) {
        result = '1';
        while (C1 == 0);
    }
    if (C2 == 0) {
        result = '2';
        while (C2 == 0);
    }
    if (C3 == 0) {
        result = '3';
        while (C3 == 0);
    }
    A = 1;

    B = 0;
    delay_ms(3);
    if (C1 == 0){
        result = '4';
        while (C1 == 0);
    }
    if (C2 == 0) {
        result = '5';
        while (C2 == 0);
    }
    if (C3 == 0) {
        result = '6';
        while (C3 == 0) ;
    }
    B = 1;

    C = 0;
    delay_ms(3);
    if (C1 == 0) {
        result = '7';
        while (C1 == 0);
    }
    if (C2 == 0) {
        result = '8';
        while (C2 == 0);
    }
    if (C3 == 0) {
        result = '9';
        while (C3 == 0);
    }
    C = 1;

    D = 0;
    delay_ms(3);
    if (C1 == 0) {
        result = '*';
        while (C1 == 0);
    }
    if (C2 == 0) {
        result = '0';
        while (C2 == 0);
    }
    if (C3 == 0) {
        result = '#';
        while (C3 == 0);
    }
    D = 1;

    return result;
}

void display_time(char second, char minute, char hour, char ok) {
    unsigned char second_ones = second % 10;
    unsigned char second_tens = second / 10;

    unsigned char minute_ones = minute % 10;
    unsigned char minute_tens = minute / 10;

    unsigned char hour_ones = hour % 10;
    unsigned char hour_tens = hour / 10;

    if (!delay || ok) {
        PORTC = (second_ones << 4) | second_tens;
        PORTA = (minute_tens << 4) | minute_ones;
        PORTB = (hour_tens << 4) | hour_ones;
    }
}

void save_progress(void) {
    Seconds[save_count] = time % 60;
    Minutes[save_count] = (time / 60) % 60;
    Hours[save_count] = (time / 3600) % 24;
    four[save_count] = entered_password[0] - '0';
    three[save_count] = entered_password[1] - '0';
    two[save_count] = entered_password[2] - '0';
    one[save_count] = entered_password[3] - '0';
    save_count++;
}

interrupt [TIM1_COMPA] void timer1_compa_isr(void) {
    time++;
    if (time == 86400)
        PORTA = PORTB = PORTC = time = 0;
    else
        display_time(time % 60, (time / 60) % 60, (time / 3600) % 24, 0);
}

void main(void) {
    unsigned char keypad, entered, i, j = 0;

    DDRA = DDRB = DDRC = 0xFF;
    DDRD = 0xF8;

    TCCR1A = 0x00;
    TCCR1B = 0x0C;
    OCR1AH = 0x7A;
    OCR1AL = 0x12;

    TIMSK = 0x10;

    #asm("sei")

    PORTA = PORTB = PORTC = time;
    PORTD = 0X7F;

    while (1) {
        keypad = ReadKeypad();

        if (keypad == '*') {
            delay = mode = 1;
            PORTA = PORTB = PORTC = 0xAA;
            j = 0;
            entered_password[0] = '\0';
            continue;
        }

        else if (keypad == '#') {
            delay = 1; mode = 2;
            for (i = 0; i < save_count; i++) {
                PORTA = PORTB = PORTC = 0xFF;
                delay_ms(1500);
                PORTA = (two[i] << 4) | one[i];
                PORTB = (four[i] << 4) | three[i];
                PORTC = 0xAA;
                delay_ms(3000);
                display_time(Seconds[i], Minutes[i], Hours[i], 1);
                delay_ms(3000);
            }
            delay = mode = 0;
        }

        else if (keypad != 10) {
            if (j < (PASSWORD_LENGTH - 1)) {
                entered_password[j] = keypad;
                j++;
            }
            if (j == 4) {
                entered_password[j] = '\0';
                j = 0;
                if (mode == 1) {
                    if (password_count < MAX_PASSWORDS) {
                        strcpy(passwords[password_count], entered_password);
                        password_count++;
                        delay = mode = 0;
                    }
                    entered_password[0] = '\0';
                    continue;
                }
                entered = 0;
                for (i = 0; i < password_count; i++)
                    if (strcmp(entered_password, passwords[i]) == 0)
                        entered = 1;

                if (entered) {
                    save_progress();
                    correct_pass = 1;
                    delay_ms(1500);
                    correct_pass = 0;
                } else {
                    PORTA = PORTC = 0x00;
                    PORTB = 0xDD;
                    delay = 1;
                    delay_ms(2000);
                }
                delay = 0;
                entered_password[0] = '\0';
            }
        }
    }
}
