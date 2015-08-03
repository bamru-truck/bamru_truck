
/* Micronucleus based rebooting hardware for rebooting a pass through USB device.
 * Pretty simple, connect the positive of a relay to pins 0,1, & 2 of the device. 
 * The relay needs to draw 120ma or less. Less is better. I am usign a omron g5v-1 relay.
 * The device will talk at 9600 n81 
 */
//#include <DigiUSB.h>

void print_help()
{
  Serial.println("Help section:");
  Serial.println("Send the following commands to change the uc states");
  Serial.println("c1 - reset the device by turning off the pass-through for the <delay> interval");
  Serial.println("c2 - connect the pass-through device");
  Serial.println("c3 - disconnect the pass-through");
  Serial.println("c4 - reset the <delay> interval to default of 1 second.");
  Serial.println("c5<int8 delay in seconds 0-254> - Set the number of seconds to set the delay.");
  Serial.println("   The <delay> value is written to flash, so, it is preserved accross reboots.");
}

void relay_on() {
  digitalWrite(4,LOW);
  digitalWrite(5,LOW);
  digitalWrite(6,LOW);
  digitalWrite(7,LOW);
}

void setup() {
  //DigiUSB.begin(); 
  Serial.begin(9600); //Connect to GPS
  pinMode(4,OUTPUT);
  pinMode(5,OUTPUT);
  pinMode(6,OUTPUT);
  pinMode(7,OUTPUT);
  // Set the relay on
  relay_on();
}

void loop() {
  print_help();
  delay(1000);
  // put your main code here, to run repeatedly:

}


