public class Perceptron {
    //float[] weights = {1, -1}; // "correct" weights
    
    // members
    float[] weights;
    float learningRate;
    
    // constructor
    Perceptron(float learningRate, int nWeights) {
        weights = new float[nWeights];
        this.learningRate = learningRate;
        
        // initial weights random between - 1 and 1
        for (int i = 0; i < weights.length; i++) {
            weights[i] = random( -1, 1);
        }
        
    }
    
    // ouput guess by weighted sum of inputs compared to 0
    int guess(float[] inputs) {
        float sum = 0;
        for (int i = 0; i < weights.length; i++) {
            sum += inputs[i] * weights[i];
        }
        return sign(sum); 
    }
    
    // activation function
    int sign(float n) {
        if (n >= 0) {
            return 1;
        } else {
            return( -1);
        }
    }
    
    void train(float[] inputs, int target) {
        int guess = guess(inputs);
        int error = target - guess;
        
        // adjust all the weights
        for (int i = 0; i < weights.length; i++) {
            weights[i] += error * inputs[i] * learningRate;
        }
    }
    
    // guess for what line is
    float guessY(float x) {
        float w0 = weights[0];
        float w1 = weights[1];
        float w2 = weights[2];
        
        return( -1) * (w2 / w1) - (w0 / w1) * x;
    }
}
