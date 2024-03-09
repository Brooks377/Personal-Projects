float f(float x) {
    // y = mx + b
    return -3 * x + .5;
}

public class Point {
    float x;
    float y;
    float bias;
    int label;
    
    Point() {
        this.x = random( -1, 1);
        this.y = random( -1, 1);
        this.bias = 1;
        
        // checks if above specified line for "training data"
        float lineY = f(x);
        if (y > lineY) {
            label = 1;
        } else {
            label = -1;
        }
    }
    
    Point(float x, float y) {
        this.x = x;
        this.y = y;
        this.bias = 1;
        
        // checks if above y=x for "training data"
        if (x > y) {
            label = 1;
        } else {
            label = -1;
        }
    }
    
    // display training data
    void show() {
        stroke(0);
        if (label == 1) {
            fill(255);
        } else {
            fill(0);
        }
        
        float px = pixelX();
        float py = pixelY();
        circle(px, py, 30);
    }
    
    float pixelX() {
        return map(x, -1, 1, 0, width);
    }
    
    float pixelY() {
        return map(y, -1, 1, height, 0);
    }
}
