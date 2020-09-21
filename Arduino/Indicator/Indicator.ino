// MonitoRack indicator

// Possible states:
//   0 [GREEN]  - Idle state
//   1 [ORANGE] - Preparation (creating files)
//   2 [RED]    - Recording (audio & video)

// === Definitions =================================================

int state = 0;

int pGND = 15;
int pR = 14;
int pG = 17;
int pB = 16;

// === Setup =======================================================

void setup() {                

  // --- Pin setup

  pinMode(pGND, OUTPUT);
  digitalWrite(pGND, LOW);
  
  pinMode(pR, OUTPUT);
  pinMode(pG, OUTPUT);
  pinMode(pB, OUTPUT);

  setColor(0);
  
  // --- Serial communication
  Serial.begin(115200);
  Serial.setTimeout(5);
  
}

// === Main loop ===================================================

void loop() {

  // --- Manage inputs ---------------------------------------------
  
  if (Serial.available()) {   

    String input = Serial.readString();
    input.trim();
    
    // --- Get information
    if (input.equals("info")) {
      
      Serial.println("----------------------------");
      Serial.println("Indicator");
      Serial.println("----------------------------");
      
    // --- Idle state
    } else if (input.equals("i")) {

      setColor(0);
      // Serial.println("IDLE");
     
    // --- Warning
    } else if (input.equals("p")) {

      setColor(1);
      // Serial.println("PREPARATION");
     
    // --- Recording
    } else if (input.equals("r")) {

      setColor(2);
      // Serial.println("RECORD");
      
    }
  }
  
}

void setColor(int c) {

  if (c==0) {
      digitalWrite(pR, LOW);
      digitalWrite(pG, HIGH);
      digitalWrite(pB, LOW);
      return;
  }

  if (c==1) {
      digitalWrite(pR, HIGH);
      digitalWrite(pG, HIGH);
      digitalWrite(pB, LOW);
      return;
  }

  if (c==2) {
      digitalWrite(pR, HIGH);
      digitalWrite(pG, LOW);
      digitalWrite(pB, LOW);
      return;
  }
  
}
