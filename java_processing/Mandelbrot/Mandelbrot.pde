PVector startingPoint;
PVector complexStart;
PVector additivePoint;
PVector complexAdditive;
ArrayList<PVector> drawPoints; // in complex form
color[] storePixels;

int linesNum;
int drawIndex;
float scaleVal;
boolean MBactive;

// TODO: allow zooming mode

void setup() {
    size(1000, 1000);
    colorMode(HSB);
    frameRate(30);
    
    // data members
    startingPoint = new PVector(0, 0);
    complexStart = new PVector(0, 0);
    additivePoint = new PVector(0, 0);
    complexAdditive = new PVector(0, 0);
    drawPoints = new ArrayList<>();
    storePixels = new color[(width * height)];
    
    linesNum = 100;
    scaleVal = 2.5;
    drawIndex = 0;
    MBactive = false;
}

void draw() {
    // set up axes
    background(0);
    translate(width / 2, height / 2); // center axes
    scale(scaleVal);
    
    if (MBactive) {
        for (int i = 0; i < (height * width); i++) {
            pixels[i] = storePixels[i];
        }
        updatePixels();
    }
    
    stroke(255);
    line(0, height, 0, -height); // y-axis
    line(width, 0, -width, 0); // x-axis

    // add axes labels
    if (MBactive) {
        fill(0);
    }
    text("i", 6, -96);
    line(-3, -100, 3, -100);
    text("-i", 6, 105);
    line(-3, 100, 3, 100);

    text("1", 97, 12);
    line(100, -3, 100, 3);
    if (MBactive) {
        fill(255);
    }
    text("-1", -103, 12);
    line(-100, -3, -100, 3);
    
    // ----------------------------------------
    // SOME DEBUG STUFF
    // println(startingPoint);
    // println(complexStart.x + " + " + complexStart.y + "i");
    // println(drawPoints);
    // println(drawPoints.size());
    // println(additivePoint);
    // println(mouseX, mouseY);
    // ----------------------------------------
    
    // input point from where you click
    drawPoints = new ArrayList<>();
    drawPoints.add(complexStart);
    
    // create the rest of the list with recursive method
    drawIndex = 0;
    fillDrawList(complexStart, complexAdditive);
    
    // if holding shift when clicking, set the additive C value
    if (keyPressed && mousePressed) {
        if (key == CODED) {
            if (keyCode == SHIFT) {
                additivePoint = new PVector((mouseX - 500) / scaleVal,( -(mouseY - 500)) / scaleVal);
                if (additivePoint.x > - 1.5 && additivePoint.x < 1.5) {
                    additivePoint.x = 0;
                }
                if (additivePoint.y > - 1.5 && additivePoint.y < 1.5) {
                    additivePoint.y = 0;
                }
                complexAdditive = mapAxesToComplex(additivePoint);
            }
            if (keyCode == CONTROL) {
                startingPoint = new PVector((mouseX - 500) / scaleVal,( -(mouseY - 500)) / scaleVal);
                if (startingPoint.x > - 5 && startingPoint.x < 5) {
                    startingPoint.x = 0;
                }
                if (startingPoint.y > - 5 && startingPoint.y < 5) {
                    startingPoint.y = 0;
                }
                complexStart = mapAxesToComplex(startingPoint);
            }
        }
    } else if (keyPressed) {
        // paints MB when shift + 'M' are held down
        if (key == 'M') {
            paintMBSet();
        }
    }
    fill(220, 170, 0);
    point(additivePoint.x, -additivePoint.y);
    
    noFill();
    circle(0, 0, 400);
    
    // draw line from startingPoint to squared result in complex plane
    drawLines(drawPoints);
    
    // show additive amount and starting position
    fill(255);
    scale(.8);
    text(String.format("Start: %.3f %.3fi", complexStart.x, complexStart.y), 150, 230);
    text(String.format("Add:   %.3f %.3fi", complexAdditive.x, complexAdditive.y), 150, 240);
    
}

void keyPressed() {
    if (key == 'R') {
        loop();
    }

    if (key == 'C') {
        MBactive = false;
    }
}

public void paintMBSet() {
    MBactive = true;
    float maxMag = 2.0;
    int maxRecursions = 30;
    loadPixels();
    for (int i = 0; i < (width * height); i++) {
        PVector c = convertPixeltoComplex(i);
        // each pixel index is a complex number
        // test that complex number for tend to inf
        color pointColor = color(0, 0, 0);
        PVector z = new PVector(0, 0);
        int j = 0;
        for (j = 0; j < maxRecursions; j++) {
            z = complexMultiply(z, z);
            z = complexAdd(z, c);
            
            if (mag(z.x, z.y) > maxMag) {
                break;
            }
        }
        if (j == maxRecursions) {
            pixels[i] = pointColor;
        } else {
            pixels[i] = color((map(j, 0, maxRecursions, 20, 255)), 255, 255);
        }
        storePixels[i] = pixels[i];
    }
    updatePixels();
    noLoop();
}

public PVector convertPixeltoComplex(int i) {
    int dim = 2;
    int row = i % 1000;
    int col = i / 1000;
    float a = -dim + (((dim + dim) / 1000.0) * row);
    float b = dim - (((dim + dim) / 1000.0) * col);
    PVector complexOutput = new PVector(a, b);
    return complexOutput;
}

public PVector mapAxesToComplex(PVector p) {
    return new PVector(p.x / 100, p.y / 100);
}

public PVector mapComplexToAxes(PVector p) {
    return new PVector(p.x * 100, -p.y * 100);
}

public PVector complexAdd(PVector p1, PVector p2) {
    float newX = (p1.x + p2.x);
    float newY = (p1.y + p2.y);
    return new PVector(newX, newY);
}

public PVector complexMultiply(PVector p1, PVector p2) {
    float newX = (p1.x * p2.x) - (p1.y * p2.y);
    float newY = (p1.x * p2.y) + (p1.y * p2.x);
    return new PVector(newX, newY);
}

public void fillDrawList(PVector start, PVector additive) {
    if (drawIndex >= linesNum) {
        return;
    } else {
        PVector nextPoint = complexMultiply(start, start);
        nextPoint = complexAdd(nextPoint, additive);
        drawPoints.add(nextPoint);
        drawIndex++;
        fillDrawList(nextPoint, additive);
    }
}

public void drawLines(ArrayList<PVector> list) {
    float hue = 0;
    for (int i = 0; i < list.size() - 1; i++) {
        // convert the points to axes locations and draw lines
        PVector point1 = mapComplexToAxes(list.get(i));
        PVector point2 = mapComplexToAxes(list.get(i + 1));
        
        hue += 10;
        fill(hue, 255, 255);
        circle(point1.x, point1.y, 2);
        stroke(255, 100);
        line(point1.x, point1.y,point2.x, point2.y);
    }
}