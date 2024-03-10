// for use in map function (allows function param)
@FunctionalInterface
interface DoubleUnaryOperator {
    double apply(double x);
}

public static class Matrix {
    
    int rows, cols;
    double[][] data;
    
    public Matrix(int rows, int cols) {
        this.rows = rows;
        this.cols = cols;
        this.data = new double[rows][cols];
        
        // initialize data to zeros
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] = 0;
            }
        }
    }
    
    // method to apply a lambda function to each element of the matrix
    public void map(DoubleUnaryOperator operator) {
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] = operator.apply(data[i][j]);
            }
        }
    }
    
    // initialize with random values in given range
    void randomize(int start, int end, boolean integers) {
        int range = end - start;
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (integers) {
                    data[i][j] = (int)(Math.random() * (range + 1)) + start;
                } else {
                    data[i][j] = (Math.random() * range) + start;
                }
            }
        }
    }
    
    // transposes matrix (changes matrix object)
    void transpose() {
        Matrix transposed = new Matrix(cols, rows);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                transposed.data[j][i] = this.data[i][j];
            }
        }
        this.data = transposed.data;
        this.rows = transposed.rows;
        this.cols = transposed.cols;
    }
    
    // transposes matrix (returns new matrix object)
    static Matrix transpose(Matrix A) {
        Matrix transposed = new Matrix(A.cols, A.rows);
        for (int i = 0; i < A.rows; i++) {
            for (int j = 0; j < A.cols; j++) {
                transposed.data[j][i] = A.data[i][j];
            }
        }
        return transposed;
    }
    
    // scalar multiply (changes matrix object)
    void scalarMult(double a) {
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] *= a;
            }
        }
    }
    
    // actual matrix product (returns new Matrix object)
    static Matrix multiply(Matrix A, Matrix B) {
        // number of A's cols must equal B's rows
        if (A.cols != B.rows) {
            println("Columns of left matrix must equal rows of right matrix");
            return null;
        }
        
        double[][] a = A.data;
        double[][] b = B.data;
        Matrix output = new Matrix(A.rows, B.cols);
        for (int i = 0; i < output.rows; i++) {
            for (int j = 0; j < output.cols; j++) {
                double sum = 0;
                for (int k = 0; k < A.cols; k++) {
                    sum += a[i][k] * b[k][j];
                }
                output.data[i][j] = sum;
            }
        }
        return output;
    }
    
    // matrix element-wise multiply (hadamard product) (returns new Matrix object)
    static Matrix elementProduct(Matrix A, Matrix B) {
        if (A.rows != B.rows || A.cols != B.cols) {
            println("Matrices must have same dimensions");
            return null;
        }
        
        Matrix output = new Matrix(A.rows, A.cols);
        for (int i = 0; i < output.rows; i++) {
            for (int j = 0; j < output.cols; j++) {
                output.data[i][j] = A.data[i][j] * B.data[i][j];
            }
        }
        return output;
    }
    
    // scalar add (changes Matrix object)
    void scalarAdd(double a) {
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                data[i][j] += a;
            }
        }
    }
    
    // matrix element-wise add (returns new Matrix object)
    static Matrix add(Matrix A, Matrix B) {
        if (A.rows != B.rows || A.cols != B.cols) {
            println("Matrices must have same dimensions");
            return null;
        }
        
        Matrix output = new Matrix(A.rows, A.cols);
        for (int i = 0; i < output.rows; i++) {
            for (int j = 0; j < output.cols; j++) {
                output.data[i][j] = A.data[i][j] + B.data[i][j];
            }
        }
        return output;
    }

    // matrix element-wise subtract: A - B (returns new Matrix object)
    static Matrix subtract(Matrix A, Matrix B) {
        if (A.rows != B.rows || A.cols != B.cols) {
            println("Matrices must have same dimensions");
            return null;
        }
        
        Matrix output = new Matrix(A.rows, A.cols);
        for (int i = 0; i < output.rows; i++) {
            for (int j = 0; j < output.cols; j++) {
                output.data[i][j] = A.data[i][j] - B.data[i][j];
            }
        }
        return output;
    }
    
    String toString() {
        // find the maximum length of the elements in each column for proper alignment
        int[] maxColumnWidths = new int[cols];
        for (int j = 0; j < cols; j++) {
            for (int i = 0; i < rows; i++) {
                int elementLength = String.format("%.2f", data[i][j]).length();
                if (elementLength > maxColumnWidths[j]) {
                    maxColumnWidths[j] = elementLength;
                }
            }
        }
        
        StringBuilder output = new StringBuilder();
        for (int i = 0; i < rows; i++) {
            output.append("|");
            for (int j = 0; j < cols; j++) {
                // use the maximum width for each column to align the elements
                String formatSpecifier = "%" + maxColumnWidths[j] + ".2f";
                if (j != cols - 1) {
                    output.append(String.format(formatSpecifier + " ", data[i][j]));
                } else {
                    output.append(String.format(formatSpecifier, data[i][j]));
                }
            }
            if (i != rows - 1) {
                output.append("|\n");
            } else {
                output.append("|");
            }
        }
        return output.toString();
    }
    
    // returns array version of elements of matrix
    double[] toArray() {
        double[] output = new double[rows * cols];
        int arrayIndex = 0;
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                output[arrayIndex++] = data[i][j];
            }
        }
        return output;
    }

    // creates a 1 column matrix object from a 1D input array
    static Matrix fromArray(double[] input) {
        Matrix output = new Matrix(input.length, 1); 
        for (int i = 0; i < input.length; i++) {
            output.data[i][0] = input[i];
        }
        return output;
    }

    // creates a matrix object from a 2D input array
    static Matrix fromArray(double[][] input) {
        int rows = input.length;
        int cols = input[0].length;       
        Matrix output = new Matrix(rows, cols); 
        for (int i = 0; i < output.rows; i++) {
            for (int j = 0; j < output.cols; j++) {
                output.data[i][j] = input[i][j];
            }
        }
        return output;
    }
    
    Matrix clone() {
        Matrix output = new Matrix(rows, cols);
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                output.data[i][j] = this.data[i][j];
            }
        }
        return output;
    }
}