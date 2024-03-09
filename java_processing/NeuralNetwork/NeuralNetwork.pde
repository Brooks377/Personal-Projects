Perceptron brain;
Point[] points;

Boolean inTraining;
Boolean eachPoint;
int trainingIndex = 0;

int trainCounter = 0;

void setup() {
    size(1000, 1000);
    
    brain = new Perceptron(0.1, 3);
    points = new Point[800];
    inTraining = false;
    eachPoint = false;
    
    for (int i = 0; i < points.length; i++) {
        points[i] = new Point();
    }
}

void draw() {
    background(255);
    stroke(0);
    
    // draw line that is reference for training    
    Point p1 = new Point( -1, f( -1));
    Point p2 = new Point(1, f(1));
    line(p1.pixelX(), p1.pixelY(), p2.pixelX(), p2.pixelY());
    
    // draw what the perceptron THINKS the reference line is by guessing
    Point p3 = new Point( -1, brain.guessY( -1));
    Point p4 = new Point(1, brain.guessY(1));
    line(p3.pixelX(), p3.pixelY(), p4.pixelX(), p4.pixelY());
    
    
    // DEBUG
    //println(brain.weights);
    //println(trainCounter);
    
    for (Point pt : points) {
        // show training points
        pt.show();
        
        // each point will help train perceptron
        float[] inputs = {pt.x, pt.y, pt.bias};
        int target = pt.label;
        
        // indicate perceptron's current guess
        int guess = brain.guess(inputs);
        if (guess == target) {
            fill(0, 255, 0);
        } else {
            fill(255, 0, 0);
        }
        noStroke();
        circle(pt.pixelX(), pt.pixelY(), 10);
        
        if (inTraining) { // train on all points each frame
            brain.train(inputs, target);
            trainCounter++;
        }
    }
    
    if (eachPoint) { // train one point per frame (demo only, too slow)
        Point training = points[trainingIndex++];
        float[] inputs = {training.x, training.y, training.bias};
        int target = training.label;
        brain.train(inputs, target);
        trainCounter++;
        if (trainingIndex == points.length) {
            trainingIndex = 0;
        }
    }
}

// train on every current training point on mouseclick
void mousePressed() {
    // for each point in the training data
    for (Point pt : points) {
        // send in each point as inputs for training
        float[] inputs = {pt.x, pt.y, pt.bias};
        int target = pt.label;
        brain.train(inputs, target);
        trainCounter++;
    }
}

void keyPressed() {
    if (key == 't') {
        inTraining = !inTraining;
    } else if (key == 'e') {
        eachPoint = !eachPoint;
    }
}
