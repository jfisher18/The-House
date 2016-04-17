class Smoke {
  float xPos, yPos;
  float deltaX;
  float speed;
  Smoke(float x, float y) {
    xPos = x;
    yPos = y;
    deltaX = 2*(xPos-526)/37-1;
  }
  void drawSmoke() {
    ellipse(xPos, yPos, 5, 5);
    speed = 150.0/dayLength;
    xPos += deltaX*speed;
    xPos += windForce*speed;
    yPos -= speed;
  }
  boolean offScreen() {
    if (yPos < -10) {
      return true;
    } else {
      return false;
    }
  }
}