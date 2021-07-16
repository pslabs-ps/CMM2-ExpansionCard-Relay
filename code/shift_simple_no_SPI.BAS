'MMEDIT!!! Basic Version = CMM2
'MMEDIT!!! Port = COM13:115200:10,300
'MMEDIT!!! Device = CMM2
SETPIN 3, DOUT  'Relay 1 pin
SETPIN 7, DOUT  'Relay 2 pin
SETPIN 10, DOUT 'Relay 3 pin
SETPIN 12, DOUT 'Relay 4 pin
SETPIN 15, DOUT 'Relay 5 pin


  'turn ON all relays
  PIN(3) = 1
  PIN(7) = 1
  PIN(10) = 1
  PIN(12) = 1
  PIN(15) = 1
  
  PAUSE(1000)
  
  'turn OFF all relays
  PIN(3) = 0
  PIN(7) = 0
  PIN(10) = 0
  PIN(12) = 0
  PIN(15) = 0
  