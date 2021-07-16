'MMEDIT!!! Basic Version = CMM2
'MMEDIT!!! Port = COM13:115200:10,300
'MMEDIT!!! Device = CMM2
  SETPIN 31, DOUT 'set pin 31 to latch the chip
  SPI OPEN 195315, 0, 8 'mode 0, data size is 16 bits
  
  shiftno = 4 'number of shift registers(each card has 2 shift registers)
  
  DIM tosend(shiftno)
  DIM cnt = 1
  DIM cnt2 = 0
  
  
SUB ShiftSend c
  PIN(31) = 0
  For i=c-1 to 0 STEP -1
    junk = SPI(tosend(i)) ' send the command and ignore the return
    PRINT tosend(i)
  NEXT i
  PIN(31) = 1
END SUB
  
  
SUB ShiftArray c
  
  if tosend(cnt2)<16 THEN ' send 5 bit
    tosend(cnt2)=tosend(cnt2)<<1
  ELSE
    cnt=1
    tosend(cnt2)=0
    cnt2=cnt2+1
    IF cnt2 > shiftno-1 THEN cnt2 = 0
    tosend(cnt2)=1 'seed next value in array
  END IF
  
END SUB

SUB SendToCards
  PIN(31) = 0 'set low latching pin
  junk = SPI(CARD1)
  junk = SPI(CARD2)
  junk = SPI(CARD3)
  junk = SPI(CARD4)
  PIN(31) = 1 'set latching pin high to turn on register output
END SUB
  
tosend(cnt2)=1 'iniciate array with value to shift

  Do
    
    for j=0 to 5
      ShiftArray(cnt2)
      ShiftSend(shiftno)
      PAUSE 100
      'PRINT"!!!!!! " j
    NEXT j
    
    PRINT"BOMB!"
    CARD1 = &B00000
    CARD2 = &B00000
    CARD3 = &B00000
    CARD4 = &B00000

    SendToCards
    PAUSE 500
    
    CARD1 = &B00000
    CARD2 = &B00000
    CARD3 = &B01000
    CARD4 = &B00000

    SendToCards
    PAUSE 500
    
    CARD1 = &B00000
    CARD2 = &B01100
    CARD3 = &B01100
    CARD4 = &B00000
    
    SendToCards
    PAUSE 500    
    
    CARD1 = &B11111
    CARD2 = &B11111
    CARD3 = &B11111
    CARD4 = &B11111    

    SendToCards
    PAUSE 500

    CARD1 = &B11111
    CARD2 = &B10011
    CARD3 = &B10011
    CARD4 = &B11111    

    SendToCards
    PAUSE 500

    CARD1 = &B00000
    CARD2 = &B00000
    CARD3 = &B00000
    CARD4 = &B00000
  
    SendToCards
    PAUSE 500
  
  Loop
  
  SPI CLOSE