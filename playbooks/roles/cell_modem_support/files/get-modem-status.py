import serial
import time
from time import sleep
from datetime import datetime
import os

port = "/dev/ttyUSB0"

ser = serial.Serial(port,  # Device name varies
                     baudrate=115200,
                     bytesize=8,
                     parity='N',
                     stopbits=1,
                     timeout=2)
counter = 0

# First, see if a modem is on the port to be used.
ser.write('AT\r')
resp = ser.readline()
resp = ser.readline()
#resp = ser.read(2)
#print resp
if 'OK' in resp:
    print ('Modem detected on ', port)
else:
    print ('ERROR, AT finds no modem on ', port)
    print resp
    exit(1)

def get_ati():
	print "Getting ATI"
	ser.write('ATI\r')
	resp = ser.read(300)
	print resp

get_ati()
	
def check_provider_lock():
	ser.write('AT+CPIN?\r')
	resp = ser.readline()
	resp = ser.readline()
	if 'READY' in resp:
		print ('Modem appears to be functional and not provider locked\n')
	else:
		print ('ERROR! Modem appears to be provider locked. CPIN querry was', resp, '\r')
		print ('See <a href=https://wiki.ubuntu.com/SierraMC8775>https://wiki.ubuntu.com/SierraMC8775</a> for additional info.\n')

check_provider_lock()

ser.close()
exit(0)
