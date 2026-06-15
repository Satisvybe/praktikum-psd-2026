const byte OUTPUT_PIN = 9;

const int noiseFreq[] = {
  250, 275, 300, 325, 350,
  375, 400, 425, 450, 475,
  500, 525, 550
};

const int N_FREQ = sizeof(noiseFreq) / sizeof(noiseFreq[0]);

unsigned long lastChange = 0;
int indexFreq = 0;

void setup() {
  Serial.begin(115200);
  pinMode(OUTPUT_PIN, OUTPUT);
  tone(OUTPUT_PIN, noiseFreq[indexFreq]);
}

void loop() {
  if (millis() - lastChange >= 50) {
    lastChange = millis();

    indexFreq++;

    if (indexFreq >= N_FREQ)
      indexFreq = 0;

    tone(OUTPUT_PIN, noiseFreq[indexFreq]);

    Serial.print("Noise Frequency = ");
    Serial.print(noiseFreq[indexFreq]);
    Serial.println(" Hz");
  }
}
