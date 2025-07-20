const int analogPin = A1;
const int speed = 20;  // Match this to the transmitter's blink speed (ms)


void setup() {
  Serial.begin(115200);  // High baud rate for fast serial transfer
  //delay(2000);
}

void loop() {
  int value = analogRead(analogPin);  // Read from A1
  Serial.println(value);
  delay(speed);
}
