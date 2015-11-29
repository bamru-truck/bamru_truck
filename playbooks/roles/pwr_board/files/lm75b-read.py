#!/usr/bin/python
# Read a LM75B
# This example uses a LM75B temperature sensor connected to a Raspberry Pi.
# Data sheet http://www.nxp.com/documents/data_sheet/LM75B.pdf
# This example assumes that the address of the sensor is 0x4f
# The adress can change depending on the state of what pins 5 through 7 are connected to.
# Coded by Michael Gregg mgregg@cinchcircuits.com
# Shared under LGPL 3 license.

# In this configuration The LM75B's pins 5, 6, and 7 are all connected to VCC.
# SDA is connected to the RPi header GPIO2(RPi SDA), SCL is conected GPIO3(RPi SCL)
# To enable i2c on the RPi. please see this page. 
#	https://learn.adafruit.com/adafruits-raspberry-pi-lesson-4-gpio-setup/configuring-i2c

# In short, run the following:
#    sudo apt-get install python-smbus i2c-tools
# Place this at the end of /etc/modules
#    i2c-bcm2708 
#    i2c-dev
# Then reboot. 
# After reboot, you can verify that the LM75B is hooked to your system by running "i2cdetect -y 0"
# You will get a output with a value in the addess item assoiated with the address you selected.
# Like this for address 0x4f:
# 40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 4f

import smbus
import time

debug = 0

bus = smbus.SMBus(1)

address = 0x49

# Invert int 
def invert_int(n):
    number_bit_len = n.bit_length()
    max_val = (2 ** number_bit_len) - 1
    return ~n & max_val

def rtemp():
	datain = bus.read_word_data(address, 0x00) # Read the temp register to datain 
	if debug == 1:
		print bin(datain) # Optional debug to see that it happened. 
	lsb = datain >> 8 # Get the LSB by moving the data input right 8 bits
	msb = datain & 0xff # Seperate the MSB off of the input data input
	msb = msb << 8 # Move the MSB to the left 8 bits
	temp = msb + lsb # Add the MSB and the LSB together
	temp = temp >> 5
	if debug == 1:
		print bin(temp) # Debug
	if temp & 0x400: # If the 11th bit is a 1, it's a negative number. 
		temp = invert_int(temp) # It's in two's compliment, this line and the next convert to decimal.
		temp = temp + 1 
		neg = 1
	else:
		neg = 0
	temp = temp / 10.0 # Divide by 10 to make a temperature out of the data.
	if neg == 1:
		if debug == 1:
			print "Negative value"
		temp = temp * -1 # If the value is negative, multiply the value by -1
	return temp # Return the temp

foo= rtemp()
#print foo, u"\u00b0" # Print with degree symbol
#print foo, u"\u2103" # Print with degree C symbol
print foo # Print temp without symbol


