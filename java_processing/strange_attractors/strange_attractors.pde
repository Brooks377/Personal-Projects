Lorenz lorenz;
Rossler rossler;
Henon henon;

public boolean modelRunning;
char userChoice;
boolean initialmenu;

void setup() {
    size(800, 600, P3D);
    colorMode(HSB);
    
    // 3 different attractors with given constants
    lorenz = new Lorenz(10, 28,(8 / 3));
    lorenz.setXYZ(.01, 0, 0);
    
    rossler = new Rossler(.1,.1, 14);
    rossler.setXYZ(.01, 0, 0);
    
    henon = new Henon(1.4,.3);
    henon.setXYZ(1, 1, 0);
    
    modelRunning = false;
    userChoice = '\u0000';
    initialmenu = true;
}

void draw() {
    background(0);
    
    // camera movement
    float xView = map(mouseX, 0, width, 0, width * 1.5);
    camera(xView, mouseY,(height / 2) / tan(PI / 6), width / 2, height / 2, 0, 0, 1, 0);
    
    // user deciding which model to run
    if (keyPressed && !modelRunning && keyCode != userChoice) {
        switch(keyCode) {
            case 'R':
                userChoice = 'R';
                modelRunning = true;
                initialmenu = false;
                break;
            case 'L':
                userChoice = 'L';
                modelRunning = true;
                initialmenu = false;
                break;
            case 'H':
                userChoice = 'H';
                modelRunning = true;
                initialmenu = false;
                break;
        }
    }
    
    // emergency shut-off and also menu
    if (keyPressed) {
        if (keyCode == 'Q') {
            userChoice = 'Q';
            modelRunning = false;
            initialmenu = true;
        }
    }
    
    // reset models when running a new one
    if (rossler.points.size() > 1 && (userChoice == 'L' || userChoice == 'H' || userChoice == 'Q')) {
        rossler.points = new ArrayList<PVector>();
    }
    if (lorenz.points.size() > 1 && (userChoice == 'R' || userChoice == 'H' || userChoice == 'Q')) {
        lorenz.points = new ArrayList<PVector>();
    }
    if (henon.points.size() > 1 && (userChoice == 'R' || userChoice == 'L' || userChoice == 'Q')) {
        henon.points = new ArrayList<PVector>();
    }
    
    // running the model based on userChoice
    switch(userChoice) {
        case 'R':
            rossler.run();
            break;
        case 'L':
            lorenz.run();
            break;
        case 'H':
            henon.run();
            break;
    }
    
    // display a small menu
    drawMenuText();
}

void drawMenuText() {
    if (initialmenu) {
        PVector menuPos = new PVector(150, height / 2 - 100);
        ortho();
        fill(255);
        textSize(16);
        
        // display menu text
        text("Menu:", menuPos.x + 10, menuPos.y + 10);
        text("Press 'Shift + R' for Rossler  (takes time to get going; let Rossler cook)", menuPos.x + 10, menuPos.y + 30);
        text("Press 'Shift + L' for Lorenz   (the famous Lorenz Attractor)", menuPos.x + 10, menuPos.y + 50);
        text("Press 'Shift + H' for Henon  (plots points on 2D plane)", menuPos.x + 10, menuPos.y + 70);
        text("Press 'Shift + Q' to quit          (end current model and return to this menu)", menuPos.x + 10, menuPos.y + 90);
    }
}


