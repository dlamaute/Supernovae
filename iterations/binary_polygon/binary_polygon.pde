import processing.pdf.*;

float dist, radius1, radius2, radius3, radius4, maxRad;
PVector center, star1, star2, star1Edge, star2Edge, remnantEdge1, remnantEdge2;
float changeRate, angle = -PI/2;
float arcNum, degDiff, spl, spl1, spl2;
float chandrasekharLimit;
int numRemnants;
boolean star2Growing = true, enableGrow = true, enableSpill = true, enableReceive = true;

//boolean recording;
//PGraphicsPDF pdf;

void setup() {
  size(400,400);
  //size(1768,1768, PDF, "binary_asymm_infinite_1");
  //size(1768, 1768);
  //pdf = (PGraphicsPDF) createGraphics(width, height, PDF, "pause-resume-13.pdf");
  
  dist = 150;
  changeRate = .05;
  center = new PVector(width/2, height/2);
  radius1 = 15;
  radius2 = 15;
  radius3 = radius1;
  radius4 = radius2;
  maxRad = radius1 + radius2;
  arcNum = 2*PI/maxRad;
  degDiff = PI/45;
  chandrasekharLimit = 80;
  numRemnants = 1;
}

void draw() {
  //background(255);
  ellipseMode(RADIUS);
  star1 = new PVector(center.x + cos(angle)*dist, center.y + sin(angle)*dist);
  star2 = new PVector(center.x + cos(angle+PI)*dist, center.y + sin(angle+PI)*dist);
  star1Edge = new PVector(star1.x + cos(angle+PI/2)*radius1, star1.y + sin(angle+PI/2)*radius1);
  star2Edge = new PVector(star2.x + cos(angle+PI/2)*radius2, star2.y + sin(angle+PI/2)*radius2);
  strokeWeight(3);
  fill(255);
  ellipse(star1.x, star1.y, radius1, radius1);
  strokeWeight(1);
  fill(max(radius2*3, 255), 0, 0);
  ellipse(star2.x, star2.y, radius2, radius2);
  fill(255);
  //Stage 1: a star grows
  if (enableGrow) {
    if (star2Growing) {
      radius2 += .1;
    } else {
      radius1 += .1;
    }
    enableGrow = growPhase(star2Growing, radius1, radius2, chandrasekharLimit);
    angle += changeRate;
    dist -= .005;
  } 
  
  //Stage 2: Spill gas
  else if (!enableGrow && enableSpill) {
      dist = round(dist);
      if (star2Growing) {
        remnantEdge1 = new PVector(star2Edge.x, star2Edge.y);
        fill(radius2*3, 0, 0);
      } else {
        remnantEdge1 = new PVector(star1Edge.x, star1Edge.y);
        fill(radius1*3, 0, 0);
      }
      if (numRemnants <= 20) {
        for (int i=0; i<numRemnants; i++){
          float r = 20 - i;
          PVector tailVect = new PVector(cos(angle +PI/4 - i*degDiff)*2*r, sin(angle +PI/4 - i*degDiff)*2*r);
          remnantEdge1.add(tailVect);
          //fill(r*3, 0,0);
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
          //fill(r*3,0,0);
          ellipse(remnantEdge1.x, remnantEdge1.y, r, r);
        }
      }
      if (star2Growing) {
         radius2 -= 2;
      } else {
         radius1 -= 2;
      }
      enableSpill = spillPhase(dist);
      angle += changeRate;
      degDiff += degDiff/50;
      dist--;
  }
  
  //Stage 3: Receive spilled gas
  else if (!enableSpill && enableReceive) {
    if (star2Growing) {
      remnantEdge2 = new PVector(star1Edge.x, star1Edge.y);
    } else {
      remnantEdge2 = new PVector(star2Edge.x, star2Edge.y);
    }
    if (numRemnants > 0) {
      for (int i=0; i<numRemnants; i++){
        float r = i;
        PVector tailVect = new PVector(cos(angle - PI/4 + i*degDiff)*2*r, sin(angle - PI/4 + i*degDiff)*2*r);
        remnantEdge2.add(tailVect);
        //fill(r*3,0,0);
        ellipse(remnantEdge2.x, remnantEdge2.y, r, r);
      }
    }
    if (star2Growing) {
      radius1 += .1;
    } else {
      radius2 += .1;
    }
    if (int(radius1*10) % 9 == 0) {
      numRemnants -= 1;
    }
    enableReceive = receivePhase(star2Growing, radius1, radius2, chandrasekharLimit);
    angle += changeRate;
  } 
  
  //Stage 4: Flip grower and start over
  else if (!enableSpill && !enableGrow && !enableReceive) {
      star2Growing = !star2Growing;
      enableGrow = true;
      enableSpill = true;
      enableReceive = true;
      //dist *= -1;
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

/*void keyPressed() {
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
}*/