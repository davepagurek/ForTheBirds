class Puff {
  float x, y, s;

  Puff(float x, float y, float s) {
    this.x = x;
    this.y = y;
    this.s = s;
  }
}

class Cloud {
  final static float MIN_HEIGHT = -300;
  final static float MAX_HEIGHT = -500;

  float x,y,h;
  ArrayList<Puff> puffs;
  Cloud() {
    this.puffs = new ArrayList<Puff>();
    this.h = random(MIN_HEIGHT, MAX_HEIGHT);
    this.x = random(-width/2, width/2);
    this.y = random(-width/2, width/2);
    for (int i = 0; i < 3; i++) {
      this.puffs.add(new Puff(
        random(-30, 30),
        random(-30, 30),
        random(20, 60)
      ));
    }
  }

  void draw() {
    fill(#FFFFFF);
    translate(this.x, this.h, this.y);
    for (Puff p : puffs) {
      translate(p.x, 0, p.y);
      sphere(p.s);
      translate(-p.x, 0, -p.y);
    }
    translate(-this.x, -this.h, -this.y);
  }
}
