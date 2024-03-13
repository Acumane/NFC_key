#include <SoftwareSerial.h>
#include <LiquidCrystal_I2C.h>
#include <Adafruit_PN532.h>
#include <PN532_SWHSU.h>
#include <PN532.h>

SoftwareSerial SWSerial( 3, 2 ); // RX, TX
LiquidCrystal_I2C lcd(0x27, 16, 2); // I2C address 0x27, 20 column and 4 rows
PN532_SWHSU pn532swhsu( SWSerial );
PN532 nfc( pn532swhsu );
String tagId = "None", dispTag = "None";
byte nuidPICC[4];

void setup() {
  Serial.begin(115200);
  Serial.println("Hello Maker!");
  lcd.init(); // initialize the lcd
  lcd.backlight();

  lcd.setCursor(0, 0);            // move cursor the first row
  lcd.print("Hello, Bren.");          // print message at the first row
  lcd.setCursor(0, 1);            // move cursor to the second row
  lcd.print("How are you?"); // print message at the second row

  nfc.begin();
  uint32_t versiondata = nfc.getFirmwareVersion();
  if (! versiondata)
  {
    Serial.print("Didn't Find PN53x Module");
    while (1); // Halt
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  readNFC();
}

void readNFC()
{
  boolean success;
  uint8_t uid[] = { 0, 0, 0, 0, 0, 0, 0 };  // Buffer to store the returned UID
  uint8_t uidLength;                       // Length of the UID (4 or 7 bytes depending on ISO14443A card type)
  success = nfc.readPassiveTargetID(PN532_MIFARE_ISO14443A, &uid[0], &uidLength);
  if (success)
  {
    Serial.print("UID Length: ");
    Serial.print(uidLength, DEC);
    Serial.println(" bytes");
    Serial.print("UID Value: ");
    for (uint8_t i = 0; i < uidLength; i++)
    {
      nuidPICC[i] = uid[i];
      Serial.print(" "); Serial.print(uid[i], DEC);
    }
    Serial.println();
    tagId = tagToString(nuidPICC);
    dispTag = tagId;
    Serial.print(F("tagId is : "));
    Serial.println(tagId);
    Serial.println("");
    delay(1000);  // 1 second halt
  }
  else
  {
    // PN532 probably timed out waiting for a card
    Serial.println("Timed out! Waiting for a card...");
  }
}
String tagToString(byte id[4])
{
  String tagId = "";
  for (byte i = 0; i < 4; i++)
  {
    if (i < 3) tagId += String(id[i]) + ".";
    else tagId += String(id[i]);
  }
  return tagId;
}