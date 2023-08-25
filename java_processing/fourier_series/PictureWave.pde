public class PictureWave {
    
    int maxWaves;
    
    public PictureWave(int maxWaves) {
        this.maxWaves = maxWaves;
    }
    
    public PVector findWaveValue(float x, float y, float rotation, ArrayList<DiscreteFreq> fourier) {
        // float x = 0;
        // float y = 0;

        // loop through however many waves we need
        for (int i = 0; i < fourier.size(); i++) {
            float prevX = x;
            float prevY = y;
            
            // odd number series
            float freq = fourier.get(i).freq;
            // calculate point going around circle iteratively
            float radius = fourier.get(i).amp;
            float phase = fourier.get(i).phase;

            x += radius * cos((freq * time) + phase + rotation);
            y += radius * sin((freq * time) + phase + rotation);
            
            // base circle
            noFill();
            stroke(255, 100);
            circle(prevX, prevY, radius * 2);
            
            // rotating line to edge of cirlce
            fill(255);
            stroke(255);
            line(prevX, prevY, x, y);
        }
        // // draw line from circle to wave
        // line(x, y, 200, y);

        // increment time
        float dt = TWO_PI / fourier.size();
        time += dt;    // time is dt for artbitrary wave/signal

        if (time > TWO_PI) {
            delay(1000);
            time = 0;
            path = new ArrayList<>();
        }

        PVector output = new PVector(x, y);
        
        return output;
    }
    
    // discrete fourier transform 
    public ArrayList<DiscreteFreq> dft(ArrayList<Float> x) {
        int N = x.size();  // to match with WikiPedia Formula
        ArrayList<DiscreteFreq> X = new ArrayList<>();
        
        for (int k = 0; k < N; k++) {
            Float re = 0.0;   // real component
            Float im = 0.0;   // 'imaginary' component
            
            for (int n = 0; n < N; n++) {
                Float phi = (TWO_PI * k * n) / N;
                re += x.get(n) * cos(phi);
                im -= x.get(n) * sin(phi);
            }
            re = re / N;
            im = im / N;
            
            float freq = k;
            float amp = sqrt((re * re) + (im * im)); // manual magnitude of vector
            float phase = atan2(im, re);
            
            X.add(new DiscreteFreq(re, im, freq, amp, phase));
        }
        return X;
    }
}

public class DiscreteFreq {
    float re, im, freq, amp, phase;
    public DiscreteFreq(float re, float im, float freq, float amp, float phase) {
        this.re = re;
        this.im = im;
        this.freq = freq;
        this.amp = amp;
        this.phase = phase;
    }
}
