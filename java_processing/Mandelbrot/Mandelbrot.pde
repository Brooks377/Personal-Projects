PVector startingPoint;
PVector complexStart;
ArrayList<PVector> drawPoints; // in complex form

int linesNum;
int drawIndex;

void setup() {
    size(1000, 1000);
    
    // data members
    startingPoint = new PVector(0, 0);
    complexStart = new PVector(0, 0);
    drawPoints = new ArrayList<>();
    linesNum = 30;
    drawIndex = 0;
}

void draw() {
    // set up axes
    background(0);
    translate(width / 2, height / 2); // center axes
    stroke(255);
    line(0, height, 0, -height); // y-axis
    line(width, 0, -width, 0); // x-axis
    
    // println(startingPoint.x, startingPoint.y);
    // println(complexStart.x + " + " + complexStart.y + "i");
    // println(drawPoints);
    println(drawPoints.size());
    
    noFill();
    circle(0, 0, 200);
    // draw line from startingPoint to squared result in complex plane
    text(String.format(complexStart.x + " + " + complexStart.y + "i"), 425, 475);
    drawLines(drawPoints);
}

void mousePressed() {
    // input point from where you click
    drawPoints = new ArrayList<>();
    startingPoint = new PVector(mouseX - 500, -(mouseY - 500));
    // begin drawing list with that position
    complexStart = mapAxesToComplex(startingPoint);
    drawPoints.add(complexStart);
    // create the rest of the list with recursive method
    drawIndex = 0;
    fillDrawList(complexStart);
}

public void fillDrawList(PVector start) {
    if (drawIndex >= linesNum) {
        return;
    } else {
        PVector nextPoint = complexMultiply(start, start);
        drawPoints.add(nextPoint);
        drawIndex++;
        fillDrawList(nextPoint);
    }
}

public PVector mapAxesToComplex(PVector p) {
    return new PVector(p.x / 100, p.y / 100);
}

public PVector mapComplexToAxes(PVector p) {
    return new PVector(p.x * 100, -p.y * 100);
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
        line(point1.x, point1.y,point2.x, point2.y);
    }
}