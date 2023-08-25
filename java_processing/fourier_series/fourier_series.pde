import java.util.Arrays;

// globals
public float time;
public float speed;
public int maximumWaves;
public ArrayList<Float> pictureX;
public ArrayList<Float> pictureY;
public ArrayList<DiscreteFreq> fourierX; // complex vector, freq, amp, phase
public ArrayList<DiscreteFreq> fourierY; // complex vector, freq, amp, phase
public ArrayList<Float> wave;
public ArrayList<PVector> path;

String menu;
String settings;
String stats;
char userChoice;

// user-defined classes
SquareWave square;
SawtoothWave sawtooth;
TriangularWave triangle;
PictureWave picture;

ArrayList<Integer> testing;

void setup() {
    size(800, 600);
    
    picture = new PictureWave(maximumWaves);
    pictureX = new ArrayList<>();
    pictureY = new ArrayList<>();
    // discrete fourier transform of arbitrary signal
    for (int i = 0; i < 500; i++) {
        float angle = map(i, 0, 199, 0, TWO_PI);
        pictureX.add((200 * noise(angle)) - 100);
        pictureY.add((200 * noise(angle + 1000)) - 100);
    }
    fourierX = picture.dft(pictureX); // peform transform
    fourierY = picture.dft(pictureY); // peform transform
    
    // sort the discrete transforms based on amplitude
    sortFourier(fourierX);
    sortFourier(fourierY);
    
    time = 0; // starting angle
    speed =.04;
    maximumWaves = 3;
    wave = new ArrayList<>();
    path = new ArrayList<>();   // for user-defined path
    menu = "Menu\n - Shift + 1 = Square Wave\n - Shift + 2 = Sawtooth Wave\n - Shift + 3 = Triangular Wave\n - Shift + 4 = DFT to make picture (Default: Random Noise)\n - Shift + 9 = Enter Create Picture Mode (Draw on-screen with mouse click)\n - Shift + Q = Stop current model";
    settings = "Settings\n - Down Arrow = Reduce amount of additive waves\n - Up Arrow = Increase amount of additive waves\n - Right Arrow = Increase speed\n - Left Arrow = Decrease speed\n";
    userChoice = 'Q';
    
    // wave class to find wave value
    square = new SquareWave(maximumWaves);
    sawtooth = new SawtoothWave(maximumWaves);
    triangle = new TriangularWave(maximumWaves);
    
    testing = new ArrayList<>();
}

void draw() {
    background(0);
    stats = String.format("# of Waves: %d\nSpeed: %f", maximumWaves, speed);
    text(stats, 250, 20);
    text(menu, 20, 20);
    if (userChoice != '4') {
        text(settings, 500, 20);
    }
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
            case '4':
                userChoice = '4';
                path = new ArrayList<>();
                time = 0;
                break;
            case '9':
                userChoice = '9';
                pictureX = new ArrayList<>();
                pictureY = new ArrayList<>();
                path = new ArrayList<>();
                break;
            case 'Q':
                userChoice = 'Q';
                wave = new ArrayList<>();
                path = new ArrayList<>();
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
        mapAndDraw(y);
    } else if (userChoice == '2') {
        y = sawtooth.findWaveValue();
        mapAndDraw(y);
    } else if (userChoice == '3') {
        y = triangle.findWaveValue();
        mapAndDraw(y);
    } else if (userChoice == '4') {
        PVector vx = picture.findWaveValue(300, -185, 0, fourierX);
        PVector vy = picture.findWaveValue( -50, 100, HALF_PI, fourierY);
        PVector vXY = new PVector(vx.x, vy.y);
        mapAndDraw(vXY);
        // draw lines from circles to wave/picture/path
        line(vx.x, vx.y, vXY.x, vXY.y);
        line(vy.x, vy.y, vXY.x, vXY.y);
    } else if (userChoice == '9') {
        // FIXME: valid draw box
        line(300, -300, 300, height - 300);
        line( - 200, 200, width - 200, 200);
        line( - 200, -190, width - 200, -190);
        text("Draw in this box:", -200, -175);
        
        // draw preview
        noFill();
        stroke(255);
        strokeWeight(1);
        beginShape();
        for (int i = 0; i < pictureX.size(); i++) {
            vertex(pictureX.get(i), pictureY.get(i));
        }
        endShape();
        // draw mode
        if (mousePressed) {
            float mousePosX = mouseX - 200;
            pictureX.add(mousePosX);
            float mousePosY = mouseY - 300;
            pictureY.add(mousePosY);
        } else {
            fourierX = picture.dft(pictureX); // peform transform
            fourierY = picture.dft(pictureY); // peform transform
            
            // sort the discrete transforms based on amplitude
            sortFourier(fourierX);
            sortFourier(fourierY);
        }
    }
    
    // ensure wave function doesn't overload memory
    if (wave.size() > 400) {
        wave.remove(0);
    }
}

void mapAndDraw(float point) {
    // map last calculated point to wave
    wave.add(point);
    // drawing wave function
    noFill();
    beginShape();
    for (int i = 0; i < wave.size(); i++) {
        vertex(i + 200, wave.get(wave.size() - 1 - i));
    }
    endShape();
}

void mapAndDraw(PVector point) {
    // map last calculated point to wave
    path.add(point);
    // drawing wave function
    noFill();
    beginShape();
    for (int i = 1; i < path.size(); i++) {
        vertex(path.get(i).x, path.get(i).y);
    }
    endShape();
}

void sortFourier(ArrayList<DiscreteFreq> fourier) {
    for (int i = 1; i < fourier.size(); i++) {
        DiscreteFreq insertValue = fourier.get(i);
        int j = i - 1;
        while(j >= 0 && fourier.get(j).amp < insertValue.amp) {
            fourier.set(j + 1,  fourier.get(j)); // shift right
            j--; // next element
        }
        fourier.set(j + 1, insertValue); // insert back into list
    }
}