const int outputPinA = 7;   // Uniform pattern
const int outputPinB = 8;   // Constant HIGH
const int outputPinC = 12;  // Non-uniform pattern

const int sequenceLength = 16;
const int speed_ms = 1;  // Speed in milliseconds per blink
const unsigned long speed_us = speed_ms * 1000;  // Convert to microseconds

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

int currentIndex = 0;
unsigned long lastUpdateTime = 0;

void setup() {
  pinMode(outputPinA, OUTPUT);
  pinMode(outputPinB, OUTPUT);
  pinMode(outputPinC, OUTPUT);

  digitalWrite(outputPinB, HIGH);  // Constant HIGH
  lastUpdateTime = micros();       // Initialize timer
}

void loop() {
  unsigned long currentTime = micros();

  if (currentTime - lastUpdateTime >= speed_us) {
    // Update outputs from sequences
    digitalWrite(outputPinA, sequenceA[currentIndex]);
    digitalWrite(outputPinC, sequenceC[currentIndex]);

    // Advance sequence index
    currentIndex++;
    if (currentIndex >= sequenceLength) {
      currentIndex = 0;
    }

    lastUpdateTime += speed_us;  // Keeps stable intervals
  }
}
