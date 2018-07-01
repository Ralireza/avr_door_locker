
#include <mega32.h>
#include <io.h>
#include <delay.h>
#include <alcd.h>

#define pad PORTD
#define r1 PORTD.0
#define r2 PORTD.1
#define r3 PORTD.2
#define r4 PORTD.3

#define c1 PORTD.4
#define c2 PORTD.5
#define c3 PORTD.7


void check1(void);
void check2(void);
void check3(void);
void check4(void);
void chpass();
void beepbeep();
void notbeep();

   int index=0; 
      unsigned short c=1;
      unsigned char value; 
      unsigned char input[4]; 
      unsigned char pass[4]={'7','8','9','#'};

void main(void)
{


DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
/****************************************************************
*****************************************************************
*****************************************************************
****************************************************************/


	DDRA=0xff; //LCD_DATA port as output port
	DDRB=0xff; //signal as out put
    DDRC=0xff;
	PORTB=0x00;
	DDRD=0x0f;
	pad=0xf0;
	lcd_init(16); //initialization of LCD
	lcd_puts("Enter Password: ");
	while(1)
	{
		PORTD=0xF0; //set all the input to one
		value=PIND; //get the PORTD value in variable “value”
		if(value!=0xf0) //if any key is pressed value changed
		{                
                 
			check1();
			check2();
			check3();
			check4();
            
           chpass();
	    }
    }


}



void check1(void)
{
    //DDRD = 0xf0;
    pad =0b11111110;
    //pad &= (0<<r1);
    delay_us(10);
    if(PIND.4==0)
    {              
        lcd_gotoxy(index,2);  
        lcd_puts("1");
        PORTB =0b00000001;  
        input[index]='1';
        index++; 
        delay_ms(70);

    }
    if(PIND.5==0)
        {

        lcd_gotoxy(index,2);  
                    lcd_puts("2");
                    input[index]='2';
            PORTB =0b00000010;
            index++; 
        delay_ms(70);
        }
    if(PIND.6==0)
        {
        lcd_gotoxy(index,2);  
            lcd_puts("3");  
            PORTB =0b00000100;
             input[index]='3';
            index++; 
        delay_ms(70);
        } 
        value=0xF0;
}


void check2(void)
{
    pad=0b11111101;
    //pad &= (0<<r2);
    delay_us(10);
    if(PIND.4==0)
        {
        lcd_gotoxy(index,2);  
            lcd_puts("4");
            PORTB =0b00001000; 
            input[index]='4';
            index++; 
        delay_ms(70);
        }
     if(PIND.5==0)
        {
        lcd_gotoxy(index,2);  
            lcd_puts("5");
            PORTB =0b00010000;
            input[index]='5';
            index++; 
        delay_ms(70);
        }
     if(PIND.6==0)
        {
        lcd_gotoxy(index,2);  
            lcd_puts("6");
            PORTB =0b00100000;
            input[index]='6';
            index++; 
        delay_ms(70);
        } 
                value=0xF0;

}

void check3(void)
{
    pad=0b11111011;
    //pad &= (0<<r3);
    delay_us(10);
    if(PIND.4==0)
        {
        lcd_gotoxy(index,2);  
            lcd_puts("7");
            PORTB =0b01000000;
            input[index]='7';
            index++; 
        delay_ms(70);
        }
     if(PIND.5==0)
        {
        lcd_gotoxy(index,2);  
            lcd_puts("8");
            PORTB =0b10000000;
            input[index]='8';
            index++; 
        delay_ms(70);
        }
     if(PIND.6==0)
        {
            
        lcd_gotoxy(index,2);  
            lcd_puts("9");       
            input[index]='9';
            index++; 
        delay_ms(70);
           
        }    
                value=0xF0;

}

void check4(void)
{
    pad =0b11110111;
    //pad &= (0<<r4);
    delay_us(10);
    if(PIND.4==0)
        {
        lcd_gotoxy(index,2);  
            lcd_puts("*");
            input[index]='*';
            index++; 
        delay_ms(70);
        }
   if(PIND.5==0)
            {
        lcd_gotoxy(index,2);  
                lcd_puts("0");
                PORTB =0b00000000;
                input[index]='0';
            index++; 
        delay_ms(70);
            }
   if(PIND.6==0)
    {
        lcd_gotoxy(index,2);  
        lcd_puts("#");   
        input[index]='#';
            index++; 
        delay_ms(70);
        
    }   
            value=0xF0;

}

void chpass()
{
    if(index<4){
        
       // lcd_puts("fuuuk");   
        
	} 
            
    if(index>3){
       
       int i;
       for(i=0;i<4;i++){
             if(input[i]==pass[i]) {
                c=c<<1;
            }
       }
       
       if(c==16)
       {                       
       lcd_clear();
       lcd_puts("door is opened"); 
        beepbeep();
       } 
       
      else if(c!=16 && index==4)
       {
        lcd_clear();
       lcd_puts("wrong password!");
       notbeep();
       //delay_ms(500); 
       lcd_clear();
       lcd_puts("Enter another:");
       index=0;  
       c=1;
       } 
       
       else if (c!=16) 
       {   
          lcd_clear();
                  index=0;
         lcd_puts("Enter Password:"); 
         c=1;

       }
        
    }
    
    
    
    
    
    
    
}




void beepbeep() {
int i;
         for(i=0;i<10;i++){
             PORTB=0b10101010;
             delay_ms(20);
             PORTB=0b01010101;
             delay_ms(20);

         }

}

void notbeep(){
         int i;
       for(i=0;i<10;i++){
             PORTC.0=1;
             delay_ms(20);
             PORTC.0=0;
             delay_ms(20);

         }

}