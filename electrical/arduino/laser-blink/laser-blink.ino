const int outputPinA = 7;   // Uniform pattern
const int outputPinB = 8;   // Constant HIGH
const int outputPinC = 12;  // Non-uniform pattern

const int sequenceLength = 16;
const int speed = 100;  // Speed in milliseconds per blink

// Uniform bit sequence for pin 7
const int sequenceA[sequenceLength] = {
  1, 0, 1, 0, 1, 0, 1, 0,
  1, 0, 1, 0, 1, 0, 1, 0
};

// Non-uniform bit sequence for pin 12
const int sequenceC[sequenceLength] = {
  1, 0, 0, 1, 1, 0, 1, 0,
  0, 1, 0, 0, 1, 1, 1, 0
};

void setup() {
  pinMode(outputPinA, OUTPUT);
  pinMode(outputPinB, OUTPUT);
  pinMode(outputPinC, OUTPUT);

  digitalWrite(outputPinB, HIGH);  // Constant HIGH
}

void loop() {
  for (int i = 0; i < sequenceLength; i++) {
    digitalWrite(outputPinA, sequenceA[i]);
    digitalWrite(outputPinC, sequenceC[i]);
    delay(speed);
  }
}
