PVector startingPoint;
PVector complexStart;
PVector additivePoint;
PVector complexAdditive;
ArrayList<PVector> drawPoints; // in complex form
PVector zoomPointAxes;
PVector zoomPoint;

int linesNum;
int drawIndex;
float scaleVal;
boolean MBactive;
boolean zoomActive;
boolean axesOn;

float beforeZoom, afterZoom, zoomDist;
PVector[] scaleStore;

// TODO: Increase performance
// TODO: Increase allowed zoom distance (currently gets pixelated)
// TODO: for the future: julia sets or set mapping

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
    zoomPointAxes = new PVector();
    zoomPoint = new PVector();
    scaleStore = new PVector[2];
    for (int i = 0; i < scaleStore.length; i++) {
        scaleStore[i] = new PVector();
    }
    
    linesNum = 100;
    scaleVal = 2.5;
    drawIndex = 0;
    MBactive = false;
    zoomActive = false;
    axesOn = true;
    beforeZoom = 0.0;
    afterZoom = 0.0;
    zoomDist = 0;
}

void draw() {
    // set up axes
    background(0);
    translate(width / 2, height / 2); // center axes
    scale(scaleVal);
    
    // paint Mandelbrot set
    if (MBactive) {
        paintMBSet();
    }
    
    fill(255);
    if (axesOn) {
        
        // axes
        stroke(255);
        line(0, height, 0, -height); // y-axis
        line(width, 0, -width, 0); // x-axis
        
        // boundary of no return
        noFill();
        circle(0, 0, 400);
        
        // complex axis labels
        text("i", 6, -96);
        line( -3, -100, 3, -100);
        text("-i", 6, 105);
        line( -3, 100, 3, 100);
        
        // real axis labels
        text("1", 97, 12);
        line(100, -3, 100, 3);
        text("-1", -103, 12);
        line( -100, -3, -100, 3);
    }
    
    // ----------------------------------------
    // SOME DEBUG STUFF
    // println(startingPoint);
    // println(complexStart.x + " + " + complexStart.y + "i");
    // println(drawPoints);
    // println(drawPoints.size());
    // println(additivePoint);
    // println(mouseX, mouseY);
    // println(zoomPoint);
    // println(zoomDist);
    // ----------------------------------------
    
    // input point from where you click
    drawPoints = new ArrayList<>();
    drawPoints.add(complexStart);
    
    // create the rest of the list with recursive method
    drawIndex = 0;
    fillDrawList(complexStart, complexAdditive);
    
    // user input block
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
            MBactive = true;
        }
        
        if (key == 'Z') {
            zoomActive = true;
            zoomPointAxes = new PVector((mouseX - 500) / scaleVal,( -(mouseY - 500)) / scaleVal);
            zoomPoint = mapAxesToComplex(zoomPointAxes);
            
        }
        
        if (key == '-') {
            if (zoomDist > 0) {
                zoomDist -= 1;
            }
        }
        
        if (key == '=') {
            zoomDist += 1;
        }
        
        if (key == CODED) {
            float incValX = (scaleStore[1].x - scaleStore[0].x) / 100;
            float incValY = (scaleStore[0].y - scaleStore[1].y) / 100;
            switch(keyCode) {
                case UP:
                    zoomPoint.y += incValY;
                    break;
                case DOWN:
                    zoomPoint.y -= incValY;
                    break;
                case RIGHT:
                    zoomPoint.x += incValX;
                    break;
                case LEFT:
                    zoomPoint.x -= incValX;
                    break;
            }
        }
    }
    
    fill(220, 170, 0);
    point(additivePoint.x, -additivePoint.y);
    
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
        zoomActive = false;
        zoomPoint = new PVector();
        zoomDist = 0;
    }
    
    if (key == 'X') {
        axesOn = !axesOn;
    }
}

public void paintMBSet() {
    float maxMag = 2.0;
    int maxRecursions = 100;
    loadPixels();
    for (int i = 0; i < (width * height); i++) {
        PVector c = convertPixeltoComplex(i);
        // each pixel index is a complex number
        // test that complex number for tend to inf
        color pointColor = color(0, 0, 0);
        PVector z = new PVector(0, 0);
        
        if (i == 0) {
            scaleStore[0] = new PVector(c.x, c.y);
        } else if (i == 999999) {
            scaleStore[1] = new PVector(c.x, c.y);
        }
        
        int j = 0;
        for (j = 0; j < maxRecursions; j++) {
            z = complexMultiply(z, z);
            z = complexAdd(z, c);
            
            if (((z.x * z.x) + (z.y * z.y)) > (maxMag * maxMag)) {
                break;
            }
        }
        if (j == maxRecursions) {
            pixels[i] = pointColor;
        } else {
            pixels[i] = color((map(j, 0, maxRecursions, 10, 255)), 255, 255);
        }
    }
    updatePixels();
}

public PVector convertPixeltoComplex(int i) {
    if (!zoomActive) {
        zoomPoint.set(0, 0);
    }
    float dim = 2.0;
    if (zoomDist > 0) {
        // start at 2 and have it get closer and closer to zero (zD -> [1, 1000])
        float zoomFactor = pow(2, zoomDist);
        dim /= zoomFactor;
    }
    int row = i % 1000;
    int col = i / 1000;
    float a = zoomPoint.x + ( -dim) + (((dim + dim) / 1000.0) * row);
    float b = zoomPoint.y + dim - (((dim + dim) / 1000.0) * col);
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