// Used for oveall rotation
float angle;

Sky sky = new Sky();
Water water = new Water();
ArrayList<Bird> birds = new ArrayList<Bird>();


void setup() {
  size(640, 360, P3D); 
  pixelDensity(displayDensity());
  background(0); 
  noStroke();
  
  sky = new Sky();

  // Instantiate birds, passing in random vals for size and postion
  for (int i = 0; i < 300; i++){
    birds.add(
      new Bird(
        random(6, 14), random(6, 14), random(2, 4),
        random(-140, 140), random(-140, 40), random(-140, 140)
      )
    );
  }

  for (Bird bird : birds) {
    bird.setBirds(birds);
  }
}

void draw(){
  background(0);  

  translate(width/2, height/2, height/2 - mouseY);

  // Rotate around y and x axes
  rotateY(float(mouseX) / float(width) * 2*PI);

  // Draw scene
  sky.draw();
  water.draw();

  // Draw birds
  for (Bird bird : birds) {
    bird.update();
    bird.draw();
  }
  
  // Used in rotate function calls above
  //angle += 0.05;
}
