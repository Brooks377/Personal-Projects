// globals
public float time;
public float speed;
public int maximumWaves;
public ArrayList<Float> wave;
String menu;
String settings;
String stats;
char userChoice;

// user-defined classes
SquareWave square;
SawtoothWave sawtooth;
TriangularWave triangle;

void setup() {
    size(800, 600);
    time = 0; // starting angle
    speed =.04;
    maximumWaves = 3;
    wave = new ArrayList<>();
    menu = "Menu\n - Shift + 1 = Square Wave\n - Shift + 2 = Sawtooth Wave\n - Shift + 3 = Triangular Wave\n - Shift + Q = Stop current model";
    settings = "Settings\n - Down Arrow = Reduce amount of additive waves\n - Up Arrow = Increase amount of additive waves\n - Right Arrow = Increase speed\n - Left Arrow = Decrease speed\n";
    userChoice = 'Q';
    
    // wave class to find wave value
    square = new SquareWave(maximumWaves);
    sawtooth = new SawtoothWave(maximumWaves);
    triangle = new TriangularWave(maximumWaves);
}

void draw() {
    stats = String.format("# of Waves: %d\nSpeed: %f", maximumWaves, speed);
    background(0);
    text(menu, 20, 20);
    text(settings, 500, 20);
    text(stats, 300, 50);
    translate(200, 300);
    
    // select which series to visualize
    if (keyPressed) {
        switch(keyCode) {
            case '1':
                userChoice = '1';
                wave = new ArrayList<>();
                break;
            case '2':
                userChoice = '2';
                wave = new ArrayList<>();
                break;
            case '3':
                userChoice = '3';
                wave = new ArrayList<>();
                break;
            case 'Q':
                userChoice = 'Q';
                wave = new ArrayList<>();
                break;
            // select maxWaves & speed
            case RIGHT:
                speed +=.0025;
                break;
            case LEFT:
                speed -=.0025;
                break;
            case UP:
                maximumWaves += 1;
                square = new SquareWave(maximumWaves);
                sawtooth = new SawtoothWave(maximumWaves);
                triangle = new TriangularWave(maximumWaves);
                break;
            case DOWN:
                maximumWaves -= 1;
                square = new SquareWave(maximumWaves);
                sawtooth = new SawtoothWave(maximumWaves);
                triangle = new TriangularWave(maximumWaves);
                break;
        }
    }
    
    // calculate wave array depending on user's choice
    float y = 0;
    if (userChoice == '1') {
        y = square.findWaveValue();
    } else if (userChoice == '2') {
        y = sawtooth.findWaveValue();
    } else if (userChoice == '3') {
        y = triangle.findWaveValue();
    }
    
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

