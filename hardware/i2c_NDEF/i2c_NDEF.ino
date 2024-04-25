#include <Wire.h>
#include <PN532_I2C.h>
#include <PN532.h>
#include <NfcAdapter.h>
PN532_I2C pn532_i2c(Wire);
NfcAdapter nfc = NfcAdapter(pn532_i2c);
String tagId = "None";
byte nuidPICC[4];

int tagnum = 0;
 
void setup(void) 
{
 Serial.begin(115200);
 Serial.println("System initialized");
 nfc.begin();
}
 
void loop() 
{
 readNFC();
}
 
void readNFC() 
{
 if (nfc.tagPresent())
 {
   tagnum++;
   NfcTag tag = nfc.read();
   tag.print();
   tagId = tag.getUidString();
   Serial.println("tagnum " + String(tagnum));
 }
 delay(1000);
}
