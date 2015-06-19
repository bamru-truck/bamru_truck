#!/usr/bin/python
import serial
import time
from time import sleep
from datetime import datetime
import os
import sys, getopt

port = "/dev/ttyUSB1"

html=0

ser = serial.Serial(port,  # Device name varies
                     baudrate=115200,
                     bytesize=8,
                     parity='N',
                     stopbits=1,
                     timeout=2)
counter = 0

def get_ati():
    ser.write('ATI\r')
    resp = ser.read(300)
    if html:
        print "<tr><td>Modem model info</td><td><good>Good</good></td><td>", resp, "</td></tr>\r" 
    else:
        print "Getting modem data"
        print resp
   
def check_provider_lock():
    ser.write('AT+CPIN?\r')
    resp = ser.readline()
    resp = ser.readline()
    if 'READY' in resp:
        if html:
            print "<tr><td>Probider lock</td><td></td><td><good>Not Locked<good></td></tr>\r" 
        else:
            print ('Modem appears to be functional and not provider locked\n')
    else:
        if html:
            print "<tr><td>Probider lock</td><td></td><td><bad>Error!<bad>\r" 
        else:
            print ('ERROR! Modem appears to be provider locked. CPIN querry was', resp, '\r')
        print ('See <a href=https:wiki.ubuntu.comSierraMC8775>https:wiki.ubuntu.comSierraMC8775</a> for additional info.</td></tr>\r')

def output():
    # First, see if a modem is on the port to be used.
    ser.write('AT\r')
    resp = ser.readline()
    resp = ser.readline()
    #resp = ser.read(2)
    #print resp
    if 'OK' in resp:
        if html:
            print ('<a>Modem Detected on ', port)
        else:
            print ('Modem detected on ', port)
    else:
        print ('ERROR, AT finds no modem on ', port)
        print resp
        exit(1)
    if html:
        print "good {background-color: #00ff00;}\r"
        print "bad {background-color: rgb(255,0,0);}\r"
        print "<table>\r"
        print "<tr><td>Item</td><td>Result</td><td>extended</td></tr>\r"
    check_provider_lock()
    get_ati()
    if html:
        print "</table>\r"
    ser.close()

def main(argv):
    inputfile = ''
    outputfile = ''
    try:
        opts, args = getopt.getopt(argv,"hct::",["cli","html"])
    except getopt.GetoptError:
        print 'get-modem-status.py -h --cli --html'
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print 'test.py --cli --html'
            sys.exit()
        elif opt in ("-c", "--cli"):
            html=0
        elif opt in ("-t", "--html"):
            global html
            html=1
    output()

if __name__ == "__main__":
       main(sys.argv[1:])

exit(0)
