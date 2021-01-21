import java.awt.Robot;
Robot rbt;
//color pallette
color black = #000000;    //mossy stone
color white = #FFFFFF;    //empty
color dullBlue = #7092BE; //oak planks

//textures
PImage mossyStone;
PImage oakPlanks;

//Map  variables
int gridSize;
PImage map;
//camera variables
float eyex, eyey, eyez; //camera position
float focusx, focusy, focusz; //point at which camera faces
float upx, upy, upz; //tilt axis

float leftRightAngle = 3* PI/2;
float upDownAngle = 0;
int forwardStart = 0;
int forwardEnd = 5000;
int backwardStart = 0;
int backwardEnd = -5000;
int speed = 10;

//keyboard variables
boolean wkey, akey, dkey, skey;

void setup() {
  mossyStone = loadImage("Mossy_Stone_Bricks.png");
  oakPlanks = loadImage("Oak_Planks.png");
  textureMode(NORMAL);
  noCursor();
  try {
    rbt = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  leftRightAngle = 0;
  size(displayWidth, displayHeight, P3D);

  eyex = width/2;
  eyey = 8*height/10;
  eyez = height/2;

  focusx = width/2;
  focusy = height/2;
  focusz = height/2 - 100;

  upx = 0;
  upy = 1;
  upz = 0;

  //intialize map
  map = loadImage("map.png");
  gridSize = 100;
}

void draw() {
  background(0);

  pointLight(255, 255, 255, eyex, eyey, eyez);
  camera(eyex, eyey, eyez, focusx, focusy, focusz, upx, upy, upz);

  move();
  drawAxis();
  drawFloor(-2000, 2000, height, gridSize); //floor
  drawFloor(-2000, 2000, height-gridSize*4, gridSize); //ceiling
  drawInterface();
  drawMap();
}

void drawMap() {
  for (int x = 0; x <map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c == dullBlue || c == black) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, mossyStone, gridSize);
        texturedCube(x*gridSize-2000, height-(gridSize*2), y*gridSize-2000, mossyStone, gridSize);
        texturedCube(x*gridSize-2000, height-(gridSize *3), y*gridSize-2000, mossyStone, gridSize);
      }
    }
  }
}

void drawInterface() {
  pushMatrix();
  stroke(255, 0, 0);
  strokeWeight(0);
  line(width/2-15, height/2, width/2+15, height/2);
  line(width/2, height/2-15, width/2, height/2+15);
  popMatrix();
}
void move() {

  pushMatrix();
  translate(focusx, focusy, focusz);
  sphere(5);
  popMatrix();
  if (akey && canMoveLeft() == true) {
    eyex += cos(leftRightAngle - radians(90))*10;
    eyez += sin(leftRightAngle - radians(90))*10;
  }
  if (dkey && canMoveRight() == true) {
    eyex += cos(leftRightAngle + radians(90))*10;
    eyez += sin(leftRightAngle + radians(90))*10;
  }
  if (wkey && canMoveForward() == true ) {
    eyex += cos(leftRightAngle)*speed;
    eyez += sin(leftRightAngle)*speed;
  }
  if (skey && canMoveBack() == true) {
    eyex -= cos(leftRightAngle)*10;
    eyez -= sin(leftRightAngle)*10;
  }

  focusx = eyex + cos(leftRightAngle)*300;
  focusy = eyey + tan(upDownAngle)*300;
  focusz = eyez + sin(leftRightAngle)*300;

  leftRightAngle = leftRightAngle + (mouseX-pmouseX)*0.01;
  upDownAngle = upDownAngle + (mouseY - pmouseY) *0.01;

  if (upDownAngle > PI/2.5) upDownAngle = PI/2.5;
  if (upDownAngle < -PI/2.5) upDownAngle = -PI/2.5;

  if (mouseX > width-2) rbt.mouseMove(3, mouseY);
  else if (mouseX < 2) rbt.mouseMove(width-3, mouseY);
}

boolean canMoveForward() {
  float fwdx, fwdy, fwdz;
  float leftx, lefty, leftz;
  int mapx, mapy;
  fwdx = eyex + cos(leftRightAngle)*200;
  fwdy = eyey;
  fwdz = eyez + sin(leftRightAngle)*200;

  mapx = int(fwdx + 2000) / gridSize;
  mapy = int(fwdz + 2000) / gridSize;

  if (map.get(mapx, mapy) == white ) {
    return true;
  } else {
    return false;
  }
}

boolean canMoveRight() {
  float rightx, rightz;
  int mapx, mapy;
  rightz = eyez + sin(leftRightAngle+radians(90))*200;
  rightx = eyex + cos(leftRightAngle+radians(90))*200;
  mapx = int(rightx + 2000) / gridSize;
  mapy = int(rightz + 2000) / gridSize;
  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }
}

boolean canMoveLeft() {
  float leftx, leftz;
  leftx = eyex + cos(leftRightAngle-radians(90))*200;
  leftz = eyez + sin(leftRightAngle-radians(90))*200;
  int mapx, mapy;
  mapx = int(leftx + 2000) / gridSize;
  mapy = int(leftz + 2000) / gridSize;
  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }
}

boolean canMoveBack() {
  float backx, backz;
  backx = eyex + cos(leftRightAngle-radians(180))*200;
  backz = eyez + sin(leftRightAngle-radians(180))*200;
  int mapx, mapy;
  mapx = int(backx + 2000) / gridSize;
  mapy = int(backz + 2000) / gridSize;
  if (map.get(mapx, mapy) == white) {
    return true;
  } else {
    return false;
  }
}

void drawAxis() {
  stroke(255, 0, 0);
  strokeWeight(5);
  line(0, 0, 0, 0, 0, 2000);
  line(0, 0, 0, 0, 2000, 0);
  line(0, 0, 0, 2000, 0, 0);
  noFill();
  rect(0, 0, width, height);
}

void drawFloor(int start, int end, int level, int gap) {
  stroke(255);
  strokeWeight(1);
  int x = start;
  int z = start;
  while (z < end) {
    texturedCube(x, level, z, oakPlanks, gap);
    x = x + gap;
    if (x >= end) {
      x = start;
      z = z + gap;
    }
  }
}

void keyPressed() {
  if (key == 'w' || key == 'W') wkey = true;
  if (key == 'a' || key == 'A') akey = true;
  if (key == 's' || key == 'S') skey = true;
  if (key == 'd' || key == 'D') dkey = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W') wkey = false;
  if (key == 'a' || key == 'A') akey = false;
  if (key == 's' || key == 'S') skey = false;
  if (key == 'd' || key == 'D') dkey = false;
}
