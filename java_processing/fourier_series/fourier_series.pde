// globals
public float time;
public ArrayList<Float> wave;

// user-defined classes
SquareWave square;

void setup() {
    size(800, 600);
    time = 0; // starting angle
    wave = new ArrayList<>();
    
    // wave class to find wave value
    square = new SquareWave(10);
}

void draw() {
    background(0);
    translate(200, 300);
    
    // calculate the position of the wave based on circle stuff
    float y = square.findWaveValue();
    
    // map last calculated point to wave
    wave.add(y);
    // drawing wave function
    noFill();
    beginShape();
    for (int i = 0; i < wave.size(); i++) {
        vertex(i + 200, wave.get(wave.size() - 1 - i));
    }
    endShape();
    
    // ensure wave function doesn't overload memory
    if (wave.size() > 400) {
        wave.remove(0);
    }
}

