#!/usr/bin/python
# battery idk ignition main-in
# 2.45400000 0.58000000 0.00000000 3.03400000

import time, signal, sys
from Adafruit_ADS1x15 import ADS1x15

def signal_handler(signal, frame):
        #print 'You pressed Ctrl+C!'
        sys.exit(0)
signal.signal(signal.SIGINT, signal_handler)
#print 'Press Ctrl+C to exit'

ADS1015 = 0x00	# 12-bit ADC
ADS1115 = 0x01	# 16-bit ADC

# Initialise the ADC using the default mode (use default I2C address)
# Set this to ADS1015 or ADS1115 depending on the ADC you are using!
adc = ADS1x15(ic=ADS1115)

# Read channels 2 and 3 in single-ended mode, at +/-4.096V and 250sps
volts0 = adc.readADCSingleEnded(0, 4096, 250)/1000.0
volts1 = adc.readADCSingleEnded(1, 4096, 250)/1000.0
volts2 = adc.readADCSingleEnded(2, 4096, 250)/1000.0
volts3 = adc.readADCSingleEnded(3, 4096, 250)/1000.0

# Now do a differential reading of channels 2 and 3
#voltsdiff = adc.readADCDifferential23(4096, 250)/1000.0

inputv = volts3 * 4.37
ignitionv = volts2 * 4.929039301
battv = volts0 * 1.656

# Display the two different reading for comparison purposes
print "Li+, Volts In, Ignition V"
print "%.3f %.3f %.3f" % (battv, inputv, ignitionv)
#print "%.8f %.8f %.8f %.8f" % (volts0, volts1, ignitionv, inputv)
