class WeatherParticle {
  String type;
  PVector position;
  PVector velocity;
  float size;
  WeatherParticle(String type_) {
    position = new PVector(random(-50, width+50), random(-1000, -10));
    type = type_;
    size = random(3, 6);
    velocity = new PVector(random(-.1, .1), random(.8, 1.2));
  }
  void update() {
    if (type=="snow") {
      position.add(velocity.copy().mult(750.0/dayLength));
      noStroke();
      fill(255, 100);
      ellipseMode(RADIUS);
      ellipse(position.x, position.y, size, size);
    }
    if (type=="rain") {
      position.add(velocity.copy().mult(1500.0/dayLength));
      stroke(0,0,255,200);
      strokeWeight(3);
      line(position.x,position.y,position.x+velocity.copy().setMag(5).x,position.y+velocity.copy().setMag(5).y);
      noStroke();
    }
  }
  boolean offScreen() {
    return(position.y>height+size*2);
  }
}