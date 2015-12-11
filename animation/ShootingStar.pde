class ShootingStar extends Star {
  float speed;
  int timeSinceInitialization;
  ShootingStar() {
    super();
    radius = 5;
    speed = random(600.0/dayLength+1, 2400.0/dayLength);
  }
  void drawShootingStar(int alphaValue) {
    super.drawStar(alphaValue-timeSinceInitialization*2);
    xPos+=speed;
    yPos+=speed;
    timeSinceInitialization+=300.0/dayLength;
  }
}
