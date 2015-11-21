class Bird {

  final static boolean SHOW_TARGET = false;
  final static boolean SHOW_VELOCITY = false;

  // Properties
  float SPEED = 0.3;
  float RADIUS = width/3;
  float ESCAPE_RADIUS = width/10;
  float MAX_DIST = width*0.6;
  float w, h, d;
  PVector position, target, direction, acceleration;
  ArrayList<Bird> birds;
  boolean escaping = false;
  boolean returning = false;

  float step;

  // Constructor
  Bird(float w, float h, float d, float x, float y, float z){
    this.w = w;
    this.h = h;
    this.d = d;
    this.position = new PVector(x, y, z);
    this.direction = PVector.random3D();
    this.acceleration = PVector.random3D();
    this.target = PVector.random3D();
    this.target.mult(random(0, width/2));
    this.target.add(new PVector(0, -Water.HEIGHT, 0));

    this.step = random(-PI/2, PI/2);
  } 

  void setBirds(ArrayList<Bird> birds) {
    this.birds = birds;
  }

  void setTarget() {
    
    //if (this.returning || this.position.mag() >= MAX_DIST) {
      //this.returning = true;

      //while ()

      //if (this.position.mag() < MAX_DIST*0.8) {
        //this.returning = false;
      //}
    //}
    if (this.escaping || abs(this.position.y - Water.HEIGHT) < ESCAPE_RADIUS) {
      this.escaping = true;
      PVector randomEscape = PVector.random3D();
      randomEscape.setMag(RADIUS);
      if (randomEscape.z > 0) {
        randomEscape.set(randomEscape.x, -200, randomEscape.z);
      }
      this.target = this.position.copy();
      this.target.add(randomEscape);

      if (abs(this.position.y - Water.HEIGHT) > ESCAPE_RADIUS*1.5) {
        this.escaping = false;
      }
    } else {
      PVector avgVelocity = new PVector(0, 0, 0);
      for (Bird bird : this.birds) {
        float dist = this.position.dist(bird.position);
        if (dist <= RADIUS) {
          PVector weighted = bird.direction.copy();
          weighted.setMag(dist/RADIUS * 5 + RADIUS*0.3);
          //PVector initial = bird.direction.copy();
          //initial.setMag(RADIUS);
          PVector clump = this.position.copy();
          clump.sub(bird.position);
          clump.setMag(RADIUS*0.1);
          //avgVelocity.add(initial);
          avgVelocity.add(weighted);
          avgVelocity.add(clump);
        }
      }
      if (avgVelocity.magSq() > 0.01) {
        avgVelocity.normalize();
        avgVelocity.setMag(RADIUS);
        this.target = this.position.copy();
        this.target.add(avgVelocity);
      }
      
    }

    while (this.target.mag() >= MAX_DIST) {
      this.target.mult(0.5);
      //this.target.add(PVector.random3D());
    }
  }

  void update() {
    this.step += 0.1;

    this.setTarget();

    this.acceleration.set(
      this.acceleration.x + (this.escaping? SPEED*2 : SPEED) * (this.position.x-this.target.x > 0 ? -1 : 1),
      this.acceleration.y + (this.escaping? SPEED*2 : SPEED) * (this.position.y-this.target.y > 0 ? -1 : 1),
      this.acceleration.z + (this.escaping? SPEED*2 : SPEED) * (this.position.z-this.target.z > 0 ? -1 : 1)
    );
    //this.acceleration.limit(1);

    PVector accUpdate = this.acceleration.copy();
    accUpdate.mult(0.1);

    this.direction.add(accUpdate);
    this.direction.limit(1);

    PVector update = this.direction.copy();
    update.mult(0.5);
    this.position.add(update);

    if (this.position.y > Water.HEIGHT) {
      this.position.set(this.position.x, Water.HEIGHT, this.position.z);
    }
  };

  void draw(){
    float theta = atan2(this.direction.y, this.direction.x);
    float phi = -acos(this.direction.z/this.direction.mag());
    translate(this.position.x, this.position.y, this.position.z);
    rotateY(phi);
    rotateZ(theta);

    fill(#EEEEFF);

    drawWing(
      1, false, 0, this.step, this.w, this.h, this.d,
      0, 0-3*sin(this.step), 0 
    );
    drawWing(
      1, true, 0, this.step, -this.w, this.h, this.d,
      0, 0-3*sin(this.step), 0 
    );

    rotateZ(-theta);
    rotateY(-phi);
    translate(-this.position.x, -this.position.y, -this.position.z);

    if (this.SHOW_TARGET) {
      fill(#FF0000);
      beginShape();
      vertex(this.position.x-1, this.position.y, this.position.z);
      vertex(this.position.x+1, this.position.y, this.position.z);
      vertex(this.target.x, this.target.y, this.target.z);
      endShape(CLOSE);
    }
    if (this.SHOW_VELOCITY) {
      fill(#00AA00);
      beginShape();
      vertex(this.position.x-1, this.position.y, this.position.z);
      vertex(this.position.x+1, this.position.y, this.position.z);
      vertex(this.position.x+this.direction.x*20, this.position.y+this.direction.y*20, this.position.z+this.direction.z*20);
      endShape(CLOSE);
    }
  }


  private void drawWing(int level, boolean flip, float initial, float step, float w, float h, float d, float x, float y, float z) {
    translate(x, y, z);
    rotateZ(initial - sin(step)*PI/6 * (flip ? -1. : 1.));

    beginShape();
    vertex(0, 0, -d/2); 
    vertex(0, 0, d/2); 
    vertex(-w/3, 0, d/2*0.75); 
    vertex(-w/3, 0, -d/2*0.75); 
    endShape(CLOSE);

    if (level < 3) {
      drawWing(level+1, flip, 0, step-0.5, w, h, d*0.75, -w/3, 0, 0);
    }

    rotateZ(-(initial - sin(step)*PI/6 * (flip ? -1. : 1.)));
    translate(-x, -y, -z);
  }
}
