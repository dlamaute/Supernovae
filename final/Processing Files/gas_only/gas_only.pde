import processing.pdf.*;

float dist, radius1, radius2, maxRad;
PVector center, star1, star2, star1Edge, star2Edge, remnantEdge1, remnantEdge2;
float changeRate, angle = -PI/2;
float arcNum, degDiff, spl, spl1, spl2;
float chandrasekharLimit;
int numRemnants;
boolean star2Growing = true, enableGrow = true, enableSpill = true, enableReceive = true;
float dir = .51;

boolean recording;
PGraphicsPDF pdf;

void setup() {
  //size(800,800);
  //size(1768,1768, PDF, "binary_asymm_infinite_1");
  size(1768, 1768);
  pdf = (PGraphicsPDF) createGraphics(width, height, PDF, "gas-21.pdf");
  background(255);
  
  dist = 4*width/5.0;
  changeRate = .05;
  radius1 = 15;
  radius2 = 15;
  maxRad = radius1 + radius2;
  arcNum = 2*PI/maxRad;
  degDiff = PI/45;
  chandrasekharLimit = 80;
  numRemnants = 1;
}

void draw() {
  noFill();
  float rW = random(width/4);
  float rH = random(height/2);
  center = new PVector(rW, rH);
  ellipseMode(RADIUS);
  star1 = new PVector(center.x + cos(angle)*dist + 25, center.y + sin(angle)*dist + random(15));
  star2 = new PVector(center.x + cos(angle+PI)*dist + random(15), center.y + sin(angle+PI)*dist + 45);
  star1Edge = new PVector(star1.x + cos(angle+PI/2)*radius1, star1.y + sin(angle+PI/2)*radius1);
  star2Edge = new PVector(star2.x + cos(angle+PI/2)*radius2, star2.y + sin(angle+PI/2)*radius2);
  //strokeWeight(round(abs(width-star1.x)/100.));
  float str1 = map(abs(width-dist), width, 0, 1, 5);
  float str2 = map(abs(width-dist), width, 0, 1, 5);
  strokeWeight(str1);
  stroke(min(radius1*3, 255), 200, 150, 20);
  ellipse(star1.x, star1.y, radius1, radius1);
  //strokeWeight(round(abs(width-star2.x)/100.));
  strokeWeight(str2);
  stroke(min(radius2*3, 255), 150, 200, 20);
  ellipse(star2.x, star2.y, radius2, radius2);
  
  dist = round(dist);
  
  if (star2Growing) {
    remnantEdge1 = new PVector(star2Edge.x, star2Edge.y);
    stroke(0, 255*(1-3*star2Edge.x/width), 255*(1-dist/width), 25);
    strokeWeight(str2);
  } else {
    remnantEdge1 = new PVector(star1Edge.x, star1Edge.y);
    stroke(0, 255*(1-3*star1Edge.x/width), 255*(1-dist/width), 25);
    strokeWeight(str1);
  }
  if (numRemnants <= 40) {
    for (int i=0; i<numRemnants; i++){
      float r = 20 - i;
      PVector tailVect = new PVector(cos(angle +PI/4 - i*degDiff)*2*r, sin(angle +PI/4 - i*degDiff)*2*r);
      remnantEdge1.add(tailVect);
      ellipse(remnantEdge1.x, remnantEdge1.y, r, r);
    }
    if (dist % 3 == 0) {
      numRemnants += 1;
    }
  } else {
    for (int i=0; i<numRemnants; i++){
      float r = 20-i;
      PVector tailVect = new PVector(cos(angle +PI/4 - i*degDiff)*2*r, sin(angle +PI/4 - i*degDiff)*2*r);
      remnantEdge1.add(tailVect);
      //strokeWeight(numRemnants/2);
      ellipse(remnantEdge1.x, remnantEdge1.y, r, r);
    }
  }
  if (star2Growing) {
     radius2 = max(radius2 - 2, 20);
  } else {
     radius1 = max(radius1 - 2, 20);
  }
  enableSpill = spillPhase(dist);
  angle += changeRate;
  if (degDiff < 1.0/2.0) {
    degDiff += degDiff/200;
  } else {
    degDiff -= degDiff/200;
  }
  if (dist > 70 && dist < width) {
    dist = max(dist - dir, 70);
  } else if (dist <= 10 || dist >= width) {
    dir *= -1;
  }
  
}

boolean growPhase(boolean star2Growing, float radius1, float radius2, float chandrasekharLimit) {
  if (star2Growing) {
    if (radius2 > chandrasekharLimit) {
      return false;
    }
  } else {
    if (radius1 > chandrasekharLimit) {
      return false;
    }
  }
  return true;
}

boolean spillPhase(float dist) {
  if (dist < 90) {
    return false;
  } else {
    return true;
  }
}

boolean receivePhase(boolean star2Growing, float radius1, float radius2, float chandrasekharLimit) { 
  if (star2Growing) {
    if (radius1 > chandrasekharLimit) {
      return false;
    }
  } else {
    if (radius2 > chandrasekharLimit) {
      return false;
    }
  }
  return true;
}

void keyPressed() {
  if (key == 'r') {
    if (recording) {
      endRecord();
      println("Recording stopped.");
      recording = false;
    } else {
      beginRecord(pdf);
      println("Recording started.");
      recording = true;
    }
  } else if (key == 'q') {
    if (recording) {
      endRecord();
    }
    exit();
  }  
}