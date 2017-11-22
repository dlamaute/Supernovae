int x1,radius1, radius2, maxRad;
PVector center, star1, star2;
float changeRate, angle = -90;
float arcNum, spl, spl1, spl2;
int centerX, centerY;

void setup() {
  size(400,400);
  x1 = 200;
  changeRate = .05;
  radius1 = 50;
  radius2 = 50;
  maxRad = radius1 + radius2;
  arcNum = 2*PI/maxRad;
  centerX = width/2;
  centerY = width/2;
}

void draw() {
  //background(255);
  center = new PVector(centerX, centerY);
  star1 = new PVector(center.x + cos(angle)*x1, center.y + sin(angle)*x1);
  star2 = new PVector(center.x + cos(angle+180)*x1, center.y + sin(angle+180)*x1);
  if (x1 > 0) {   
    ellipse(star1.x, star1.y, radius1, radius2);
    ellipse(star2.x, star2.y, radius1, radius2);
    angle += changeRate;
    changeRate *= 1.008;
    x1 -= 1;
  } 
  else if (radius1 < maxRad){
    ellipse(center.x, center.y, radius1, radius1);
    radius1 += 1;
  } else {
      //arc(width/2, height/2, radius1, radius1, spl1*arcNum, (spl1+2)*arcNum);
      //arc(width/2, height/2, radius2, radius2, spl2*arcNum, (spl2+1)*arcNum);
    for (int i=0; i < maxRad/3; i++) {
      spl = int(random(0, maxRad));
      if (i%7 == 0) {
        arc(center.x, center.y, radius1, radius1, spl*arcNum, (spl+1)*arcNum);
      } else if (i%3 == 0) {
        arc(center.x, center.y, radius2, radius2, spl*arcNum, (spl+1)*arcNum);
      }
    }
    radius1 += 1;
    radius2 += 2;
  }
}