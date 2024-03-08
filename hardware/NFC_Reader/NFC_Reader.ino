#include <LiquidCrystal_I2C.h>
#include <Adafruit_PN532.h>
#include <PN532.h>

LiquidCrystal_I2C lcd(0x27, 16, 2); // I2C address 0x27, 20 column and 4 rows

void setup() {
  lcd.init(); // initialize the lcd
  lcd.backlight();

  lcd.setCursor(0, 0);            // move cursor the first row
  lcd.print("Hello, Bren.");          // print message at the first row
  lcd.setCursor(0, 1);            // move cursor to the second row
  lcd.print("How are you?"); // print message at the second row
}

void loop() {
  // put your main code here, to run repeatedly:

}
