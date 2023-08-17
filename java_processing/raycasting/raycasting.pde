ArrayList<Boundary> walls;
Particle source;

int wallAmount = 7;
float xOffset = 0;
float yOffset = 999;

void setup() {
    size(800, 800);
    walls = new ArrayList<>();
    for (int i = 0; i < wallAmount; i++) {
        float x1 = random(width);
        float y1 = random(height);
        float x2 = random(width);
        float y2 = random(height);
        walls.add(0, new Boundary(x1, y1, x2, y2));
    }

    // add boundaries of the GUI
    walls.add(0, new Boundary(0, 0, width, 0));
    walls.add(0, new Boundary(width, 0, width, height));
    walls.add(0, new Boundary(width, height, 0, height));
    walls.add(0, new Boundary(0, height, 0, 0));

    // source that generates rays
    source = new Particle();
}

void draw() {
    background(0);
    
    // show boundaries/walls
    for (Boundary wall : walls) {
        wall.show();
        
    }
    
    // // for mouse movement
    // source.update(mouseX, mouseY);

    // move light source every frame based on random noise
    source.update(noise(xOffset) * width, noise(yOffset) * height);
    xOffset += .005;
    yOffset += .005;


    // show light source
    source.show();
    // create lines that show ray casts
    source.look(walls);
    
}

