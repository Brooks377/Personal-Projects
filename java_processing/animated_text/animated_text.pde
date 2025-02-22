PFont font;
PShape shape;

ArrayList<ArrayList<PVector>> characters;
ArrayList<ArrayList<Particle>> particles;

void setup() {
    background(0);
    frameRate(30);
    size(900, 500);
    font = createFont("Times New Roman", 50, true);
    textFont(font);
    textSize(128);
    fill(255);
    noStroke();
    String message = "Harry has the                         BIG GAY";
    
    characters = new ArrayList<>();
    particles = new ArrayList<>();
    
    
    for (int i = 0; i < message.length(); i++) {
        ArrayList<PVector> edgeVerticies = new ArrayList<>();
        shape = font.getShape(message.charAt(i));
        
        // find the points along the edges of each character
        for (int j = 0; j < shape.getVertexCount(); j++) {
            edgeVerticies.add(shape.getVertex(j));
        }
        
        characters.add(edgeVerticies);   
    }

    // save character vertex positions
    saveCharacters();
    
}

void draw() {
    background(0);
    printCharacters();

}

void printCharacters() {
    for (ArrayList<Particle> letter : particles) {
        beginShape();
        for (Particle point : letter) {
            vertex(point.pos.x, point.pos.y);
            point.update();
            point.behavoirs();
        }
        endShape();
    }
}

void saveCharacters() {
    strokeWeight(2);
    noFill();
    stroke(255);
    int XcharOffset = 0;
    int YcharOffset = 0;
    
    for (int i = 0; i < characters.size(); i++) {
        ArrayList<Particle> thisLetter = new ArrayList<>();
        particles.add(thisLetter);
        
        float charRightEdge = 0;

        for (PVector v : characters.get(i)) {

            float charX = v.x + 40 + XcharOffset;
            float charY = v.y + 200 + YcharOffset;
            PVector particlePos = new PVector(charX, charY);
            Particle point = new Particle(particlePos);
            particles.get(i).add(point);
            
            if (v.x > charRightEdge) {
                charRightEdge = v.x;
            }
            
        }
        
        // acount for spaces
        if (i == 4 || i == 8 || i == 41) {
            XcharOffset += 35;
        }
        
        // acount for new lines
        if (i == 20) {
            YcharOffset = 175;
            XcharOffset = 0;
        }
        
        XcharOffset += charRightEdge + 10;
    }
}
