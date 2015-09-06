
/* Arduino based rebooting hardware for rebooting a pass through USB device.
 * Pretty simple, connect the positive of a relay to pins D4-D7 of the device. 
 * The relay needs to draw 120ma or less. Less is better. I am usign a omron g5v-1 relay.
 * The device will talk at 9600 n81 
 */
#include <EEPROM.h>

#define LED 13
#define DEBUG 1
#define DEF_DELAY 4
#define DEF_EEPROM_LOC 9

int delay_value = 0;

void print_help()
{
  Serial.println("Help section:");
  Serial.println("Send the following commands to change the uc states");
  Serial.println("c1 - reset the device by turning off the pass-through for the <delay> interval");
  Serial.println("c2 - connect the pass-through device");
  Serial.println("c3 - disconnect the pass-through");
  Serial.println("c4 - reset the <delay> interval to default of 4 seconds.");
  Serial.println("c5<int8 delay in seconds 0-254> - Set the number of seconds to set the delay.");
  Serial.println("   The <delay> value is written to eeprom, so, it is preserved accross reboots.");
}

void relay_on() {
  digitalWrite(4,HIGH);
  digitalWrite(5,HIGH);
  digitalWrite(6,HIGH);
  digitalWrite(7,HIGH);
  digitalWrite(LED,HIGH); // Turn on LED to let user know that the output device should be on. 
}

void relay_off() {
  digitalWrite(4,LOW);
  digitalWrite(5,LOW);
  digitalWrite(6,LOW);
  digitalWrite(7,LOW);
  digitalWrite(LED,LOW);
}

void setup() {
  Serial.begin(9600); //Connect to GPS
  pinMode(4,OUTPUT);
  pinMode(5,OUTPUT);
  pinMode(6,OUTPUT);
  pinMode(7,OUTPUT);
  pinMode(LED, OUTPUT);
  // Set the relay on
  relay_on();
  delay_value = EEPROM.read(DEF_EEPROM_LOC);
  Serial.print("Current Delay value is ");
  Serial.print(delay_value, DEC);
  Serial.println(" Seconds");
  print_help(); //Print the help section to help the user along.
}

void loop() {
  int incomingByte;
  int doneRead=0;
  int value;
  if (Serial.available() > 0) {
    incomingByte = Serial.read();
    if ( incomingByte == 0x63 ) { // 0x63 is the character c
      if ( DEBUG == 1 ) {Serial.println("C char read"); }
      while ( doneRead == 0 ) {
        if (Serial.available() > 0) {
          incomingByte = Serial.read();
          switch (incomingByte) {
            case 0x31: // 0x31 is 1
              if ( DEBUG == 1 ) {Serial.println("1 char read"); }
              relay_off();
              value = delay_value * 1000;
              delay(value);
              relay_on();
              doneRead=1;
              break;
            case 0x32: // 0x32 is 2
              if ( DEBUG == 1 ) {Serial.println("2 char read"); }
              relay_on();
              doneRead=1;
              break;
            case 0x33: // 0x32 is 3
              if ( DEBUG == 1 ) {Serial.println("3 char read"); }
              relay_off();
              doneRead=1;
              break;
            case 0x34: // 0x32 is 4
              if ( DEBUG == 1 ) {Serial.println("4 char read"); }
              Serial.print("Setting delay in eeprom to ");
              Serial.print(DEF_DELAY, DEC);
              Serial.println(" Seconds");
              EEPROM.write(DEF_EEPROM_LOC, DEF_DELAY);
              delay_value = DEF_DELAY;
              doneRead=1;
              break;
            case 0x35: // 0x32 is 5
                if (Serial.available() > 0) {
                  incomingByte = Serial.read();
                  Serial.print("Setting delay to ");
                  Serial.println(incomingByte, DEC);
                  EEPROM.write(DEF_EEPROM_LOC, incomingByte);
                  delay_value = incomingByte;
                }
              if ( DEBUG == 1 ) {Serial.println("5 char read"); }
              doneRead=1;
              break;  
            default: 
              Serial.println("ERROR - Invalid character read");
              Serial.print("Recieved character was ");
              Serial.println(incomingByte, HEX);
              print_help();
              doneRead=1;
          }
        }
      }
    } else {
      Serial.println("ERROR - c character not recieved");
      Serial.print("Recieved character was ");
      Serial.println(incomingByte, HEX);
      print_help();
    }
  }
  
}


