const int outputPin = 7;
const int sequenceLength = 16;
const int speed = 200;  // Speed in milliseconds per blink

// bit sequence
const int sequence[sequenceLength] = {
  1, 0, 1, 1, 0, 0, 1, 0,
  0, 1, 1, 0, 1, 0, 0, 1
};

void setup() {
  pinMode(outputPin, OUTPUT);
}

void loop() {
  for (int i = 0; i < sequenceLength; i++) {
    digitalWrite(outputPin, sequence[i]);
    delay(speed);
  }
}