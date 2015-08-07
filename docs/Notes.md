# BAMRU TRUCK WIFI HOTSPOT / HACKING NOTES

View the [README](../README.md)

Github Repo: `https://github.com/cinchcircuits/bamru_truck.git`

## Configuring WIFI Hotspot

http://elinux.org/RPI-Wireless-Hotspot

Alternative: http://www.daveconroy.com/turn-your-raspberry-pi-into-a-wifi-hotspot-with-edimax-nano-usb-ew-7811un-rtl8188cus-chipset/

## Alternate hostapd implementation

http://blog.sip2serve.com/post/48420162196/howto-setup-rtl8188cus-on-rpi-as-an-access-point  

Download Binary from: http://dl.dropbox.com/u/1663660/hostapd/hostapd

## ADAFRUIT - FONA Device for 3G

http://www.adafruit.com/product/1946

## Tmobile: 6 month data plans for $80

https://www.sparkfun.com/products/13186

# Ultimate OpenBSD Router

http://www.bsdnow.tv/tutorials/openbsd-router

Hacker News discussion: https://news.ycombinator.com/item?id=9482696

## Bandwidth Monitoring Links

http://wiki.openwrt.org/doc/howto/bwmon 

## Network Configuration Reference

http://www.computerhope.com/unix/ifup.htm

## 3g signal booster

http://www.amazon.com/Wilson-460109-Booster-Antenna-Formerly/dp/B00R1SLB02

## Supporting usb modems utilizing modeswitch:

https://www.thefanclub.co.za/how-to/how-setup-usb-3g-modem-raspberry-pi-using-usbmodeswitch-and-wvdial 

## PPP / Fona / RPI

https://learn.adafruit.com/fona-tethering-to-raspberry-pi-or-beaglebone-black/setup

This thing only transmits on 1G - too slow to be usable.

## xml containing a great deal of apns:

https://gist.github.com/invisiblek/af14e3f1680b2b7f56d1 

## Manual at command to set APN

at+cgdcont=1,"IP","v1.globalm2m.net"

## Manual AT command for truphone sim.

at+cgdcont=1,"IP","truphone.com"

## connect command for truphone sim.

`pi@raspberrypi ~ $ sudo ./sakis3g connect --console --nostorage --pppd CUSTOM_APN=truphone.com APN=truphone.com BAUD=115200 CUSTOM_TTY="/dev/ttyAMA0" MODEM="/dev/ttyAMA0" TTY="/dev/ttyAMA0" OTHER="CUSTOM_TTY" APN_USER=' ' APN_PASS=' '`

## Page on setting up a sierra pppd device with lockout

https://wiki.ubuntu.com/SierraMC8775

## Page with driver links for hp version of mc8775
http://www.3g-modem-wiki.com/page/Sierra+Wireless+MC8775+%26+MC8775v
ftp://ftp.hp.com/pub/softpaq/sp36501-37000/sp36889.exe

## Network booting RPi's
http://blogs.wcode.org/2013/09/howto-netboot-a-raspberry-pi/

## Gobi at command set
https://www.olimex.com/Products/USB-Modules/MOD-USB3G/resources/AT_Command_Set_Gobi.pdf
