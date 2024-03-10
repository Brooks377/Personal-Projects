public class MultilayerPerceptron  {
    
    int numInput, numHidden, numOutput;
    Matrix weights_ih, bias_h, weights_ho, bias_o;
    double learningRate;
    
    MultilayerPerceptron(int nI, int nH, int nO) {
        numInput = nI;
        numHidden = nH;
        numOutput = nO;
        
        weights_ih = new Matrix(numHidden, numInput);
        weights_ho = new Matrix(numOutput, numHidden);
        weights_ih.randomize( -1, 1, false);
        weights_ho.randomize( -1, 1, false);
        
        bias_h = new Matrix(numHidden, 1);
        bias_o = new Matrix(numOutput, 1);
        bias_h.randomize( -1, 1, false);
        bias_o.randomize( -1, 1, false);
        
        learningRate = 0.1;
    }
    
    void setLearningRate(double rate) {
        this.learningRate = rate;
    }
    
    // predict using feedforward with sigmoid activation
    double[] predict(double[] inputArray) {
        
        // input length (rows) much match columns of weights for multiply to work
        // generate hidden layer output
        Matrix inputs = Matrix.fromArray(inputArray);
        Matrix hidden = Matrix.multiply(weights_ih, inputs);
        hidden = Matrix.add(hidden, bias_h);
        // TODO: find way to abstract the functions passing into map
        hidden.map(x -> 1 / (1 + Math.exp( -x))); // sigmoid activation function
        
        // generate output layer output
        Matrix output = Matrix.multiply(weights_ho, hidden);
        output = Matrix.add(output, bias_o);
        output.map(x -> 1 / (1 + Math.exp( -x))); // sigmoid activation function
        
        return output.toArray();
    }
    
    // stochastic gradient descent training algorithm
    void train(double[] inputArray, double[] targetArray) {
        // input length (rows) much match columns of weights for multiply to work
        // generate hidden layer output
        Matrix inputs = Matrix.fromArray(inputArray);
        Matrix hidden = Matrix.multiply(weights_ih, inputs);
        hidden = Matrix.add(hidden, bias_h);
        hidden.map(x -> 1 / (1 + Math.exp( -x))); // sigmoid activation function
        
        // generate output layer output
        Matrix outputs = Matrix.multiply(weights_ho, hidden);
        outputs = Matrix.add(outputs, bias_o);
        outputs.map(x -> 1 / (1 + Math.exp( -x))); // sigmoid activation function
        
        // convert targets to a 1-col matrix
        Matrix targets = Matrix.fromArray(targetArray);
        
        // calculate the output layer errors (targets - outputs)
        Matrix output_errors = Matrix.subtract(targets, outputs);
        
        // get gradient for output layer (derivative of sigmoid with respect to error)
        // derivative of sigmoid: f'(x) = f(x) * (1 - f(x))
        // sigmoid already applied to output layer, so its x * (1 - x)
        Matrix gradients_o = outputs.clone();
        gradients_o.map(x -> x * (1 - x));
        gradients_o = Matrix.elementProduct(gradients_o, output_errors); // apply gradient
        gradients_o.scalarMult(learningRate); // scalar mult with LR
        
        
        // calculate hidden->output deltas
        Matrix hidden_t = Matrix.transpose(hidden);
        Matrix weights_ho_deltas = Matrix.multiply(gradients_o, hidden_t);
        weights_ho = Matrix.add(weights_ho, weights_ho_deltas); // apply delta
        bias_o = Matrix.add(bias_o, gradients_o); // adjust bias
        
        // calculate the hidden layer errors
        Matrix weights_ho_t = Matrix.transpose(weights_ho);
        Matrix hidden_errors = Matrix.multiply(weights_ho_t, output_errors);
        
        // get gradient for hidden layer
        Matrix gradients_h = hidden.clone();
        gradients_h.map(x -> x * (1 - x)); // explained in line 63
        gradients_h = Matrix.elementProduct(gradients_h, hidden_errors);
        gradients_h.scalarMult(learningRate);
        
        // calculate input->hidden deltas
        Matrix inputs_t = Matrix.transpose(inputs);
        Matrix weights_ih_deltas = Matrix.multiply(gradients_h, inputs_t);
        weights_ih = Matrix.add(weights_ih, weights_ih_deltas);
        bias_h = Matrix.add(bias_h, gradients_h); // adjust bias
    }
}
