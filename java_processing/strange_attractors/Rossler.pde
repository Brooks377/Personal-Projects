public class Rossler{
    
    float a, b, c, x, y, z;
    ArrayList<PVector> points;
    int maxPoints = 5000;
    
    public Rossler(float a, float b, float c) {
        this.a = a;
        this.b = b;
        this.c = c;
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
        float dt = .05;
        
        // dx/dt differential
        float dx = ( -(y + z)) * dt;
        
        // dy/dt differential
        float dy = (x + (a * y)) * dt;
        
        // dz/dt differential
        float dz = (b + (z * (x - c))) * dt;
        
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
        scale(.5);
        noFill();
        
        beginShape();
        float hue = 0;
        strokeWeight(2);
        for (PVector p : points) {
            // map points for better visuals given pixel count
            float plotX = map(p.x, 0, 15, 0,(width * .6));
            float plotY = map(p.y, 0, 15, 0,(height * .6));
            float plotZ = map(p.z, 0, 15, 0, 200);
            stroke(hue, 255, 255);
            vertex(plotX, plotY, plotZ);

            hue += .25;
            if (hue > 255) {
                hue = 0;
            }
        }
        endShape();
    }
    
}