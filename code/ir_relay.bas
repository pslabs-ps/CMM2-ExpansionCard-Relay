'MMEDIT!!! Basic Version = CMM2
'MMEDIT!!! Port = COM13:115200:10,300
'MMEDIT!!! Device = CMM2
  SETPIN 31, DOUT 'set pin 31 to latch the chip
  SPI OPEN 195315, 0, 8 'mode 0, data size is 16 bits
  
  IR dev, KeyCode, IR_Int
  
  shiftno = 4 'number of shift registers(each card has 1 or 2 shift registers)
  skey=0
  
  DIM tosend(shiftno-1) 'TO TERAZ DODALEM
  DIM CardNo
  DIM RelayNo
  
  
  
  
  
  
'procedure to send array via SPI to relay cards
SUB ShiftSend c
  PIN(31) = 0
  For i=c-1 to 0 STEP -1
    junk = SPI(tosend(i)) ' send the command and ignore the return
    PRINT tosend(i)
  NEXT i
  PIN(31) = 1
END SUB
  
'Function to toggle bit in number  
function BitToggle(Bits,BitNo)
  'testb = &B11111111
  Mask = 1<< BitNo
  BitToggle = Bits XOR Mask
end function


'function to set all bits in array to 0 or 1
SUB SetArrayTo c
  IF c = 0 THEN
  ENdIF
  
  IF c=1 THEN
  ENDIF
  
  FOR i=0 to shiftno-1
    IF c = 0 THEN tosend(i)=0 'fill with 0000 0000
    IF c = 1 THEN tosend(i)=255 'fill with 1111 1111
  next i
END SUB

SUB PrintArray
  FOR i=0 to shiftno-1
    PRINT "[" i " ] " tosend(i)
  NEXT i
END SUB
  
  
  
  
  
FUNCTION KeyC (kcode)
  'This are keycodes of my remote, change it to adapt with Your remote
  '1-136
  '2-72
  '3-200
  '4-40
  '5-168
  '6-104
  '7-232
  '8-24
  '9-152
  '0-8
  if kcode = 136 then KeyC = 1
  if kcode = 72  then KeyC = 2
  if kcode = 200 then KeyC = 3
  if kcode = 40  then KeyC = 4
  if kcode = 168 then KeyC = 5
  if kcode = 104 then KeyC = 6
  if kcode = 232 then KeyC = 7
  if kcode = 24  then KeyC = 8
  if kcode = 152 then KeyC = 9
  if kcode = 8   then KeyC = 10 'ZERO will be used to operated all cards / all relays
  
end function
  
 

  PrintArray
  SetArrayTo(1)
  PrintArray
  ShiftSend(shiftno)
  
  Do
    'ShiftSend(shiftno)
  LOOP
  
SUB IR_Int
  
  PRINT "Received device = " DevCode "  key = " KeyCode
  
  IF KeyC(KeyCode) <> 0 AND KeyC(KeyCode) < shiftno Then
    Print "This is number " KeyC(KeyCode) "on Your remote"
    
    IF skey=0 then 'check if this is the first key pressed, if yes this is card no. selection
      skey=1 'set to 0, next key will be the relay key
      CardNo = KeyC(KeyCode) 'save the key press to CarNo value
      IF CardNo = 0 THEN PRINT "All cards selected, press 0 to turn OFF all relays, 1 to turn ON all relays" 'if the card 0 was selected we operate all cards and relays
      ELSE PRINT "Card no. " CardNo "has been selected, enter relay no." 'only selected card will be operated
    else
      RelayNo = KeyC(KeyCode) 'save value of selected relay
      IF RelayNo < 9 and RelayNo > 0 THEN 'maximum relays on vard is 8, 0 is different mode (all cards select)
        BitToggle(tosend[CardNo-1,RelayNo]) 'toggle the relay bit in array
        shiftsend(shiftno) 'send valuers to SPI
      endif
      IF RelayNo = 0 THEN 'this is to operate all relays
        SetArrayTo(CardNo) 'change values in array to 0 or 255
        shiftsend(shiftno) 'send valuers to SPI
        skey=0 'we go back to card selection mode
      ENDIF      
      
    ELSE Print "This is unknown key or card out of range"
    ENDIF
    
    
END SUB
    
