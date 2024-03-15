MultilayerPerceptron brain;
// training data for XOR: {input, input, output}
double[][] trainingSet = {
    {1, 0, 1} ,
    {0, 1, 1} ,
    {1, 1, 0} ,
    {0, 0, 0}
};

/*
Next:
- Refactor Matrix class
- Refactor NN algorithms
- better initialization of weights
- more hidden layers
- more activation functions
- MNIST data testing :)
- Try to think of something interesting (and relatively simple) to predict
*/

void setup() {
    size(400, 400);
    brain = new MultilayerPerceptron(2, 15, 1);
    brain.setLearningRate(.2);
}

void draw() {
    background(0);
    
    // each frame, train on a number of random points
    for (int i = 0; i < 50; i++) {
        int trainingIndex = (int)(Math.random() * trainingSet.length);
        double[] inputs = {trainingSet[trainingIndex][0], trainingSet[trainingIndex][1]};
        double[] targets = {trainingSet[trainingIndex][2]};
        brain.train(inputs, targets);
    }
    
    // visualize learning XOR by giving each pixel as inputs
    int resolution = 10;
    int cols = width / resolution;
    int rows = height / resolution;
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            double x1 = (double)i / cols;
            double x2 = (double)j / rows;
            double[] inputs = {x1, x2};
            double[] y = brain.predict(inputs);
            fill((int)(y[0] * 255));
            rect(i * resolution, j * resolution, resolution, resolution);
        }
    } 
}
