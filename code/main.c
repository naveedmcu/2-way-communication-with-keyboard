unsigned short kp=0, cnt, oldstate = 0,oldstate_CAHR=0;
char txt[6],exit=0,COLM=0,uart_rd;
char data_array [32],char_number=1;
//char data_array [32];
// Keypad module connections
char  keypadPort at PORTD;
// End Keypad module connections

// Lcd pinout settings
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D7 at RB7_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D4 at RB4_bit;

// Pin direction
sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D7_Direction at TRISB7_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB4_bit;
//-----------------------------


void timer0_init()
{
T0CON.TMR0ON = 1;// Timer0 On/Off Control bit:1=Enables Timer0 / 0=Stops Timer0
T0CON.T08BIT = 0;// Timer0 8-bit/16-bit Control bit: 1=8-bit timer/counter / 0=16-bit timer/counter
T0CON.T0CS   = 0;// TMR0 Clock Source Select bit: 0=Internal Clock (CLKO) / 1=Transition on T0CKI pin
T0CON.T0SE   = 0;// TMR0 Source Edge Select bit: 0=low/high / 1=high/low
T0CON.PSA    = 0;// Prescaler Assignment bit: 0=Prescaler is assigned; 1=NOT assigned/bypassed
T0CON.T0PS2  = 1;// bits 2-0  PS2:PS0: Prescaler Select bits
T0CON.T0PS1  = 0;
T0CON.T0PS0  = 0;
TMR0H = 0xB;    // preset for Timer0 MSB register
TMR0L = 0xDC;    // preset for Timer0 LSB register
INTCON.TMR0IE=1;
INTCON.TMR0IF=0;
}
//------------------------------------------------------------------------------
void timer_reload()
{
 TMR0H = 0xB;    // preset for Timer0 MSB register
 TMR0L = 0xDC;    // preset for Timer0 LSB register
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
 /*
//  if (kp==20) data_array [++char_number]=charter;
   if (kp != oldstate)
  {
   data_array [++char_number]=charter;
   LCD_OUT(2,2,"kp != old");
   oldstate=KP;
  }
  else
  {
   data_array [char_number]=charter;
   LCD_OUT(2,2,"kp == old");
  }
 */
}



//------------------------------------------------------------------------------
// main
//------------------------------------------------------------------------------
void main()
{
 INTCON.GIE=1;
 adcon1=0x06;
 trisa=0xff;

 Trisc=0;

 portc=255;
 TRISC.B7=1;
 timer0_init();
// while(1);
//*********************
 trise =0;
 porte.b1=0;
//*********************

  cnt = 0;                                 // Reset counter
  Keypad_Init();                           // Initialize Keypad
  TRISE=0;
  timer0_init();
  Lcd_Init();                              // Initialize LCD
  Lcd_Cmd(_LCD_CLEAR);                     // Clear display
  Lcd_Cmd(_LCD_UNDERLINE_ON);                // Cursor off
  UART1_Init(9600);
  delay_ms(100);
  UART1_Write_Text("HELLO");
  UART1_Write_Text(" 2 WAY COMUNICATION ");
  LCD_OUT(1,1," 2 WAY COMUNICATION ");
  lcd_out(2,1," WRITE MESSAGE");
  DELAY_MS(3000);
  Lcd_Cmd(_LCD_CLEAR);
  lcd_out(2,1,"WRITE MESSAGE");
//  lcd_out(1,1,"1=SENDING MODE:2=RECEIVING MODE");
  INTCON.GIE=1;
/*
 for(;;)
 {
  kp = Keypad_Key_Click();
  if (kp==1)
  {
   Lcd_Cmd(_LCD_CLEAR);
   lcd_out(2,1,"SENDING MODE:PRESS RESET FOR CHANGING");
   break;
  }
  else if (kp==5)
  {
   Lcd_Cmd(_LCD_CLEAR);
   lcd_out(2,1,"RECEIVING MODE:PRESS RESET FOR CHANGING");
   Lcd_Cmd(_LCD_RETURN_HOME);
   for(;;)
   {
     do{
       if (UART1_Data_Ready()){
       uart_rd = UART1_Read();     // read the received data,
      }
     }while(uart_rd != '$');
    do{
     if (UART1_Data_Ready()){
       uart_rd = UART1_Read();     // read the received data,
       if (uart_rd!='#')
       {
        Lcd_Chr_Cp(uart_rd);
        UART1_Write(uart_rd);
       }
      }
     }while(uart_rd != '#');
     for (uart_rd=0;uart_rd<40;uart_rd++)
     {
      Lcd_Chr_Cp(" ");
     }
     lcd_out(2,1,"RECEIVING MODE:PRESS RESET FOR CHANGING");
     Lcd_Cmd(_LCD_RETURN_HOME);
   }
  }
 }
 */




 do {
   do{
//       kp = Keypad_Key_Press();          // Store key code in kp variable
      kp = Keypad_Key_Click();             // Store key code in kp variable
      if (exit==1)
      {
       kp=0;
       exit=0;
       break;
      }

     if (UART1_Data_Ready()){
      uart_rd = UART1_Read();     // read the received data,
     }
    if (uart_rd == '#')
    {
     Lcd_Cmd(_LCD_FIRST_ROW);
     while (UART1_Data_Ready()==0);
      uart_rd = UART1_Read();     // read the received data,
    }
     if (uart_rd == '$')
    {
     do{
     if (UART1_Data_Ready()){
       uart_rd = UART1_Read();     // read the received data,
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
//     UART1_Write('#');
    }
   }while (kp==0);

   timer_reload();
    switch (kp) {

      case  1: kp = 49; break; // 1
      case  2: kp = 52; break; // 4
      case  3: kp = 55; break; // 7
      case  4: kp = 83; break; // S
      case  5: kp = 50; break; // 2
      case  6: kp = 53; break; // 5
      case  7: kp = 56; break; // 8
      case  8: kp = 48; break; // 0
      case  9: kp = 51; break; // 3
      case 10: kp = 54; break; // 6
      case 11: kp = 57; break; // 9
      case 12: kp = 67; break; // C
      case 13: kp = 85; break; // U
      case 14: kp = 68; break; // D
      case 15: kp = 77; break; // M
      case 16: kp = 69; break; // E
    }

    if (kp==0)
    {
     if (kp != oldstate){
      cnt = 1;
//      data_array[0]='$';
//      data_array [char_number++]=
//      COLM++;
      oldstate = kp;
     }
    }
//------------------------------------------------------------------------------
    if (kp=='E')
    {
     UART1_Write('#');
     delay_ms(50);
/*
     data_array[0]='D';
     data_array[1]='A';
     data_array[2]='T';
     data_array[3]='A';
     data_array[4]=0;
*/
//     save_data(0);
     data_array [char_number]=0;
//     char_number--;
     data_array[0]='$';
     UART1_Write_Text(data_array);
     UART1_Write('#');
    }
//------------------------------------------------------------------------------
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
      else  if (cnt==3)
      {
       Lcd_Chr(1, COLM, 'C');
       save_data('C');
      }
      else  if (cnt==4)
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
      else  if (cnt==3)
      {
       Lcd_Chr(1, COLM, 'F');
       save_data('F');
      }
      else  if (cnt==4)
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
      else  if (cnt==3)
      {
       Lcd_Chr(1, COLM, 'I');
       save_data('I');
      }
      else  if (cnt==4)
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
      else  if (cnt==3)
      {
       Lcd_Chr(1, COLM, 'L');
       save_data('L');
      }
      else  if (cnt==4)
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
      else  if (cnt==3)
      {
       Lcd_Chr(1, COLM, 'O');
       save_data('O');
      }
      else  if (cnt==4)
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
      else  if (cnt==3)
      {
       Lcd_Chr(1, COLM, 'R');
       save_data('R');
      }
      else  if (cnt==4)
      {
       Lcd_Chr(1, COLM, 'S');
       save_data('S');
      }
      else  if (cnt==5)
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
      else  if (cnt==3)
      {
       Lcd_Chr(1, COLM, 'V');
       save_data('V');
      }
      else  if (cnt==4)
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
      else  if (cnt==3)
      {
       Lcd_Chr(1, COLM, 'Y');
       save_data('Y');
      }
      else  if (cnt==4)
      {
       Lcd_Chr(1, COLM, 'Z');
       save_data('Z');
      }
      else  if (cnt==5)
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
//     Lcd_Out(2, 10, "   ");
    }
//    WordToStr(cnt, txt);
//    Lcd_Out(2, 10, txt);
  } while (1);
}



void interrupt()
{
 if (INTCON.TMR0IF==1)
 {
//  PORTC=~PORTC;
  INTCON.TMR0IF=0;
  TMR0H = 0xB;
  TMR0L = 0xDC;
  exit=1;
 }
}