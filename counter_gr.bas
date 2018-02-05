!!
This program demonstrates using
Bluetooth.

Before running this program use
the Android "Settings" application
to enable Bluetooth and to pair
with the device(s) that you will
talk to.

Note: The UUID used by default is
the standard serial port UUID. This
can be changed. Read the manual.

!!

! Begin by opening Bluetooth
! If Bluetooth is not enabled
! the program will stop here.

BT.OPEN

! When BT is opened, the program
! will start listening for another
! device to connect. At this time
! the user can continue to wait
! for a connection are can attempt
! to connect to another device
! that is waiting for a connection

! Ask user what to do

ARRAY.LOAD type$[], "Connect to Bluetooth", "Quit"
title$ = "Select operation mode"

new_connection:
DIALOG.SELECT type, type$[], title$

! If the user pressed the back
! key or selected quit then quit
! otherwise try to connect to
! a listener

IF (type = 0) | (type =2)
 PRINT "Thanks for playing"
 BT.CLOSE
 END
ELSEIF type = 1
 BT.CONNECT
ENDIF

! Read status until
! a connection is made

ln = 0
DO
 BT.STATUS s
 IF s = 1
  ln = ln + 1
  PRINT "Listening", ln
 ELSEIF s =2
  PRINT "Connecting"
 ELSEIF s = 3
  PRINT "Connected"
  !PRINT "Touch any text line to disconnect or quit."
  !TONE 400,100
 ENDIF
 PAUSE 1000

UNTIL s = 3

! When a connection is made
! get the name of the connected
! device

BT.DEVICE.NAME device$

GR.OPEN 255, 255, 255, 255
GR.ORIENTATION 0
GR.SCREEN w,h

! *** Read Loop ****

RW_Loop:
Console.title "FREQUENCY COUNTER"
DO

 ! Read status to insure
 ! that we remain connected.
 ! If disconnected, program
 ! reverts to listen mode.
 ! In that case, ask user
 ! what to do.

 BT.STATUS s
 IF s<> 3
  PRINT "Connection lost"
  GOTO new_connection
 ENDIF

 ! Read messages until
 ! the message queue is
 ! empty
 
 DO
  BT.READ.READY rr
  IF rr
  BT.READ.BYTES rmsg$
  IF LEN(rmsg$)=5
  Cls
  volt$ = FORMAT$("###%.###",((ASCII(rmsg$)*256 + ASCII(rmsg$,2))*5 / 1024))
  freq$ = FORMAT$("##,###,##%",(ASCII(rmsg$,3)*65658 + ASCII(rmsg$,4)*255 + ASCII(rmsg$,5)))
  !Popup "FREQUENCY: "+freq$+" Hz\nVOLTAGE: "+volt$+" V",,,1	% 4 sec popup
  
  ENDIF
  ENDIF
 UNTIL rr = 0

GR.COLOR 255, 0, 0, 255, 1
!GR.TEXT.ALIGN 2
GR.TEXT.SIZE h/4 
GR.TEXT.BOLD 1
GR.TEXT.DRAW F, 0, h*0.35, freq$ + " Hz"

GR.COLOR 255, 255, 0, 0, 1
GR.TEXT.DRAW V, 0, h*0.75, volt$ + " V"

 GR.RENDER
 PAUSE 2000
 GR.HIDE V
 GR.HIDE F
 GR.RENDER

UNTIL 0
!PAUSE 1000

onError:
END
