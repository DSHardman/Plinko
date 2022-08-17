int drive_pin = 0;

int magnet_pin = 12;

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
  pinMode(magnet_pin, OUTPUT);

  topoff();
  bottomoff();
  drive(1);
//  digitalWrite(magnet_pin, 0);
}

void loop() {
  delay(10000);
  toprack(1);
//  digitalWrite(magnet_pin, 1);
  delay(6000);
  toprack(0);
  delay(500);
  topoff();
//  digitalWrite(magnet_pin, 0);
  delay(2000);
  toprack(0);
  bottomrack(1);
  delay(4500);
  topoff();
  delay(3000);
  bottomoff();
  delay(2000);
  bottomrack(0);
  delay(8000);
  bottomoff();
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
