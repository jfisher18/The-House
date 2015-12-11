class Star {
  int xPos, yPos;
  float radius = random(2,5);
  Star() {
    xPos = int(random(0, 960));
    yPos = int(random(0, 270));
  }
  void drawStar(int alphaValue) {
    fill(255, 255, 255, alphaValue);
    ellipseMode(CENTER);
    ellipse(xPos, yPos, radius, radius);
  }
}
