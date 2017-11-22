float dist, radius1, radius2, radius3, radius4, maxRad;
PVector center, star1, star2, star1Edge, star2Edge, remnantEdge1, remnantEdge2;
float changeRate, angle = -PI/2;
float arcNum, degDiff, spl, spl1, spl2;
float chandrasekharLimit;
int numRemnants;

void setup() {
  size(400,400);
  dist = 150;
  changeRate = .05;
  center = new PVector(width/2, height/2);
  radius1 = 15;
  radius2 = 16;
  radius3 = radius1;
  radius4 = radius2;
  maxRad = radius1 + radius2;
  arcNum = 2*PI/maxRad;
  degDiff = PI/45;
  chandrasekharLimit = 50;
  numRemnants = 1;
}

void draw() {
  //background(255);
  ellipseMode(RADIUS);
  star1 = new PVector(center.x + cos(angle)*dist, center.y + sin(angle)*dist);
  star2 = new PVector(center.x + cos(angle+PI)*dist, center.y + sin(angle+PI)*dist);
  star1Edge = new PVector(star1.x + cos(angle+PI/2)*radius1, star1.y + sin(angle+PI/2)*radius1);
  star2Edge = new PVector(star2.x + cos(angle+PI/2)*radius2, star2.y + sin(angle+PI/2)*radius2);
  if (radius2 < 100) {
    ellipse(star1.x, star1.y, radius1, radius1);
    ellipse(star2.x, star2.y, radius2, radius2);
    angle += changeRate;
    radius2 += .1;
    dist -= .001;
  } 
  else if (dist > 90){
    dist = round(dist);
    ellipse(star1.x, star1.y, radius1, radius1);
    ellipse(star2.x, star2.y, radius2, radius2);
    remnantEdge1 = new PVector(star2Edge.x, star2Edge.y);
    if (numRemnants <= 20) {
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
        ellipse(remnantEdge1.x, remnantEdge1.y, r, r);
      }
    }
    angle += changeRate;
    degDiff += degDiff/50;
    dist--;
  } else if (radius1 < chandrasekharLimit) {
    ellipse(star1.x, star1.y, radius1, radius1);
    ellipse(star2.x, star2.y, radius2, radius2);
    remnantEdge2 = new PVector(star1Edge.x, star1Edge.y);
    if (numRemnants > 0) {
      for (int i=0; i<numRemnants; i++){
        float r = i;
        PVector tailVect = new PVector(cos(angle - PI/4 + i*degDiff)*2*r, sin(angle - PI/4 + i*degDiff)*2*r);
        remnantEdge2.add(tailVect);
        ellipse(remnantEdge2.x, remnantEdge2.y, r, r);
      }
    }
    angle += changeRate;
    radius1 += .2;
    if (int(radius1*10) % 11 == 0) {
      numRemnants -= 1;
    }
    radius3 = radius1;
    radius4 = radius2;
  } else {
    ellipse(star2.x - 1, star2.y - 1, radius2, radius2);
    for (int i=0; i < maxRad/3; i++) {
      spl = int(random(0, maxRad));
      if (i%7 == 0) {
        arc(star1.x, star1.y, radius3, radius3, spl*arcNum, (spl+1)*arcNum);
      } else if (i%3 == 0) {
        arc(star1.x, star1.y, radius4, radius4, spl*arcNum, (spl+1)*arcNum);
      }
    }
    radius3 += 1;
    radius4 += 2;
  }
}