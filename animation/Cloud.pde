class Cloud {
  int yPos;
  int numberOfCircles = int(random(20, 50));
  int [][] circleArray = new int[numberOfCircles][3];
  int cloudWidth;
  int cloudHeight;
  float currentX = -200;
  float speed = random(3*1200.0/(5*dayLength), 9*1200.0/(5*dayLength));
  float greyscaleValue = 255;
  Cloud() {
    yPos = int(random(0, 200));
    cloudWidth = int(random(110, 170));
    cloudHeight = int(random(40, 70));
    for (int i = 0; i < numberOfCircles; i++) {
      //x,y,r
      circleArray[i][0] = int(random(cloudWidth));
      circleArray[i][1] = int(random(cloudHeight));
      circleArray[i][2] = int(random(35, 50));
    }
  }
  void drawCloud() {
    fill(greyscaleValue, 80);
    ellipseMode(CENTER);
    for (int i = 0; i < numberOfCircles; i++) {
      ellipse(circleArray[i][0]+currentX, circleArray[i][1]+yPos, circleArray[i][2], circleArray[i][2]);
    }
    currentX += speed;
  }
  void lightning(){
    
  }
  boolean offScreen() {
    if (currentX > 1100) {
      return true;
    } else {
      return false;
    }
  }
}
