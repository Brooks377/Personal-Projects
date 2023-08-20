public class Lorenz{
    
    float a, b, c, x, y, z;
    ArrayList<PVector> points;
    int maxPoints = 5000;
    
    public Lorenz(float a, float b, float c) {
        this.a = a; // sigma
        this.b = b; // rho
        this.c = c; // beta
        points = new ArrayList<>(); // points setter below for more clarity
    }
    
    public void setXYZ(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    public void run() {
        // time-step per frame
        // must be small to have trend toward infinity not happen too soon
        float dt = .01;
        
        // dx/dt differential
        float dx = (a * (y - x)) * dt;
        
        // dy/dt differential
        float dy = (x * (b - z) - y) * dt;
        
        // dz/dt differential
        float dz = ((x * y) - (c * z)) * dt;
        
        // update the x,y,z each frame
        x = x + dx;
        y = y + dy;    
        z = z + dz;
        
        int pointsAmount = points.size();
        if (pointsAmount == maxPoints) {
            println("Hit maximum allowed points. Visualization complete.");
            points.add(new PVector(x, y, z));
            modelRunning = false;
        } else if (pointsAmount <= maxPoints) {
            points.add(new PVector(x, y, z));
        }        
        
        // draw the "state of system over time"
        translate(width / 2, height / 2);
        scale(5);
        strokeWeight(.4);
        noFill();

        beginShape();
        float hue = 0;
        for (PVector p : points) {
            stroke(hue, 255, 255);
            vertex(p.x, p.y, p.z);
            // expansion offset
            
            
            hue += .1;
            if (hue > 255) {
                hue = 0;
            }
        }
        endShape();
    }
    
}