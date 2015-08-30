#!/bin/python
import serial
import time
import sys, getopt

def main(argv):
   ttydev = 'none'
   outputfile = ''
   try:
      opts, args = getopt.getopt(argv,"ht:o:",["tty=","ofile="])
   except getopt.GetoptError:
      print 'reset-rpi-serial.py -t <tty>'
      print "Example: reset-rpi-serial.py -t /dev/ttyUSB0"
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print 'test.py -i <inputfile> -o <outputfile>'
         sys.exit()
      elif opt in ("-t", "--tty"):
         ttydev = arg
      elif opt in ("-o", "--ofile"):
         outputfile = arg
   if ttydev == 'none':
      print 'Please enter a tty with the -t switch'
      sys.exit(1)
 
   print 'tty is "', ttydev
   port = ttydev 
   ser = serial.Serial(ttydev, 9600, timeout=1)
   ser.xonxof = 0
   ser.dsrdtr = 0
   ser.rtscts = 0

   time.sleep(2) # Sleep for 2 seconds waiting for hello messages.
   ser.write('c1')
   sys.exit(0)

if __name__ == "__main__":
   main(sys.argv[1:])

