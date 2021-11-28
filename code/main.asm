
_timer0_init:

;main.c,27 :: 		void timer0_init()
;main.c,29 :: 		T0CON.TMR0ON = 1;// Timer0 On/Off Control bit:1=Enables Timer0 / 0=Stops Timer0
	BSF         T0CON+0, 7 
;main.c,30 :: 		T0CON.T08BIT = 0;// Timer0 8-bit/16-bit Control bit: 1=8-bit timer/counter / 0=16-bit timer/counter
	BCF         T0CON+0, 6 
;main.c,31 :: 		T0CON.T0CS   = 0;// TMR0 Clock Source Select bit: 0=Internal Clock (CLKO) / 1=Transition on T0CKI pin
	BCF         T0CON+0, 5 
;main.c,32 :: 		T0CON.T0SE   = 0;// TMR0 Source Edge Select bit: 0=low/high / 1=high/low
	BCF         T0CON+0, 4 
;main.c,33 :: 		T0CON.PSA    = 0;// Prescaler Assignment bit: 0=Prescaler is assigned; 1=NOT assigned/bypassed
	BCF         T0CON+0, 3 
;main.c,34 :: 		T0CON.T0PS2  = 1;// bits 2-0  PS2:PS0: Prescaler Select bits
	BSF         T0CON+0, 2 
;main.c,35 :: 		T0CON.T0PS1  = 0;
	BCF         T0CON+0, 1 
;main.c,36 :: 		T0CON.T0PS0  = 0;
	BCF         T0CON+0, 0 
;main.c,37 :: 		TMR0H = 0xB;    // preset for Timer0 MSB register
	MOVLW       11
	MOVWF       TMR0H+0 
;main.c,38 :: 		TMR0L = 0xDC;    // preset for Timer0 LSB register
	MOVLW       220
	MOVWF       TMR0L+0 
;main.c,39 :: 		INTCON.TMR0IE=1;
	BSF         INTCON+0, 5 
;main.c,40 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;main.c,41 :: 		}
L_end_timer0_init:
	RETURN      0
; end of _timer0_init

_timer_reload:

;main.c,43 :: 		void timer_reload()
;main.c,45 :: 		TMR0H = 0xB;    // preset for Timer0 MSB register
	MOVLW       11
	MOVWF       TMR0H+0 
;main.c,46 :: 		TMR0L = 0xDC;    // preset for Timer0 LSB register
	MOVLW       220
	MOVWF       TMR0L+0 
;main.c,47 :: 		}
L_end_timer_reload:
	RETURN      0
; end of _timer_reload

_chk:

;main.c,49 :: 		void chk()
;main.c,51 :: 		if (kp != oldstate)
	MOVF        _kp+0, 0 
	XORWF       _oldstate+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_chk0
;main.c,53 :: 		cnt = 1;
	MOVLW       1
	MOVWF       _cnt+0 
;main.c,54 :: 		COLM++;
	INCF        _COLM+0, 1 
;main.c,55 :: 		oldstate = kp;
	MOVF        _kp+0, 0 
	MOVWF       _oldstate+0 
;main.c,56 :: 		}
L_chk0:
;main.c,57 :: 		}
L_end_chk:
	RETURN      0
; end of _chk

_cr_shift_left:

;main.c,60 :: 		void cr_shift_left()
;main.c,62 :: 		Lcd_Cmd(_LCD_MOVE_CURSOR_LEFT);
	MOVLW       16
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;main.c,63 :: 		}
L_end_cr_shift_left:
	RETURN      0
; end of _cr_shift_left

_enter:

;main.c,65 :: 		void enter()
;main.c,68 :: 		}
L_end_enter:
	RETURN      0
; end of _enter

_save_data:

;main.c,71 :: 		void save_data(char charter)
;main.c,73 :: 		data_array [COLM]=charter;
	MOVLW       _data_array+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_data_array+0)
	MOVWF       FSR1H 
	MOVF        _COLM+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        FARG_save_data_charter+0, 0 
	MOVWF       POSTINC1+0 
;main.c,74 :: 		char_number=COLM+1;
	MOVF        _COLM+0, 0 
	ADDLW       1
	MOVWF       _char_number+0 
;main.c,89 :: 		}
L_end_save_data:
	RETURN      0
; end of _save_data

_main:

;main.c,96 :: 		void main()
;main.c,98 :: 		INTCON.GIE=1;
	BSF         INTCON+0, 7 
;main.c,99 :: 		adcon1=0x06;
	MOVLW       6
	MOVWF       ADCON1+0 
;main.c,100 :: 		trisa=0xff;
	MOVLW       255
	MOVWF       TRISA+0 
;main.c,102 :: 		Trisc=0;
	CLRF        TRISC+0 
;main.c,104 :: 		portc=255;
	MOVLW       255
	MOVWF       PORTC+0 
;main.c,105 :: 		TRISC.B7=1;
	BSF         TRISC+0, 7 
;main.c,106 :: 		timer0_init();
	CALL        _timer0_init+0, 0
;main.c,109 :: 		trise =0;
	CLRF        TRISE+0 
;main.c,110 :: 		porte.b1=0;
	BCF         PORTE+0, 1 
;main.c,113 :: 		cnt = 0;                                 // Reset counter
	CLRF        _cnt+0 
;main.c,114 :: 		Keypad_Init();                           // Initialize Keypad
	CALL        _Keypad_Init+0, 0
;main.c,115 :: 		TRISE=0;
	CLRF        TRISE+0 
;main.c,116 :: 		timer0_init();
	CALL        _timer0_init+0, 0
;main.c,117 :: 		Lcd_Init();                              // Initialize LCD
	CALL        _Lcd_Init+0, 0
;main.c,118 :: 		Lcd_Cmd(_LCD_CLEAR);                     // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;main.c,119 :: 		Lcd_Cmd(_LCD_UNDERLINE_ON);                // Cursor off
	MOVLW       14
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;main.c,120 :: 		UART1_Init(9600);
	MOVLW       25
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;main.c,121 :: 		delay_ms(100);
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_main1:
	DECFSZ      R13, 1, 1
	BRA         L_main1
	DECFSZ      R12, 1, 1
	BRA         L_main1
	NOP
	NOP
;main.c,122 :: 		UART1_Write_Text("HELLO");
	MOVLW       ?lstr1_main+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_main+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;main.c,123 :: 		UART1_Write_Text(" 2 WAY COMUNICATION ");
	MOVLW       ?lstr2_main+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_main+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;main.c,124 :: 		LCD_OUT(1,1," 2 WAY COMUNICATION ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_main+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_main+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;main.c,125 :: 		lcd_out(2,1," WRITE MESSAGE");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_main+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_main+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;main.c,126 :: 		DELAY_MS(3000);
	MOVLW       16
	MOVWF       R11, 0
	MOVLW       57
	MOVWF       R12, 0
	MOVLW       13
	MOVWF       R13, 0
L_main2:
	DECFSZ      R13, 1, 1
	BRA         L_main2
	DECFSZ      R12, 1, 1
	BRA         L_main2
	DECFSZ      R11, 1, 1
	BRA         L_main2
	NOP
	NOP
;main.c,127 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;main.c,128 :: 		lcd_out(2,1,"WRITE MESSAGE");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_main+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_main+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;main.c,130 :: 		INTCON.GIE=1;
	BSF         INTCON+0, 7 
;main.c,177 :: 		do {
L_main3:
;main.c,178 :: 		do{
L_main6:
;main.c,180 :: 		kp = Keypad_Key_Click();             // Store key code in kp variable
	CALL        _Keypad_Key_Click+0, 0
	MOVF        R0, 0 
	MOVWF       _kp+0 
;main.c,181 :: 		if (exit==1)
	MOVF        _exit+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main9
;main.c,183 :: 		kp=0;
	CLRF        _kp+0 
;main.c,184 :: 		exit=0;
	CLRF        _exit+0 
;main.c,185 :: 		break;
	GOTO        L_main7
;main.c,186 :: 		}
L_main9:
;main.c,188 :: 		if (UART1_Data_Ready()){
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main10
;main.c,189 :: 		uart_rd = UART1_Read();     // read the received data,
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _uart_rd+0 
;main.c,190 :: 		}
L_main10:
;main.c,191 :: 		if (uart_rd == '#')
	MOVF        _uart_rd+0, 0 
	XORLW       35
	BTFSS       STATUS+0, 2 
	GOTO        L_main11
;main.c,193 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW       128
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;main.c,194 :: 		while (UART1_Data_Ready()==0);
L_main12:
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main13
	GOTO        L_main12
L_main13:
;main.c,195 :: 		uart_rd = UART1_Read();     // read the received data,
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _uart_rd+0 
;main.c,196 :: 		}
L_main11:
;main.c,197 :: 		if (uart_rd == '$')
	MOVF        _uart_rd+0, 0 
	XORLW       36
	BTFSS       STATUS+0, 2 
	GOTO        L_main14
;main.c,199 :: 		do{
L_main15:
;main.c,200 :: 		if (UART1_Data_Ready()){
	CALL        _UART1_Data_Ready+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main18
;main.c,201 :: 		uart_rd = UART1_Read();     // read the received data,
	CALL        _UART1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _uart_rd+0 
;main.c,202 :: 		if (uart_rd!='#')
	MOVF        R0, 0 
	XORLW       35
	BTFSC       STATUS+0, 2 
	GOTO        L_main19
;main.c,204 :: 		Lcd_Chr_Cp(uart_rd);
	MOVF        _uart_rd+0, 0 
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;main.c,205 :: 		UART1_Write(uart_rd);
	MOVF        _uart_rd+0, 0 
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;main.c,206 :: 		}
L_main19:
;main.c,207 :: 		}
L_main18:
;main.c,208 :: 		}while(uart_rd != '#');
	MOVF        _uart_rd+0, 0 
	XORLW       35
	BTFSS       STATUS+0, 2 
	GOTO        L_main15
;main.c,209 :: 		for (uart_rd=0;uart_rd<40;uart_rd++)
	CLRF        _uart_rd+0 
L_main20:
	MOVLW       40
	SUBWF       _uart_rd+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main21
;main.c,211 :: 		Lcd_Chr_Cp(' ');
	MOVLW       32
	MOVWF       FARG_Lcd_Chr_CP_out_char+0 
	CALL        _Lcd_Chr_CP+0, 0
;main.c,209 :: 		for (uart_rd=0;uart_rd<40;uart_rd++)
	INCF        _uart_rd+0, 1 
;main.c,212 :: 		}
	GOTO        L_main20
L_main21:
;main.c,213 :: 		lcd_out(2,1,"RECEIVED MESSAGE");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_main+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_main+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;main.c,214 :: 		uart_rd=1;
	MOVLW       1
	MOVWF       _uart_rd+0 
;main.c,215 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW       128
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;main.c,216 :: 		}
L_main14:
;main.c,217 :: 		if (kp!=0 && uart_rd==1)
	MOVF        _kp+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main25
	MOVF        _uart_rd+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main25
L__main138:
;main.c,219 :: 		uart_rd=2;
	MOVLW       2
	MOVWF       _uart_rd+0 
;main.c,220 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;main.c,221 :: 		cnt=1;
	MOVLW       1
	MOVWF       _cnt+0 
;main.c,222 :: 		oldstate=kp;
	MOVF        _kp+0, 0 
	MOVWF       _oldstate+0 
;main.c,223 :: 		COLM=0;
	CLRF        _COLM+0 
;main.c,224 :: 		save_data(0);
	CLRF        FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,225 :: 		lcd_out(2,1,"WRITE MESSAGE");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr7_main+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr7_main+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;main.c,226 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW       128
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;main.c,228 :: 		}
L_main25:
;main.c,229 :: 		}while (kp==0);
	MOVF        _kp+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main6
L_main7:
;main.c,231 :: 		timer_reload();
	CALL        _timer_reload+0, 0
;main.c,232 :: 		switch (kp) {
	GOTO        L_main26
;main.c,234 :: 		case  1: kp = 49; break; // 1
L_main28:
	MOVLW       49
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,235 :: 		case  2: kp = 52; break; // 4
L_main29:
	MOVLW       52
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,236 :: 		case  3: kp = 55; break; // 7
L_main30:
	MOVLW       55
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,237 :: 		case  4: kp = 83; break; // S
L_main31:
	MOVLW       83
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,238 :: 		case  5: kp = 50; break; // 2
L_main32:
	MOVLW       50
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,239 :: 		case  6: kp = 53; break; // 5
L_main33:
	MOVLW       53
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,240 :: 		case  7: kp = 56; break; // 8
L_main34:
	MOVLW       56
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,241 :: 		case  8: kp = 48; break; // 0
L_main35:
	MOVLW       48
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,242 :: 		case  9: kp = 51; break; // 3
L_main36:
	MOVLW       51
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,243 :: 		case 10: kp = 54; break; // 6
L_main37:
	MOVLW       54
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,244 :: 		case 11: kp = 57; break; // 9
L_main38:
	MOVLW       57
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,245 :: 		case 12: kp = 67; break; // C
L_main39:
	MOVLW       67
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,246 :: 		case 13: kp = 85; break; // U
L_main40:
	MOVLW       85
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,247 :: 		case 14: kp = 68; break; // D
L_main41:
	MOVLW       68
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,248 :: 		case 15: kp = 77; break; // M
L_main42:
	MOVLW       77
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,249 :: 		case 16: kp = 69; break; // E
L_main43:
	MOVLW       69
	MOVWF       _kp+0 
	GOTO        L_main27
;main.c,250 :: 		}
L_main26:
	MOVF        _kp+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_main28
	MOVF        _kp+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_main29
	MOVF        _kp+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_main30
	MOVF        _kp+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_main31
	MOVF        _kp+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L_main32
	MOVF        _kp+0, 0 
	XORLW       6
	BTFSC       STATUS+0, 2 
	GOTO        L_main33
	MOVF        _kp+0, 0 
	XORLW       7
	BTFSC       STATUS+0, 2 
	GOTO        L_main34
	MOVF        _kp+0, 0 
	XORLW       8
	BTFSC       STATUS+0, 2 
	GOTO        L_main35
	MOVF        _kp+0, 0 
	XORLW       9
	BTFSC       STATUS+0, 2 
	GOTO        L_main36
	MOVF        _kp+0, 0 
	XORLW       10
	BTFSC       STATUS+0, 2 
	GOTO        L_main37
	MOVF        _kp+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L_main38
	MOVF        _kp+0, 0 
	XORLW       12
	BTFSC       STATUS+0, 2 
	GOTO        L_main39
	MOVF        _kp+0, 0 
	XORLW       13
	BTFSC       STATUS+0, 2 
	GOTO        L_main40
	MOVF        _kp+0, 0 
	XORLW       14
	BTFSC       STATUS+0, 2 
	GOTO        L_main41
	MOVF        _kp+0, 0 
	XORLW       15
	BTFSC       STATUS+0, 2 
	GOTO        L_main42
	MOVF        _kp+0, 0 
	XORLW       16
	BTFSC       STATUS+0, 2 
	GOTO        L_main43
L_main27:
;main.c,252 :: 		if (kp==0)
	MOVF        _kp+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_main44
;main.c,254 :: 		if (kp != oldstate){
	MOVF        _kp+0, 0 
	XORWF       _oldstate+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_main45
;main.c,255 :: 		cnt = 1;
	MOVLW       1
	MOVWF       _cnt+0 
;main.c,259 :: 		oldstate = kp;
	MOVF        _kp+0, 0 
	MOVWF       _oldstate+0 
;main.c,260 :: 		}
L_main45:
;main.c,261 :: 		}
L_main44:
;main.c,263 :: 		if (kp=='E')
	MOVF        _kp+0, 0 
	XORLW       69
	BTFSS       STATUS+0, 2 
	GOTO        L_main46
;main.c,265 :: 		UART1_Write('#');
	MOVLW       35
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;main.c,266 :: 		delay_ms(50);
	MOVLW       65
	MOVWF       R12, 0
	MOVLW       238
	MOVWF       R13, 0
L_main47:
	DECFSZ      R13, 1, 1
	BRA         L_main47
	DECFSZ      R12, 1, 1
	BRA         L_main47
	NOP
;main.c,275 :: 		data_array [char_number]=0;
	MOVLW       _data_array+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_data_array+0)
	MOVWF       FSR1H 
	MOVF        _char_number+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;main.c,277 :: 		data_array[0]='$';
	MOVLW       36
	MOVWF       _data_array+0 
;main.c,278 :: 		UART1_Write_Text(data_array);
	MOVLW       _data_array+0
	MOVWF       FARG_UART1_Write_Text_uart_text+0 
	MOVLW       hi_addr(_data_array+0)
	MOVWF       FARG_UART1_Write_Text_uart_text+1 
	CALL        _UART1_Write_Text+0, 0
;main.c,279 :: 		UART1_Write('#');
	MOVLW       35
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;main.c,280 :: 		}
L_main46:
;main.c,282 :: 		if (kp=='1')
	MOVF        _kp+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_main48
;main.c,284 :: 		chk();
	CALL        _chk+0, 0
;main.c,285 :: 		if (cnt==3)
	MOVF        _cnt+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main49
;main.c,287 :: 		cnt=1;
	MOVLW       1
	MOVWF       _cnt+0 
;main.c,288 :: 		}
L_main49:
;main.c,289 :: 		if (cnt==1)
	MOVF        _cnt+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main50
;main.c,291 :: 		Lcd_Chr(1, COLM, '1');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       49
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,292 :: 		save_data('1');
	MOVLW       49
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,293 :: 		}
	GOTO        L_main51
L_main50:
;main.c,294 :: 		else if (cnt==2)
	MOVF        _cnt+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main52
;main.c,296 :: 		Lcd_Chr(1, COLM,'.');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       46
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,297 :: 		save_data('.');
	MOVLW       46
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,298 :: 		}
L_main52:
L_main51:
;main.c,299 :: 		cnt++;
	INCF        _cnt+0, 1 
;main.c,300 :: 		}
L_main48:
;main.c,303 :: 		if (kp=='2')
	MOVF        _kp+0, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_main53
;main.c,305 :: 		chk();
	CALL        _chk+0, 0
;main.c,306 :: 		if (cnt==5)
	MOVF        _cnt+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_main54
;main.c,308 :: 		cnt=1;
	MOVLW       1
	MOVWF       _cnt+0 
;main.c,309 :: 		}
L_main54:
;main.c,310 :: 		if (cnt==1)
	MOVF        _cnt+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main55
;main.c,312 :: 		Lcd_Chr(1, COLM, 'A');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       65
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,313 :: 		save_data('A');
	MOVLW       65
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,314 :: 		}
	GOTO        L_main56
L_main55:
;main.c,315 :: 		else if (cnt==2)
	MOVF        _cnt+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main57
;main.c,317 :: 		Lcd_Chr(1, COLM, 'B');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       66
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,318 :: 		save_data('B');
	MOVLW       66
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,319 :: 		}
	GOTO        L_main58
L_main57:
;main.c,320 :: 		else  if (cnt==3)
	MOVF        _cnt+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main59
;main.c,322 :: 		Lcd_Chr(1, COLM, 'C');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,323 :: 		save_data('C');
	MOVLW       67
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,324 :: 		}
	GOTO        L_main60
L_main59:
;main.c,325 :: 		else  if (cnt==4)
	MOVF        _cnt+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_main61
;main.c,327 :: 		Lcd_Chr(1, COLM, '2');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       50
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,328 :: 		save_data('2');
	MOVLW       50
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,329 :: 		}
L_main61:
L_main60:
L_main58:
L_main56:
;main.c,330 :: 		cnt++;
	INCF        _cnt+0, 1 
;main.c,331 :: 		}
L_main53:
;main.c,333 :: 		if (kp=='3')
	MOVF        _kp+0, 0 
	XORLW       51
	BTFSS       STATUS+0, 2 
	GOTO        L_main62
;main.c,335 :: 		chk();
	CALL        _chk+0, 0
;main.c,336 :: 		if (cnt==5)
	MOVF        _cnt+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_main63
;main.c,338 :: 		cnt=1;
	MOVLW       1
	MOVWF       _cnt+0 
;main.c,339 :: 		}
L_main63:
;main.c,340 :: 		if (cnt==1)
	MOVF        _cnt+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main64
;main.c,342 :: 		Lcd_Chr(1, COLM, 'D');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       68
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,343 :: 		save_data('D');
	MOVLW       68
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,344 :: 		}
	GOTO        L_main65
L_main64:
;main.c,345 :: 		else if (cnt==2)
	MOVF        _cnt+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main66
;main.c,347 :: 		Lcd_Chr(1, COLM, 'E');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       69
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,348 :: 		save_data('E');
	MOVLW       69
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,349 :: 		}
	GOTO        L_main67
L_main66:
;main.c,350 :: 		else  if (cnt==3)
	MOVF        _cnt+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main68
;main.c,352 :: 		Lcd_Chr(1, COLM, 'F');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       70
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,353 :: 		save_data('F');
	MOVLW       70
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,354 :: 		}
	GOTO        L_main69
L_main68:
;main.c,355 :: 		else  if (cnt==4)
	MOVF        _cnt+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_main70
;main.c,357 :: 		Lcd_Chr(1, COLM, '3');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       51
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,358 :: 		save_data('3');
	MOVLW       51
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,359 :: 		}
L_main70:
L_main69:
L_main67:
L_main65:
;main.c,360 :: 		cnt++;
	INCF        _cnt+0, 1 
;main.c,361 :: 		}
L_main62:
;main.c,363 :: 		if (kp=='4')
	MOVF        _kp+0, 0 
	XORLW       52
	BTFSS       STATUS+0, 2 
	GOTO        L_main71
;main.c,365 :: 		chk();
	CALL        _chk+0, 0
;main.c,366 :: 		if (cnt==5)
	MOVF        _cnt+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_main72
;main.c,368 :: 		cnt=1;
	MOVLW       1
	MOVWF       _cnt+0 
;main.c,369 :: 		}
L_main72:
;main.c,370 :: 		if (cnt==1)
	MOVF        _cnt+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main73
;main.c,372 :: 		Lcd_Chr(1, COLM, 'G');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       71
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,373 :: 		save_data('G');
	MOVLW       71
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,374 :: 		}
	GOTO        L_main74
L_main73:
;main.c,375 :: 		else if (cnt==2)
	MOVF        _cnt+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main75
;main.c,377 :: 		Lcd_Chr(1, COLM, 'H');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       72
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,378 :: 		save_data('H');
	MOVLW       72
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,379 :: 		}
	GOTO        L_main76
L_main75:
;main.c,380 :: 		else  if (cnt==3)
	MOVF        _cnt+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main77
;main.c,382 :: 		Lcd_Chr(1, COLM, 'I');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       73
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,383 :: 		save_data('I');
	MOVLW       73
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,384 :: 		}
	GOTO        L_main78
L_main77:
;main.c,385 :: 		else  if (cnt==4)
	MOVF        _cnt+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_main79
;main.c,387 :: 		Lcd_Chr(1, COLM, '4');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       52
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,388 :: 		save_data('4');
	MOVLW       52
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,389 :: 		}
L_main79:
L_main78:
L_main76:
L_main74:
;main.c,390 :: 		cnt++;
	INCF        _cnt+0, 1 
;main.c,391 :: 		}
L_main71:
;main.c,393 :: 		if (kp=='5')
	MOVF        _kp+0, 0 
	XORLW       53
	BTFSS       STATUS+0, 2 
	GOTO        L_main80
;main.c,395 :: 		chk();
	CALL        _chk+0, 0
;main.c,396 :: 		if (cnt==5)
	MOVF        _cnt+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_main81
;main.c,398 :: 		cnt=1;
	MOVLW       1
	MOVWF       _cnt+0 
;main.c,399 :: 		}
L_main81:
;main.c,400 :: 		if (cnt==1)
	MOVF        _cnt+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main82
;main.c,402 :: 		Lcd_Chr(1, COLM, 'J');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       74
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,403 :: 		save_data('J');
	MOVLW       74
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,404 :: 		}
	GOTO        L_main83
L_main82:
;main.c,405 :: 		else if (cnt==2)
	MOVF        _cnt+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main84
;main.c,407 :: 		Lcd_Chr(1, COLM, 'K');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       75
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,408 :: 		save_data('K');
	MOVLW       75
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,409 :: 		}
	GOTO        L_main85
L_main84:
;main.c,410 :: 		else  if (cnt==3)
	MOVF        _cnt+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main86
;main.c,412 :: 		Lcd_Chr(1, COLM, 'L');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       76
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,413 :: 		save_data('L');
	MOVLW       76
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,414 :: 		}
	GOTO        L_main87
L_main86:
;main.c,415 :: 		else  if (cnt==4)
	MOVF        _cnt+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_main88
;main.c,417 :: 		Lcd_Chr(1, COLM, '5');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       53
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,418 :: 		save_data('5');
	MOVLW       53
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,419 :: 		}
L_main88:
L_main87:
L_main85:
L_main83:
;main.c,420 :: 		cnt++;
	INCF        _cnt+0, 1 
;main.c,421 :: 		}
L_main80:
;main.c,423 :: 		if (kp=='6')
	MOVF        _kp+0, 0 
	XORLW       54
	BTFSS       STATUS+0, 2 
	GOTO        L_main89
;main.c,425 :: 		chk();
	CALL        _chk+0, 0
;main.c,426 :: 		if (cnt==5)
	MOVF        _cnt+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_main90
;main.c,428 :: 		cnt=1;
	MOVLW       1
	MOVWF       _cnt+0 
;main.c,429 :: 		}
L_main90:
;main.c,430 :: 		if (cnt==1)
	MOVF        _cnt+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main91
;main.c,432 :: 		Lcd_Chr(1, COLM, 'M');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       77
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,433 :: 		save_data('M');
	MOVLW       77
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,434 :: 		}
	GOTO        L_main92
L_main91:
;main.c,435 :: 		else if (cnt==2)
	MOVF        _cnt+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main93
;main.c,437 :: 		Lcd_Chr(1, COLM, 'N');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       78
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,438 :: 		save_data('N');
	MOVLW       78
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,439 :: 		}
	GOTO        L_main94
L_main93:
;main.c,440 :: 		else  if (cnt==3)
	MOVF        _cnt+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main95
;main.c,442 :: 		Lcd_Chr(1, COLM, 'O');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       79
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,443 :: 		save_data('O');
	MOVLW       79
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,444 :: 		}
	GOTO        L_main96
L_main95:
;main.c,445 :: 		else  if (cnt==4)
	MOVF        _cnt+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_main97
;main.c,447 :: 		Lcd_Chr(1, COLM, '6');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       54
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,448 :: 		save_data('6');
	MOVLW       54
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,449 :: 		}
L_main97:
L_main96:
L_main94:
L_main92:
;main.c,450 :: 		cnt++;
	INCF        _cnt+0, 1 
;main.c,451 :: 		}
L_main89:
;main.c,453 :: 		if (kp=='7')
	MOVF        _kp+0, 0 
	XORLW       55
	BTFSS       STATUS+0, 2 
	GOTO        L_main98
;main.c,455 :: 		chk();
	CALL        _chk+0, 0
;main.c,456 :: 		if (cnt==6)
	MOVF        _cnt+0, 0 
	XORLW       6
	BTFSS       STATUS+0, 2 
	GOTO        L_main99
;main.c,458 :: 		cnt=1;
	MOVLW       1
	MOVWF       _cnt+0 
;main.c,459 :: 		}
L_main99:
;main.c,460 :: 		if (cnt==1)
	MOVF        _cnt+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main100
;main.c,462 :: 		Lcd_Chr(1, COLM, 'P');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       80
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,463 :: 		save_data('P');
	MOVLW       80
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,464 :: 		}
	GOTO        L_main101
L_main100:
;main.c,465 :: 		else if (cnt==2)
	MOVF        _cnt+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main102
;main.c,467 :: 		Lcd_Chr(1, COLM, 'Q');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       81
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,468 :: 		save_data('Q');
	MOVLW       81
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,469 :: 		}
	GOTO        L_main103
L_main102:
;main.c,470 :: 		else  if (cnt==3)
	MOVF        _cnt+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main104
;main.c,472 :: 		Lcd_Chr(1, COLM, 'R');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       82
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,473 :: 		save_data('R');
	MOVLW       82
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,474 :: 		}
	GOTO        L_main105
L_main104:
;main.c,475 :: 		else  if (cnt==4)
	MOVF        _cnt+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_main106
;main.c,477 :: 		Lcd_Chr(1, COLM, 'S');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       83
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,478 :: 		save_data('S');
	MOVLW       83
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,479 :: 		}
	GOTO        L_main107
L_main106:
;main.c,480 :: 		else  if (cnt==5)
	MOVF        _cnt+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_main108
;main.c,482 :: 		Lcd_Chr(1, COLM, '7');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       55
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,483 :: 		save_data('7');
	MOVLW       55
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,484 :: 		}
L_main108:
L_main107:
L_main105:
L_main103:
L_main101:
;main.c,485 :: 		cnt++;
	INCF        _cnt+0, 1 
;main.c,486 :: 		}
L_main98:
;main.c,488 :: 		if (kp=='8')
	MOVF        _kp+0, 0 
	XORLW       56
	BTFSS       STATUS+0, 2 
	GOTO        L_main109
;main.c,490 :: 		chk();
	CALL        _chk+0, 0
;main.c,491 :: 		if (cnt==5)
	MOVF        _cnt+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_main110
;main.c,493 :: 		cnt=1;
	MOVLW       1
	MOVWF       _cnt+0 
;main.c,494 :: 		}
L_main110:
;main.c,495 :: 		if (cnt==1)
	MOVF        _cnt+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main111
;main.c,497 :: 		Lcd_Chr(1, COLM, 'T');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       84
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,498 :: 		save_data('T');
	MOVLW       84
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,499 :: 		}
	GOTO        L_main112
L_main111:
;main.c,500 :: 		else if (cnt==2)
	MOVF        _cnt+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main113
;main.c,502 :: 		Lcd_Chr(1, COLM, 'U');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       85
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,503 :: 		save_data('U');
	MOVLW       85
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,504 :: 		}
	GOTO        L_main114
L_main113:
;main.c,505 :: 		else  if (cnt==3)
	MOVF        _cnt+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main115
;main.c,507 :: 		Lcd_Chr(1, COLM, 'V');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       86
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,508 :: 		save_data('V');
	MOVLW       86
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,509 :: 		}
	GOTO        L_main116
L_main115:
;main.c,510 :: 		else  if (cnt==4)
	MOVF        _cnt+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_main117
;main.c,512 :: 		Lcd_Chr(1, COLM, '8');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       56
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,513 :: 		save_data('8');
	MOVLW       56
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,514 :: 		}
L_main117:
L_main116:
L_main114:
L_main112:
;main.c,515 :: 		cnt++;
	INCF        _cnt+0, 1 
;main.c,516 :: 		}
L_main109:
;main.c,518 :: 		if (kp=='9')
	MOVF        _kp+0, 0 
	XORLW       57
	BTFSS       STATUS+0, 2 
	GOTO        L_main118
;main.c,520 :: 		chk();
	CALL        _chk+0, 0
;main.c,521 :: 		if (cnt==6)
	MOVF        _cnt+0, 0 
	XORLW       6
	BTFSS       STATUS+0, 2 
	GOTO        L_main119
;main.c,523 :: 		cnt=1;
	MOVLW       1
	MOVWF       _cnt+0 
;main.c,524 :: 		}
L_main119:
;main.c,525 :: 		if (cnt==1)
	MOVF        _cnt+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main120
;main.c,527 :: 		Lcd_Chr(1, COLM, 'W');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       87
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,528 :: 		save_data('W');
	MOVLW       87
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,529 :: 		}
	GOTO        L_main121
L_main120:
;main.c,530 :: 		else if (cnt==2)
	MOVF        _cnt+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main122
;main.c,532 :: 		Lcd_Chr(1, COLM, 'X');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       88
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,533 :: 		save_data('X');
	MOVLW       88
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,534 :: 		}
	GOTO        L_main123
L_main122:
;main.c,535 :: 		else  if (cnt==3)
	MOVF        _cnt+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main124
;main.c,537 :: 		Lcd_Chr(1, COLM, 'Y');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       89
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,538 :: 		save_data('Y');
	MOVLW       89
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,539 :: 		}
	GOTO        L_main125
L_main124:
;main.c,540 :: 		else  if (cnt==4)
	MOVF        _cnt+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_main126
;main.c,542 :: 		Lcd_Chr(1, COLM, 'Z');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       90
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,543 :: 		save_data('Z');
	MOVLW       90
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,544 :: 		}
	GOTO        L_main127
L_main126:
;main.c,545 :: 		else  if (cnt==5)
	MOVF        _cnt+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_main128
;main.c,547 :: 		Lcd_Chr(1, COLM, '9');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       57
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,548 :: 		save_data('9');
	MOVLW       57
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,549 :: 		}
L_main128:
L_main127:
L_main125:
L_main123:
L_main121:
;main.c,550 :: 		cnt++;
	INCF        _cnt+0, 1 
;main.c,551 :: 		}
L_main118:
;main.c,553 :: 		if (kp=='0')
	MOVF        _kp+0, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_main129
;main.c,555 :: 		chk();
	CALL        _chk+0, 0
;main.c,556 :: 		if (cnt==3)
	MOVF        _cnt+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_main130
;main.c,558 :: 		cnt=1;
	MOVLW       1
	MOVWF       _cnt+0 
;main.c,559 :: 		}
L_main130:
;main.c,560 :: 		if (cnt==1)
	MOVF        _cnt+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_main131
;main.c,562 :: 		Lcd_Chr(1, COLM, '0');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       48
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,563 :: 		save_data('0');
	MOVLW       48
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,564 :: 		}
	GOTO        L_main132
L_main131:
;main.c,565 :: 		else if (cnt==2)
	MOVF        _cnt+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_main133
;main.c,567 :: 		Lcd_Chr(1, COLM,' ');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       32
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;main.c,568 :: 		save_data(' ');
	MOVLW       32
	MOVWF       FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,569 :: 		}
L_main133:
L_main132:
;main.c,570 :: 		cnt++;
	INCF        _cnt+0, 1 
;main.c,571 :: 		}
L_main129:
;main.c,572 :: 		if (kp=='C')
	MOVF        _kp+0, 0 
	XORLW       67
	BTFSS       STATUS+0, 2 
	GOTO        L_main134
;main.c,574 :: 		if (COLM!=0)
	MOVF        _COLM+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main135
;main.c,576 :: 		cr_shift_left();
	CALL        _cr_shift_left+0, 0
;main.c,577 :: 		Lcd_Chr(1, COLM--, ' ');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        _COLM+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       32
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
	DECF        _COLM+0, 1 
;main.c,578 :: 		cr_shift_left();
	CALL        _cr_shift_left+0, 0
;main.c,579 :: 		cnt=1;
	MOVLW       1
	MOVWF       _cnt+0 
;main.c,580 :: 		oldstate=kp;
	MOVF        _kp+0, 0 
	MOVWF       _oldstate+0 
;main.c,581 :: 		COLM++;
	INCF        _COLM+0, 1 
;main.c,582 :: 		save_data(0);
	CLRF        FARG_save_data_charter+0 
	CALL        _save_data+0, 0
;main.c,583 :: 		COLM--;
	DECF        _COLM+0, 1 
;main.c,584 :: 		}
L_main135:
;main.c,585 :: 		}
L_main134:
;main.c,587 :: 		if (cnt == 255)
	MOVF        _cnt+0, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_main136
;main.c,589 :: 		cnt = 0;
	CLRF        _cnt+0 
;main.c,591 :: 		}
L_main136:
;main.c,594 :: 		} while (1);
	GOTO        L_main3
;main.c,595 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;main.c,599 :: 		void interrupt()
;main.c,601 :: 		if (INTCON.TMR0IF==1)
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt137
;main.c,604 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;main.c,605 :: 		TMR0H = 0xB;
	MOVLW       11
	MOVWF       TMR0H+0 
;main.c,606 :: 		TMR0L = 0xDC;
	MOVLW       220
	MOVWF       TMR0L+0 
;main.c,607 :: 		exit=1;
	MOVLW       1
	MOVWF       _exit+0 
;main.c,608 :: 		}
L_interrupt137:
;main.c,609 :: 		}
L_end_interrupt:
L__interrupt147:
	RETFIE      1
; end of _interrupt
