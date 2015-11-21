class Sky {
  
  Sky() {
  }
  
  void draw() {
    pointLight(191, 234, 255, -width/2, -height/2, -width/2); 
    pointLight(60, 80, 120, width/2, height/2, width/2);

    // Raise overall light in scene 
    ambientLight(70, 70, 70);
    
    fill(#63C3FF);
    sphere(max(width, height));
  }
}
