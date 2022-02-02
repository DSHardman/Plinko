int drive_pin = 0;

int top_pin1 = 1;
int top_pin2 = 2;

int bottom_pin1 = 3;
int bottom_pin2 = 4;

void setup() {
  // put your setup code here, to run once:
  pinMode(top_pin1, OUTPUT);
  pinMode(top_pin2, OUTPUT);
  pinMode(bottom_pin1, OUTPUT);
  pinMode(bottom_pin2, OUTPUT);
  pinMode(drive_pin, OUTPUT);
}

void loop() {
  toprack(0);
  bottomrack(0);
  drive(1);
  delay(1000);

  toprack(1);
  bottomrack(1);
  drive(0);
  delay(1000);
}

void toprack(bool A){
  // 1 is inwards, 0 outwards
  digitalWrite(top_pin1, !A);
  digitalWrite(top_pin2, A);
}

void bottomrack(bool A){
  // 1 is inwards, 0 outwards
  digitalWrite(bottom_pin1, A);
  digitalWrite(bottom_pin2, !A);
}

void drive(bool A){
  // 1 is on, 0 is off
  digitalWrite(drive_pin, !A); 
}
