class Bird {

  // Properties
  float w, h, d;
  PVector position, target, direction, acceleration;

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

  void update() {
    this.step += 0.1;

    this.acceleration.set(
      this.acceleration.x + (this.direction.x*this.acceleration.x > 0 ? 0.1 : 0.05) * (this.position.x-this.target.x > 0 ? -1 : 1),
      this.acceleration.y + (this.direction.y*this.acceleration.y > 0 ? 0.1 : 0.05) * (this.position.y-this.target.y > 0 ? -1 : 1),
      this.acceleration.z + (this.direction.z*this.acceleration.z > 0 ? 0.1 : 0.05) * (this.position.z-this.target.z > 0 ? -1 : 1)
    );
    //this.acceleration.limit(1);

    PVector accUpdate = this.acceleration.copy();
    accUpdate.mult(0.1);

    this.direction.add(accUpdate);
    this.direction.limit(1);

    PVector update = this.direction.copy();
    update.mult(0.5);
    this.position.add(update);
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

    //fill(#FF0000);
    //beginShape();
    //vertex(this.position.x-1, this.position.y, this.position.z);
    //vertex(this.position.x+1, this.position.y, this.position.z);
    //vertex(this.target.x, this.target.y, this.target.z);
    //endShape(CLOSE);
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
