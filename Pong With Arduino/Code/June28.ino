/*
 * Student Name: Ehtisham Ul Haq
 * Assignment due date: June 28, 2021
 */



int green = 0; //Green Led value from processing will be store here
int red = 0; //Red Led value from processing will be store here
const int greenLED = 4; //Pin number for green LED
const int redLED = 3; //Pin number for red LED
const int yellowSwitch = A0; //Right switch Pin
const int blueSwitch = A1; //Left switch Pin
const int LDRPIN = A2; // LDR Pin

void setup() {
  Serial.begin(9600);
  Serial.println("0"); //Initiate the communication
  pinMode(greenLED, OUTPUT);
  pinMode(redLED, OUTPUT);
  pinMode(yellowSwitch, INPUT);
  pinMode(blueSwitch, INPUT);
}

void loop() {
  while (Serial.available()) {
    green = Serial.parseInt(); //value from processing for green LED
    red = Serial.parseInt();  //value from processing for red LED
    if (Serial.read() == '\n') {
      digitalWrite(greenLED, green);
      digitalWrite(redLED, red);

      //stateRight and stateLeft wil be used to read the switches values and send it to processing using Serial.print
      int stateRight = digitalRead(yellowSwitch); 
      delay(1); //1 ms delay for stability
      int stateLeft = digitalRead(blueSwitch);
      delay(1);
      
      //Ldr value will be read and sent to processing
      int readingLDR = analogRead(LDRPIN);
      delay(1);

      //In total, 3 values are sent to processing: 2 switches and 1 LDR:
      Serial.print(stateRight);
      Serial.print(',');
      Serial.print(stateLeft);
      Serial.print(',');
      Serial.println(readingLDR);
    }
  }
}
