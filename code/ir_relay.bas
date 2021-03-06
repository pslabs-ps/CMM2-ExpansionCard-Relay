'MMEDIT!!! Basic Version = CMM2
'MMEDIT!!! Port = COM5:115200:10,300
'MMEDIT!!! Device = CMM2
  SETPIN 31, DOUT 'set pin 31 to latch the chip
  SPI OPEN 195315, 0, 8 'mode 0, data size is 8 bits
  
  IR dev, KeyCode, IR_Int
  
  shiftno = 4 'number of shift registers(each card has 1 or 2 shift registers)
  modeselect = 0
  
  DIM tosend(shiftno-1) 'TO TERAZ DODALEM
  DIM CardNo
  DIM RelayNo
  
  
  
  
  
  
  'procedure to send array via SPI to relay cards
SUB ShiftSend c
  PIN(31) = 0
  For i=c-1 to 0 STEP -1
    junk = SPI(tosend(i)) ' send the command and ignore the return
    'PRINT tosend(i)
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
  if kcode = 8   then KeyC = 0 'ZERO will be used to operated all cards / all relays
  
end function
  
  
  
  'PrintArray
  'SetArrayTo(1)
  'PrintArray
  'ShiftSend(shiftno)
  
  CLS
  Print "This example code allows to operate relay cards with IR remote control"
  PRINT ""
  Print "Make sure that 'shiftno' variable is set correctly. Currently shiftno is:" shiftno " .This lets You control:"
  PRINT shiftno "x Relay Cards (5 relays on card) or " shiftno/2 "x Large Relay Cards (8 relays on card)"
  PRINT ""
  Print "Make sure that key codes are maching Your remote"
  Print ""
  PRINT "Keys from 1 to 9 are used to operate relays"
  Print "First key press (1 to number of cards) select the card You want to operate. 2nd key press will turn OFF or ON relay coresponding to pressed number"
  PRINT "If first key press is 0 You are entering mode that controls all relays on all cards. If 2nd key press is 0 all relays on all cards will be turned OFF, If 2nd key press is 1 all relays on all cards will be turned ON."
  PRINT ""
  PRINT "Example:"
  PRINT " --------------------------------------------------------"
  PRINT "| Key press |                 Function                   |"
  PRINT " --------------------------------------------------------"
  PRINT "|   1, 3    | Relay 3 on card 1 will change state        |"
  PRINT "|   2, 5    | Relay 5 on card 2 will change state        |"
  PRINT "|   0, 0    | All relays on all cards will be turned OFF |"
  PRINT "|   0, 1    | All relays on all cards will be turned ON  |"
  PRINT " --------------------------------------------------------"
  PRINT ""
  PRINT ""
  PRINT "Waiting for Your first key press on remote:"
  
  
  Do
    'ShiftSend(shiftno)
  LOOP
  
SUB IR_Int
  
  KeyPress = Keyc(KeyCode)
  PRINT "Received device = " DevCode "  key = " KeyCode " number on remote = " KeyPress

  
  'modes:
  '0 - first selection
  '1
  '2 - controll multiple relays
  SELECT CASE modeselect
    CASE 0 'card select mode
      PRINT "case 0"
      IF KeyPress = 0 THEN modeselect = 2
      IF KeyPress > 0 THEN
        modeselect = 1
        CardNo = KeyPress-1
      ENDIF  
    
    CASE 1 'relay select mode
      PRINT "case 1"
      PRINT RelayNo
      PRINT CardNo
      RelayNo = KeyPress-1
      'Print "wartosc przed: " tosend(CardNo)
      tosend(CardNo) = BitToggle(tosend(CardNo),RelayNo)
      'Print "wartosc po: " tosend(CardNo)
      
      shiftsend(shiftno) 'send valuers to SPI
      modeselect = 0
      
    CASE 2 'multiple relay contoll
      PRINT "case 2"
      SetArrayTo(KeyPress)
      shiftsend(shiftno)
      modeselect = 0
      
  END SELECT
  
    
END SUB