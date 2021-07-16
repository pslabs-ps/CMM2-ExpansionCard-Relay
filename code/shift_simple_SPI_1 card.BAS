'MMEDIT!!! Basic Version = CMM2
'MMEDIT!!! Port = COM13:115200:10,300
'MMEDIT!!! Device = CMM2
'MMEDIT!!! Device = CMM2
SETPIN 31, DOUT 'set pin 31 to latch the shift register chip
SPI OPEN 195315, 0, 8 'mode 0, data size is 8 bits
  
  
  'set valuses for each card to be send
  CARD1 = &B11111111



  PIN(31) = 0 'set low latching pin
  
  
  'send values via SPI
  junk = SPI(CARD1)

  
  PIN(31) = 1 'set latching pin high to turn on register output
  
SPI CLOSE
