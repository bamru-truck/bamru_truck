# PowerCycle

For test automation, we need a way to reliably reboot the RPi.  

## Options

We can use either a commercial PowerCycle network appliance, or we can use an
Arduino-based power-cycle device built by Michael.

### Commercial PowerCycle Appliance

These PowerCycle devices take a reboot signal over ethernet.

- [single outlet](http://www.amazon.com/ezOutlet-Internet-IP-Enabled-Android-Interface/dp/B00KQ4R1RK/ref=pd_bxgy_60_img_y)

- [dual outlet](http://www.amazon.com/MSNSwitch-Internet-IP-Enabled-Remote-Interface/dp/B00K36JLL0/ref=pd_bxgy_23_img_y)

### Michael's Arduino PowerCycle Device

Michael has built an arduino power cycling device take a reboot signal over USB.  

### Comparison

The upside of the Michael's Arduino device is cost.  The downside is that it only can be driven by a single test machine, and it requires custom configuration to select the correct TTY port.

The downside of the Commercial PowerCycle appliance is cost ($50-$100).
The upside is that it can be driven by any computer on the network.


## Arduino Configuration

Plug in all the cables to the Arduino power-cycle device.  

Then you've got to figure out what TTY your USB is using.

Unplug the USB, then reattach.

Then type `dmesg`.  Look for the tty.

Then run the program `powercycle/arduino_reset.py -t /dev/ttyXXX`
