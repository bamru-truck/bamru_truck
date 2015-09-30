-- Rpi Power board

Version 0.1 features:

 - onboard battery support for remote operation
 - ADC (voltage monitor) for incoming voltage and onboard battery. 
 - Ignition detection support
 - Mosfet cutoffs for disconnecting battery and power when battery voltages get low
 - onboard temp monitor
 - onboard RTC support
 - pass through usb connector for powering off cell router
 - Onboard rgb led for use as status indicator. 
 - Unfortunate high current draw at power off (~10 ma). Not green at all, and a concern if the truck is going to go unpowered for many weeks or months. Can run a full car battery dead in 9 months, or make for a slower start after 2 months. 

Possible version 1.0 features:
 - Onboard moisture/humidity sensor
 - onboard gps sensor (not USB)
 - Lower current draw at power off. Shooting for no more than 1 ma.

