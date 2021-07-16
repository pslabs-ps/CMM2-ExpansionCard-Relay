# CMM2-ExpansionCard-Relay

<img src="Images/card_fut.png" width="800">
<br>

Schematic can be found here: [schematic REV A v02](/Schematic/relay_revA_v03.pdf)

Expansion system and cards can be purchased here: [PS Labs](https://sklep.pslabs.pl/Maximite-c91)

<br>
<br>
<br>

# Power source setup
Below You can find possible power source setup. Use only 2 jumpers!
<img src="Images/pow_sel.png" width="800">

<br>
<br>
<br>

# Single card setup - no SPI
In this mode maximite pins are used to activate relays. Using jumper wires connect pins with relay inputs as shown below:
<img src="Images/simple_con.png" width="800">

## Code example:

```basic
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
```

<br>
<br>
<br>

# Single card setup in SPI mode
Set up a card as shown below:
<img src="Images/single_spi.png" width="800">

```basic
SETPIN 31, DOUT 'set pin 31 to latch the shift register chip
SPI OPEN 195315, 0, 8 'mode 0, data size is 8 bits
  
  
  'set valuses for each card to be send
  CARD1 = &B11111111



  PIN(31) = 0 'set low latching pin
  
  
  'send values via SPI
  junk = SPI(CARD1)

  
  PIN(31) = 1 'set latching pin high to turn on register output
  
SPI CLOSE
```

<br>
<br>
<br>
 
# Multiple card in SPI mode setup
Below You can find example of 4 card daisy chained operated by SPI interface:
<img src="Images/multiple_cards.png" width="800">
 
Explanation:
 
All cards are using power taken from Maximite (red jumpers), realys are connected with A,B,C,D,E outputs of shift register card (red jumpers)
 
## CARD 1:
 1. SPI 1 is used so MOSI port is set to 19 (green jumper) and SCK port is set to 23 (yellow jumper)
 2. Pin 31 is used to latch shift register chip (blue jumper)
 3. Overflowed shift register data (QH) are send to x1 data line (pink jumper), this will be used as MOSI on next card
 
## CARD 2:
 1. Overflowed QH signal is used as MOSI now, this signal is taken from x1 data line (green jumper), SCK remains unchanged (set to pin 23 - yellow jumper)
 2. Pin 31 is used to latch shift register chip (blue jumper)
 3. Overflowed shift register data (QH) are send to x2 data line (pink jumper), this will be used as MOSI on next card
 
## CARD 3:
 1. Overflowed QH signal is used as MOSI now, this signal is taken from x2 data line (green jumper), SCK remains unchanged (set to pin 23 - yellow jumper)
 2. Pin 31 is used to latch shift register chip (blue jumper)
 3. Overflowed shift register data (QH) are send to x3 data line (pink jumper), this will be used as MOSI on next card
 
## CARD 4:
 1. Overflowed QH signal is used as MOSI now, this signal is taken from x3 data line (green jumper), SCK remains unchanged (set to pin 23 - yellow jumper)
 2. Pin 31 is used to latch shift register chip (blue jumper)
 3. Since this is last card Overflowed shift register data (QH) are not needed any longer. If You need to conect another card You cand send it for example to x4 data line
 
## Code example 1:
 ```basic
 SETPIN 31, DOUT 'set pin 31 to latch the shift register chip
SPI OPEN 195315, 0, 8 'mode 0, data size is 16 bits
  
  
  'set valuses for each card to be send
  CARD1 = &B01010
  CARD2 = &B10101
  CARD3 = &B10101
  CARD4 = &B10101


  PIN(31) = 0 'set low latching pin
  
  'send values via SPI
  junk = SPI(CARD1)
  junk = SPI(CARD2)
  junk = SPI(CARD3)
  junk = SPI(CARD4)
  
  PIN(31) = 1 'set latching pin high to turn on register output
	
SPI CLOSE
 ```
 
## Code Example 2:
 ```basic
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
  
tosend(cnt2)=1 'iniciate array with value to shift

  Do
    
    ShiftArray(cnt2)
    ShiftSend(shiftno)
    PAUSE 100
  
  Loop
  
  SPI CLOSE
 ```
 
 