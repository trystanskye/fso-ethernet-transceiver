const int analogPin = A1;

const float speed_ms = 0.2;  // Sampling rate in milliseconds
const unsigned long speed_us = speed_ms * 1000;  // Converted to microseconds

unsigned long lastSampleTime = 0;

void setup() {
  Serial.begin(115200);  // High baud rate for fast data transfer
  lastSampleTime = micros();  // Initialize the timing reference
}

void loop() {
  unsigned long currentTime = micros();

  if (currentTime - lastSampleTime >= speed_us) {
    int value = analogRead(analogPin);
    Serial.println(value);

    lastSampleTime += speed_us;  // Keep stable intervals
  }
}
