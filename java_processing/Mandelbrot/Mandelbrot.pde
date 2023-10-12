PVector startingPoint;
PVector complexStart;
PVector additivePoint;
PVector complexAdditive;
ArrayList<PVector> drawPoints; // in complex form

int linesNum;
int drawIndex;
float scaleVal;

void setup() {
    size(1000, 1000);
    
    // data members
    startingPoint = new PVector(0, 0);
    complexStart = new PVector(0, 0);
    additivePoint = new PVector(0, 0);
    complexAdditive = new PVector(0, 0);
    drawPoints = new ArrayList<>();
    linesNum = 50;
    scaleVal = 3;
    drawIndex = 0;
}

void draw() {
    // set up axes
    background(0);
    translate(width / 2, height / 2); // center axes
    scale(scaleVal);
    stroke(255);
    line(0, height, 0, -height); // y-axis
    line(width, 0, -width, 0); // x-axis
    
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
    if (keyPressed) {
        if (key == CODED) {
            if (keyCode == SHIFT) {
                additivePoint = new PVector((mouseX - 500) / scaleVal,( -(mouseY - 500)) / scaleVal);
                if (additivePoint.x > -1.5 && additivePoint.x < 1.5) {
                    additivePoint.x = 0;
                }
                if (additivePoint.y > -1.5 && additivePoint.y < 1.5) {
                    additivePoint.y = 0;
                }
                complexAdditive = mapAxesToComplex(additivePoint);
            }
            if (keyCode == CONTROL) {
                startingPoint = new PVector((mouseX - 500) / scaleVal,( -(mouseY - 500)) / scaleVal);
                if (startingPoint.x > -5 && startingPoint.x < 5) {
                    startingPoint.x = 0;
                }
                if (startingPoint.y > -5 && startingPoint.y < 5) {
                    startingPoint.y = 0;
                }
                complexStart = mapAxesToComplex(startingPoint);
            }
            // TODO: mandelbrot set
            // if (keyCode == RETURN) {
            //     paintMBSet();
        // }
        }
    }
    fill(220, 170, 0);
    point(additivePoint.x, -additivePoint.y);
    
    noFill();
    circle(0, 0, 200);
    
    // draw line from startingPoint to squared result in complex plane
    drawLines(drawPoints);
    
    // show additive amount and starting position
    fill(255);
    scale(.8);
    text(String.format("Start: %.3f %.3fi", complexStart.x, complexStart.y), 110, 190);
    text(String.format("Add:   %.3f %.3fi", complexAdditive.x, complexAdditive.y), 110, 200);
}

// void mousePressed() {
//     // input point from where you click
//     drawPoints = new ArrayList<>();
//     startingPoint = new PVector(mouseX - 500, -(mouseY - 500));
//     // begin drawing list with that position
//     complexStart = mapAxesToComplex(startingPoint);
//     drawPoints.add(complexStart);
//     // create the rest of the list with recursive method
//     drawIndex = 0;
//     fillDrawList(complexStart);
// }

// TODO: make this function work
public void paintMBSet() {
    loadPixels();
    color pink = color(255, 102, 204);
    for (int i = 0; i < (width * height); i++) {
        pixels[i] = pink;
        println(i);
    }
    updatePixels();
    noLoop();
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

public void drawLines(ArrayList<PVector> list) {
    for (int i = 0; i < list.size() - 1; i++) {
        // convert the points to axes locations and draw lines
        PVector point1 = mapComplexToAxes(list.get(i));
        PVector point2 = mapComplexToAxes(list.get(i + 1));
        
        fill((i * 6) % 255, 200 - ((i * 5)) % 255, 0);
        circle(point1.x, point1.y, 2);
        stroke(255, 100);
        line(point1.x, point1.y,point2.x, point2.y);
    }
}