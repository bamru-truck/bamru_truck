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


-- Version 0.1 produced board details
The board has the following features
 - 12v to 4.2 volt step down to charge battery (MPM80)
 - li+ to 5 volt dc to dc (ebay special)
 - can power RPi off of LI+ cell
 - onboard temp monitor LM75b
 - onboard RTC DS1340(DS1370 compatable)
 - onboard adc ads1013


Parts list:
| Part | MPN | link
R3 | 2.2k 0603 | none
R4 | 2.2k 0603 | none
R5 | 20k 0603 | none
R6 | 10k 0603 | none
R7 | 4125 ohm 0603 | http://www.digikey.com/product-detail/en/RR0816P-4121-D-60H/RR08P4.12KDCT-ND/1288210
R8 | 1k 0603 | none
R9 | 5.5k 0603 | none
R10 | 10k 0603 | none
R11 | 30K 0603 | none
R12 | 20k 0603 | none
R13 | 5.5k 0604 | none
RTC | DS1340 | http://www.digikey.com/product-detail/en/DS1340Z-33%2BT%26R/DS1340Z-33%2BT%26RCT-ND/3647911
TEMP | LM75b | http://www.digikey.com/product-detail/en/LM75BD,118/568-4688-1-ND/1993025
ADC | 12-bit ADC | https://www.digikey.com/product-detail/en/ADS1015IDGST/296-25227-1-ND/2174997
PTC | Input protection PTC | http://www.digikey.com/scripts/DkSearch/dksus.dll?Detail&itemSeq=181553660
step-down | 5-15 to 4.2 V | http://www.digikey.com/scripts/DkSearch/dksus.dll?Detail&itemSeq=181553821
Diode | Input diode | http://www.digikey.com/scripts/DkSearch/dksus.dll?Detail&itemSeq=181553817
crystal | RTC crystal | http://www.digikey.com/product-detail/en/AB38T-32.768KHZ/535-9034-ND/675229
RTC cap | supercap for RTC | http://www.digikey.com/product-detail/en/DCK-3R3E224U-E/604-1007-ND/970168

-- I needed to build new modules for this board. 

To do this I did the following steps:
 - upgrade gcc https://somewideopenspace.wordpress.com/2014/02/28/gcc-4-8-on-raspberry-pi-wheezy/
 - did a yum update
 - yum upgrade
 - reboot
 - rpi-update
 - reboot
 - Pulled current kernel source with https://github.com/notro/rpi-source/wiki
 - Specifically: sudo wget https://raw.githubusercontent.com/notro/rpi-source/master/rpi-source -O /usr/bin/rpi-source && sudo chmod +x /usr/bin/rpi-source && /usr/bin/rpi-source -q --tag-update
 

