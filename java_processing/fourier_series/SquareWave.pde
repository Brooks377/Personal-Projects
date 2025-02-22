public class SquareWave {

    int maxWaves;

    public SquareWave(int maxWaves) {
        this.maxWaves = maxWaves;
    }
    
    public float findWaveValue() {
        float x = 0;
        float y = 0;
        // loop through however many circles/dots to draw
        for (int i = 0; i < maxWaves; i++) {
            float prevX = x;
            float prevY = y;
            
            // odd number series
            int n = (i * 2) + 1;
            // calculate point going around circle iteratively
            float radius = (float)(75 * (4 / (n * Math.PI)));
            x +=radius * cos(n * time);
            y +=radius * sin(n * time);
            
            // base circle
            noFill();
            stroke(255, 100);
            circle(prevX, prevY, radius * 2);
            
            // rotating line to edge of cirlce
            fill(255);
            stroke(255);
            line(prevX, prevY, x, y);
        }
        // draw line from circle to wave
        line(x, y, 200, y);
        // increment time
        time+= speed;    // theta angle in the circle == time

        return y;
    }
}
