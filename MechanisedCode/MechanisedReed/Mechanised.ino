int drive_pin = 0;

int top_pin1 = 1;
int top_pin2 = 2;

int bottom_pin1 = 3;
int bottom_pin2 = 4;

int reed_pin = 8;

int state = 1;

void setup() {
  // put your setup code here, to run once:
  pinMode(top_pin1, OUTPUT);
  pinMode(top_pin2, OUTPUT);
  pinMode(bottom_pin1, OUTPUT);
  pinMode(bottom_pin2, OUTPUT);
  pinMode(drive_pin, OUTPUT);

  pinMode(reed_pin, INPUT);
  topoff();
  bottomoff();
  drive(1);
}

void loop() {
switch (state) {
  case 1:
    if (digitalRead(reed_pin)) {
      topoff();
      bottomrack(1);
      delay(1000);
      state = 2;
    }
    break;
  case 2:
    if (digitalRead(reed_pin)) {
      bottomrack(0);
      delay(1000);
      state = 3;
    }
    break;
  case 3:
    if (digitalRead(reed_pin)) {
      bottomoff();
      delay(1000);
      state = 4;
    }
    break;
  case 4:
    if (digitalRead(reed_pin)) {
      toprack(1);
      delay(1000);
      state = 5;
    }
    break;
  case 5:
    if (digitalRead(reed_pin)) {
      toprack(0);
      delay(1000);
      state = 1;
    }
    break;
  default:
    break;
}

  
//  bottomrack(1);
//  delay(6700);
//  bottomrack(0);
//  delay(6500);
//  bottomoff();
//  toprack(1);
//  delay(3800);
//  toprack(0);
//  delay(3800);
//  topoff();
  
//  bottomrack(0);
//  delay(6500);
//  // delay(3800);
//  bottomrack(1);
//  delay(6700);
//  // delay(3800);
}

void toprack(bool A){
  // 1 is inwards, 0 outwards
  digitalWrite(top_pin1, A);
  digitalWrite(top_pin2, !A);
}

void bottomrack(bool A){
  // 1 is inwards, 0 outwards
  digitalWrite(bottom_pin1, !A);
  digitalWrite(bottom_pin2, A);
}

void topoff(){
  digitalWrite(top_pin1, 0);
  digitalWrite(top_pin2, 0);
}

void bottomoff(){
  digitalWrite(bottom_pin1, 0);
  digitalWrite(bottom_pin2, 0);
}

void drive(bool A){
  // 1 is on, 0 is off
  digitalWrite(drive_pin, !A); 
}
