public class SawtoothWave {

    int maxWaves;

    public SawtoothWave(int maxWaves) { 
        this.maxWaves = maxWaves;
    }
    
    public float findWaveValue() {
        float x = 0;
        float y = 0;
        // loop through however many circles/dots to draw
        for (int i = 1; i < maxWaves + 1; i++) {
            float prevX = x;
            float prevY = y;
            
            // continuous series (unlike square and triangle)
            int n = i;
            // calculate point going around circle iteratively
            float radius = (float)(150 * (1 / (n * Math.PI)));
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
        line(x, y, 200, y);
        time+= speed;    // theta angle in the circle == time

        return y;
    }
}