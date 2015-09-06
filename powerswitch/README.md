# PowerCycle

For test automation, we need a way to reliably reboot the RPi.  

## Options

We can use either a commercial HomeAutomation switch, or we can use an
Arduino-based power-cycle device built by Michael.

### Commercial HomeAutomation Switch

These PowerCycle devices take a reboot signal over ethernet.

[Belkin WeMo Insight Switch](http://www.amazon.com/WeMo-F7C029fc-Enabled-Insight-Smartphones/dp/B00EOEDJ9W/ref=sr_1_1?ie=UTF8&qid=1441147697&sr=8-1&keywords=belkin+wemo+insight+switch)

[ouimeaux - command-line interface for wemo](https://github.com/iancmcc/ouimeaux)

### Michael's Arduino PowerCycle Device

Michael has built an arduino power cycling device take a reboot signal over USB.  

### Comparison

The upside of the Michael's Arduino device is cost.  The downside is that it
only can be driven by a single test machine, and it requires custom
configuration to select the correct TTY port.

The downside of the HomeAutomation Switch is cost ($50-$100).
The upside is that it can be driven by any computer on the network.

## Arduino Configuration

Plug in all the cables to the Arduino power-cycle device.  

Then you've got to figure out what TTY your USB is using.

Unplug the USB, then reattach.

Then type `dmesg`.  Look for the tty.

Then run the program `powercycle/arduino_reset.py -t /dev/ttyXXX`

## Wemo Setup

Install the Wemo switch on your network.

Run the script `ouimeaux/install`.

