#line 1 "E:/Software and Electronic wilcom/PROGRAMS/2 way comunication with keypab/code/main.c"
unsigned short kp=0, cnt, oldstate = 0,oldstate_CAHR=0;
char txt[6],exit=0,COLM=0,uart_rd;
char data_array [32],char_number=1;


char keypadPort at PORTD;



sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D7 at RB7_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D4 at RB4_bit;


sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D7_Direction at TRISB7_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB4_bit;



void timer0_init()
{
T0CON.TMR0ON = 1;
T0CON.T08BIT = 0;
T0CON.T0CS = 0;
T0CON.T0SE = 0;
T0CON.PSA = 0;
T0CON.T0PS2 = 1;
T0CON.T0PS1 = 0;
T0CON.T0PS0 = 0;
TMR0H = 0xB;
TMR0L = 0xDC;
INTCON.TMR0IE=1;
INTCON.TMR0IF=0;
}

void timer_reload()
{
 TMR0H = 0xB;
 TMR0L = 0xDC;
}

void chk()
{
 if (kp != oldstate)
 {
 cnt = 1;
 COLM++;
 oldstate = kp;
 }
}


void cr_shift_left()
{
 Lcd_Cmd(_LCD_MOVE_CURSOR_LEFT);
}

void enter()
{

}


void save_data(char charter)
{
 data_array [COLM]=charter;
 char_number=COLM+1;
#line 89 "E:/Software and Electronic wilcom/PROGRAMS/2 way comunication with keypab/code/main.c"
}






void main()
{
 INTCON.GIE=1;
 adcon1=0x06;
 trisa=0xff;

 Trisc=0;

 portc=255;
 TRISC.B7=1;
 timer0_init();


 trise =0;
 porte.b1=0;


 cnt = 0;
 Keypad_Init();
 TRISE=0;
 timer0_init();
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_UNDERLINE_ON);
 UART1_Init(9600);
 delay_ms(100);
 UART1_Write_Text("HELLO");
 UART1_Write_Text(" 2 WAY COMUNICATION ");
 LCD_OUT(1,1," 2 WAY COMUNICATION ");
 lcd_out(2,1," WRITE MESSAGE");
 DELAY_MS(3000);
 Lcd_Cmd(_LCD_CLEAR);
 lcd_out(2,1,"WRITE MESSAGE");

 INTCON.GIE=1;
#line 177 "E:/Software and Electronic wilcom/PROGRAMS/2 way comunication with keypab/code/main.c"
 do {
 do{

 kp = Keypad_Key_Click();
 if (exit==1)
 {
 kp=0;
 exit=0;
 break;
 }

 if (UART1_Data_Ready()){
 uart_rd = UART1_Read();
 }
 if (uart_rd == '#')
 {
 Lcd_Cmd(_LCD_FIRST_ROW);
 while (UART1_Data_Ready()==0);
 uart_rd = UART1_Read();
 }
 if (uart_rd == '$')
 {
 do{
 if (UART1_Data_Ready()){
 uart_rd = UART1_Read();
 if (uart_rd!='#')
 {
 Lcd_Chr_Cp(uart_rd);
 UART1_Write(uart_rd);
 }
 }
 }while(uart_rd != '#');
 for (uart_rd=0;uart_rd<40;uart_rd++)
 {
 Lcd_Chr_Cp(' ');
 }
 lcd_out(2,1,"RECEIVED MESSAGE");
 uart_rd=1;
 Lcd_Cmd(_LCD_FIRST_ROW);
 }
 if (kp!=0 && uart_rd==1)
 {
 uart_rd=2;
 Lcd_Cmd(_LCD_CLEAR);
 cnt=1;
 oldstate=kp;
 COLM=0;
 save_data(0);
 lcd_out(2,1,"WRITE MESSAGE");
 Lcd_Cmd(_LCD_FIRST_ROW);

 }
 }while (kp==0);

 timer_reload();
 switch (kp) {

 case 1: kp = 49; break;
 case 2: kp = 52; break;
 case 3: kp = 55; break;
 case 4: kp = 83; break;
 case 5: kp = 50; break;
 case 6: kp = 53; break;
 case 7: kp = 56; break;
 case 8: kp = 48; break;
 case 9: kp = 51; break;
 case 10: kp = 54; break;
 case 11: kp = 57; break;
 case 12: kp = 67; break;
 case 13: kp = 85; break;
 case 14: kp = 68; break;
 case 15: kp = 77; break;
 case 16: kp = 69; break;
 }

 if (kp==0)
 {
 if (kp != oldstate){
 cnt = 1;



 oldstate = kp;
 }
 }

 if (kp=='E')
 {
 UART1_Write('#');
 delay_ms(50);
#line 275 "E:/Software and Electronic wilcom/PROGRAMS/2 way comunication with keypab/code/main.c"
 data_array [char_number]=0;

 data_array[0]='$';
 UART1_Write_Text(data_array);
 UART1_Write('#');
 }

 if (kp=='1')
 {
 chk();
 if (cnt==3)
 {
 cnt=1;
 }
 if (cnt==1)
 {
 Lcd_Chr(1, COLM, '1');
 save_data('1');
 }
 else if (cnt==2)
 {
 Lcd_Chr(1, COLM,'.');
 save_data('.');
 }
 cnt++;
 }


 if (kp=='2')
 {
 chk();
 if (cnt==5)
 {
 cnt=1;
 }
 if (cnt==1)
 {
 Lcd_Chr(1, COLM, 'A');
 save_data('A');
 }
 else if (cnt==2)
 {
 Lcd_Chr(1, COLM, 'B');
 save_data('B');
 }
 else if (cnt==3)
 {
 Lcd_Chr(1, COLM, 'C');
 save_data('C');
 }
 else if (cnt==4)
 {
 Lcd_Chr(1, COLM, '2');
 save_data('2');
 }
 cnt++;
 }

 if (kp=='3')
 {
 chk();
 if (cnt==5)
 {
 cnt=1;
 }
 if (cnt==1)
 {
 Lcd_Chr(1, COLM, 'D');
 save_data('D');
 }
 else if (cnt==2)
 {
 Lcd_Chr(1, COLM, 'E');
 save_data('E');
 }
 else if (cnt==3)
 {
 Lcd_Chr(1, COLM, 'F');
 save_data('F');
 }
 else if (cnt==4)
 {
 Lcd_Chr(1, COLM, '3');
 save_data('3');
 }
 cnt++;
 }

 if (kp=='4')
 {
 chk();
 if (cnt==5)
 {
 cnt=1;
 }
 if (cnt==1)
 {
 Lcd_Chr(1, COLM, 'G');
 save_data('G');
 }
 else if (cnt==2)
 {
 Lcd_Chr(1, COLM, 'H');
 save_data('H');
 }
 else if (cnt==3)
 {
 Lcd_Chr(1, COLM, 'I');
 save_data('I');
 }
 else if (cnt==4)
 {
 Lcd_Chr(1, COLM, '4');
 save_data('4');
 }
 cnt++;
 }

 if (kp=='5')
 {
 chk();
 if (cnt==5)
 {
 cnt=1;
 }
 if (cnt==1)
 {
 Lcd_Chr(1, COLM, 'J');
 save_data('J');
 }
 else if (cnt==2)
 {
 Lcd_Chr(1, COLM, 'K');
 save_data('K');
 }
 else if (cnt==3)
 {
 Lcd_Chr(1, COLM, 'L');
 save_data('L');
 }
 else if (cnt==4)
 {
 Lcd_Chr(1, COLM, '5');
 save_data('5');
 }
 cnt++;
 }

 if (kp=='6')
 {
 chk();
 if (cnt==5)
 {
 cnt=1;
 }
 if (cnt==1)
 {
 Lcd_Chr(1, COLM, 'M');
 save_data('M');
 }
 else if (cnt==2)
 {
 Lcd_Chr(1, COLM, 'N');
 save_data('N');
 }
 else if (cnt==3)
 {
 Lcd_Chr(1, COLM, 'O');
 save_data('O');
 }
 else if (cnt==4)
 {
 Lcd_Chr(1, COLM, '6');
 save_data('6');
 }
 cnt++;
 }

 if (kp=='7')
 {
 chk();
 if (cnt==6)
 {
 cnt=1;
 }
 if (cnt==1)
 {
 Lcd_Chr(1, COLM, 'P');
 save_data('P');
 }
 else if (cnt==2)
 {
 Lcd_Chr(1, COLM, 'Q');
 save_data('Q');
 }
 else if (cnt==3)
 {
 Lcd_Chr(1, COLM, 'R');
 save_data('R');
 }
 else if (cnt==4)
 {
 Lcd_Chr(1, COLM, 'S');
 save_data('S');
 }
 else if (cnt==5)
 {
 Lcd_Chr(1, COLM, '7');
 save_data('7');
 }
 cnt++;
 }

 if (kp=='8')
 {
 chk();
 if (cnt==5)
 {
 cnt=1;
 }
 if (cnt==1)
 {
 Lcd_Chr(1, COLM, 'T');
 save_data('T');
 }
 else if (cnt==2)
 {
 Lcd_Chr(1, COLM, 'U');
 save_data('U');
 }
 else if (cnt==3)
 {
 Lcd_Chr(1, COLM, 'V');
 save_data('V');
 }
 else if (cnt==4)
 {
 Lcd_Chr(1, COLM, '8');
 save_data('8');
 }
 cnt++;
 }

 if (kp=='9')
 {
 chk();
 if (cnt==6)
 {
 cnt=1;
 }
 if (cnt==1)
 {
 Lcd_Chr(1, COLM, 'W');
 save_data('W');
 }
 else if (cnt==2)
 {
 Lcd_Chr(1, COLM, 'X');
 save_data('X');
 }
 else if (cnt==3)
 {
 Lcd_Chr(1, COLM, 'Y');
 save_data('Y');
 }
 else if (cnt==4)
 {
 Lcd_Chr(1, COLM, 'Z');
 save_data('Z');
 }
 else if (cnt==5)
 {
 Lcd_Chr(1, COLM, '9');
 save_data('9');
 }
 cnt++;
 }

 if (kp=='0')
 {
 chk();
 if (cnt==3)
 {
 cnt=1;
 }
 if (cnt==1)
 {
 Lcd_Chr(1, COLM, '0');
 save_data('0');
 }
 else if (cnt==2)
 {
 Lcd_Chr(1, COLM,' ');
 save_data(' ');
 }
 cnt++;
 }
 if (kp=='C')
 {
 if (COLM!=0)
 {
 cr_shift_left();
 Lcd_Chr(1, COLM--, ' ');
 cr_shift_left();
 cnt=1;
 oldstate=kp;
 COLM++;
 save_data(0);
 COLM--;
 }
 }

 if (cnt == 255)
 {
 cnt = 0;

 }


 } while (1);
}



void interrupt()
{
 if (INTCON.TMR0IF==1)
 {

 INTCON.TMR0IF=0;
 TMR0H = 0xB;
 TMR0L = 0xDC;
 exit=1;
 }
}
