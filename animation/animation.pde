/*
House Animation
 
 By Jake Fisher
 
 Features and notes:
 Completely adjustable day length!
 -You can change the constant dayLength on line 21, which is in frames (program runs at 60fps by default)
 -Recommended time is 200
 -Everything is adjusted accordingly
 Smoke from chimney
 -Moves with wind, which changes randomly
 Meteor shower (non horixontal/vertical movement)
 -Odds of happening are one in five each night
 -If you want to see it every night, uncomment line 75
 Moon Phases
 -Takes 16 nights for a full cycle 
 */

int time;
int dayLength = 240;
int sunX, sunY, sunTime;
int moonX, moonY, moonTime;
float skyBrightness;
final int numberOfStars = int(random(300, 500));
int currentAlphaValue;
ArrayList<Star> stars;
ArrayList<Cloud> currentClouds;
ArrayList<ShootingStar> shootingStarsTonight;
ArrayList<Smoke> currentSmoke;
boolean ifShootingStarsTonight;
int timeSinceLastCloud;
boolean lightsOn;
boolean waning;
int phase=1;
float startAngle, stopAngle, centralAngle, inscribedAngle;
PImage picture;
float windForce = random(-1, 1);
int adder;
ArrayList<WeatherParticle> snow;
ArrayList<WeatherParticle> rain;
boolean snowing;
boolean raining;
int rainFrames = 0;


void setup() {
  size(960, 540);
  stars = new ArrayList<Star>();
  snow = new ArrayList<WeatherParticle>();
  rain = new ArrayList<WeatherParticle>();
  currentClouds = new ArrayList<Cloud>();
  shootingStarsTonight = new ArrayList<ShootingStar>();
  currentSmoke = new ArrayList<Smoke>();
  noStroke();
  ellipseMode(CORNERS);
  for (int i = 0; i < numberOfStars; i++) {
    stars.add(new Star());
  }
  picture = loadImage("picture.png");
}

void draw() {
  //sky
  colorMode(HSB, 360, 100, 100);
  if (time < dayLength/4) {
    skyBrightness = (180.0/dayLength)*time+45;
  } else if (time  < 3*dayLength/4) {
    skyBrightness = (-180.0/dayLength)*time+135;
  } else {
    skyBrightness = (180.0/dayLength)*time-135;
  }
  background(color(192, 34, int (skyBrightness)));
  colorMode(RGB, 255, 255, 255);
  //stars
  currentAlphaValue = int(((600*-.85)/(dayLength/2))*abs(time - 3*dayLength/4) + 255);
  for (Star displayStar : stars) {
    displayStar.drawStar(currentAlphaValue);
  }
  if (time == dayLength/4) {
    ifShootingStarsTonight = (random(5) <= 1);
    //ifShootingStarsTonight = true;
    shootingStarsTonight.clear();
  }
  if (ifShootingStarsTonight) {
    if (time > dayLength/2) {
      if (time % int(dayLength/1200.0 + 1) == 0) {
        shootingStarsTonight.add(new ShootingStar());
      }
      for (ShootingStar displayStar : shootingStarsTonight) {
        displayStar.drawShootingStar(currentAlphaValue);
      }
    }
  }


  //sun and moon
  //sun
  if (time > (dayLength/2)+dayLength/12) {
    sunTime = time - dayLength;
  } else {
    sunTime = time;
  }
  sunX = int(((2*760*sunTime)/float(dayLength))+dayLength/12);
  sunY = int(.001468*sunX*sunX - 1.409*sunX + 414.3);
  fill(255, 242, 0);
  ellipseMode(CENTER);
  ellipse(sunX, sunY, 114, 114);
  //moon
  if (time > dayLength/12) {
    moonTime = time - dayLength + dayLength/2;
  } else {
    moonTime = time + dayLength/2;
  }
  moonX = int(((2*760*moonTime)/float(dayLength))+dayLength/12);
  moonY = int(.001468*moonX*moonX - 1.409*moonX + 414.3);
  fill(177);
  ellipse(moonX, moonY, 75, 75);
  colorMode(HSB, 360, 100, 100);
  if (time == dayLength/2) {
    phase++;
    if (phase == 17) {
      phase = 1;
    }
  }
  fill(color(192, 34, int (skyBrightness)));
  if (phase < 9) {
    arc(moonX, moonY, 77, 77, PI/2, 3*PI/2, OPEN);
  } else  if (phase > 9) {
    arc(moonX, moonY, 76, 76, 3*PI/2, 2*PI, OPEN);
    arc(moonX, moonY, 76, 76, 0, PI/2, OPEN);
    triangle(moonX, moonY-39, moonX, moonY+39, moonX+39, moonY);
  }
  if (phase > 13 || phase < 5) {
    fill(color(192, 34, int (skyBrightness)));
  } else {
    fill(0, 0, 68);
  }
  if (phase < 5 || phase > 9 && phase < 13) {
    inscribedAngle = 90+(22.5*((phase-1) % 4));
    centralAngle = 360 - 2*inscribedAngle;
    startAngle = 2*PI-radians(centralAngle)/2;
    stopAngle = radians(centralAngle)/2;
    arc(moonX-(38/tan(radians(centralAngle/2))), moonY, sqrt(pow((38/tan(radians(centralAngle/2))), 2)+pow(38, 2))*2, sqrt(pow((38/tan(radians(centralAngle/2))), 2)+pow(38, 2))*2, 0, stopAngle, CHORD);
    arc(moonX-(38/tan(radians(centralAngle/2))), moonY, sqrt(pow((38/tan(radians(centralAngle/2))), 2)+pow(38, 2))*2, sqrt(pow((38/tan(radians(centralAngle/2))), 2)+pow(38, 2))*2, startAngle, 2*PI, CHORD);
    triangle(moonX, moonY-39, moonX, moonY+39, moonX + (sqrt(pow((38/tan(radians(centralAngle/2))), 2)+pow(38, 2)))-(38/tan(radians(centralAngle/2))), moonY);
  } else {
    inscribedAngle = 180-(22.5*((phase-1) % 4));
    centralAngle = 360 - 2*inscribedAngle;
    startAngle = 2*PI-radians(centralAngle)/2;
    stopAngle = radians(centralAngle)/2;
    arc((moonX+(38/tan(radians(centralAngle/2)))), moonY, sqrt(pow((38/tan(radians(centralAngle/2))), 2)+pow(38, 2))*2, sqrt(pow((38/tan(radians(centralAngle/2))), 2)+pow(38, 2))*2, PI-stopAngle, PI, CHORD);
    arc((moonX+(38/tan(radians(centralAngle/2)))), moonY, sqrt(pow((38/tan(radians(centralAngle/2))), 2)+pow(38, 2))*2, sqrt(pow((38/tan(radians(centralAngle/2))), 2)+pow(38, 2))*2, PI, PI+stopAngle, CHORD);
    triangle(moonX, moonY-39, moonX, moonY+39, moonX - (sqrt(pow((38/tan(radians(centralAngle/2))), 2)+pow(38, 2)))+(38/tan(radians(centralAngle/2))), moonY);
  }
  colorMode(RGB, 255, 255, 255);

  //clouds
  timeSinceLastCloud++;
  if (timeSinceLastCloud % int(240*(dayLength/1200.0)) == 0) {
    if (random(1) < (16.0/(5*dayLength*.29))*(timeSinceLastCloud*timeSinceLastCloud)) {
      currentClouds.add(new Cloud());
      timeSinceLastCloud = 0;
    }
  }
  for (int i=0; i< currentClouds.size(); i++) {
    if (currentClouds.get(i).offScreen()) {
      currentClouds.remove(i);
      i--;
    }
  };
  for (Cloud displayCloud : currentClouds) {
    displayCloud.drawCloud();
  }
  //ground
  fill(34, 177, 76);
  rect(0, 288, 960, 300);

  //house
  //smoke
  ellipseMode(RADIUS);
  fill(127, 40);
  if (int(dayLength/80.0) == 0) {
    adder = 1;
  } else {
    adder = 0;
  }
  if (time % (int(dayLength/80.0)+adder) == 0) {
    for (int i = 535; i < 555; i++) {
      currentSmoke.add(new Smoke(i, 79));
    }
  }        
  for (Smoke displaySmoke : currentSmoke) {
    displaySmoke.drawSmoke();
  }
  for (int i=0; i< currentSmoke.size (); i++) {
    if (currentSmoke.get(i).offScreen()) {
      currentSmoke.remove(i);
      i--;
    }
  }
  windForce+=random(-.5, .5)*sqrt(random(0.5, 2))*150.0/dayLength;
  if (windForce > 4.5) {
    windForce-=2;
  } else if (windForce < -4.5) {
    windForce+=2;
  }
  ellipseMode(CORNERS);
  //chimney
  fill(107, 27, 33);
  rect(526, 74, 37, 55);
  //rectangle part
  fill(98, 50, 38);
  rect(249, 110, 339, 185);
  //roof
  triangle(244, 112, 417.5, 40, 593, 112);
  //door
  fill(184, 94, 71);
  rect(362, 205, 67, 90);
  //doorknob
  fill(255, 242, 0);
  ellipse(410, 244, 422, 255);
  //windows
  fill(0);
  rect(267, 151, 76, 57);
  rect(449, 152, 108, 56);
  fill(127);
  rect(272, 156, 66, 47);
  rect(454, 157, 98, 46);
  //picture
  image(picture, 468, 160, 66, 37);
  //lights
  if (lightsOn) {
    fill(255, 242, 0, 100);
    rect(272, 156, 66, 47);
    rect(454, 157, 98, 46);
  }
  //fence
  for (int i = 0; i < 10; i++) {
    fill(255);
    rect(220+(42*i), 255, 20, 60);
    triangle(220+(42*i), 255, 230+42*i, 245, 240+42*i, 255);
    if (i != 9) {
      rect(240+42*i, 275, 42, 10);
    }
  }

  //tree
  //trunk
  fill(98, 50, 38);
  rect(764, 192, 56, 130);
  //leaves
  fill(34, 177, 76);
  ellipse(737, 93, 846, 199);

  if (time != dayLength) {
    time++;
  } else {
    time = 0;
  }
  //weather
  for (WeatherParticle flake : snow) {
    flake.update();
  }
  for (int i=0; i< snow.size (); i++) {
    if (snow.get(i).offScreen()) {
      snow.remove(i);
      i--;
    }
  }
  if (rainFrames==0) {
    for (WeatherParticle drop : rain) {
      drop.update();
    }
  }
  for (int i=0; i< rain.size (); i++) {
    if (rain.get(i).offScreen()) {
      rain.remove(i);
      i--;
    }
  }
  snowing = snow.size()>0;
  raining = rain.size()>0;
  if (!snowing&&!raining) {
    if (random(500*(dayLength/240.0))<=1) {
      for (int i = 0; i <500; i++) {
        snow.add(new WeatherParticle("snow"));
      }
    }
    if (random(500*(dayLength/240.0))<=1) {
      for (int i = 0; i <700; i++) {
        rain.add(new WeatherParticle("rain"));
        rainFrames = 5;
      }
    }
  }
  if (rainFrames>0) {
    background(255);
    rainFrames--;
  }
}

void mousePressed() {
  if ((mouseX >= 249 && mouseX <= 588 && mouseY >= 110 && mouseY <= 295)  || (get(mouseX, mouseY) == color(98, 50, 38) && mouseX < 750)) {
    lightsOn = !lightsOn;
  }
}