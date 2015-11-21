class Water {
  final static float HEIGHT = 90;

  Water() {}

  void draw() {
    fill(#0B6BBA);
    beginShape();
    vertex(-width, Water.HEIGHT, -width);
    vertex(-width, Water.HEIGHT, width);
    vertex(width, Water.HEIGHT, width);
    vertex(width, Water.HEIGHT, -width);
    endShape(CLOSE);
  }
}
