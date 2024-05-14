ArrayList<PVector> points;
float xAxisLen;
float yAxisLen;
float translateAmount;

float movementParam;
float timestep;

float max, min, avg, reference; // max and min are "swapped" b/c of processing upsidedown coords
int numPointsTotal;

void setup() {
    size(1300, 600);
    background(0);
    frameRate(20); // determines speed of walk
    xAxisLen = width;
    yAxisLen = height / 2;
    translateAmount = yAxisLen; // start with x-axis centered
    points = new ArrayList<>();
    PVector startPoint = new PVector(0, 0);
    points.add(startPoint);
    
    movementParam = 10;
    timestep = 5;
    
    max = 0;
    min = 0;
    avg = 0;
    numPointsTotal = 0;
    reference = 0;
}

void draw() {
    // clear screen and translate
    background(0);    
    translate(0, translateAmount); // center-left origin
    
    // xy-axis
    stroke(255);
    line(0, -yAxisLen, 0, yAxisLen); // y-axis (w/ extra length)
    line(0, 0, xAxisLen, 0); // x-axis
    
    // for each frame create a new point at X-degrees up or down based on coin flip
    addPoint(points);
    drawPath(points);
    
    // wrap around x-axis condition; start at last height
    PVector lastPoint = points.get(points.size() - 1);
    if (lastPoint.x >= xAxisLen)
    {
        float lastHeight = lastPoint.y;
        points.clear();
        points.add(new PVector(0, lastHeight));
    }
    
    // wrap around y-axis condition; translate up/down
    if (abs(lastPoint.y) >= (yAxisLen + abs(reference)))
    {
        if (lastPoint.y > 0)
            reference -= 100;
        else
            reference += 100;
    }
    
    // data displays and axis reference
    text(String.valueOf( -reference), 15, 20);
    text(String.format("Max: %.1f", -max), xAxisLen - 70, -yAxisLen + 20);
    text(String.format("Min: %.1f", -min), xAxisLen - 70, -yAxisLen + 35);
    text(String.format("Avg: %.3f", -avg), xAxisLen - 70, -yAxisLen + 50);
}

void addPoint(ArrayList<PVector> points) {
    PVector lastPoint = points.get(points.size() - 1);
    PVector newPoint = new PVector();
    
    // int choice = int(random(0, 2)); // 0 : down, 1 : up
    int choice = 1;
    if (choice == 0) // down
    {
        newPoint = new PVector(lastPoint.x + timestep, lastPoint.y - movementParam);
    }
    else if (choice == 1) // up
    {
        newPoint = new PVector(lastPoint.x + timestep, lastPoint.y + movementParam);
    }
    points.add(newPoint);
    
    if (newPoint.y > min)
    {
        min = newPoint.y;
    }
    if (newPoint.y < max)
    {
        max = newPoint.y;
    }
    
    // new avg
    numPointsTotal++;
    avg = (avg + newPoint.y) / numPointsTotal;
}

void drawPath(ArrayList<PVector> points) {
    stroke(255, 0, 0); // red lines
    for (int i = 0; i < points.size() - 1; i++) 
    {
        PVector thisPoint = points.get(i);
        PVector nextPoint = points.get(i + 1);
        line(thisPoint.x, thisPoint.y, nextPoint.x, nextPoint.y);
    }
}


