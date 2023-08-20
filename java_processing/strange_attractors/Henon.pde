public class Henon{
    
    float a, b, x, y, z;
    ArrayList<PVector> points;
    int maxPoints = 5000;
    
    public Henon(float a, float b) {
        this.a = a;
        this.b = b;
        points = new ArrayList<>(); // points setter below for more clarity
    }
    
    public void setXYZ(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    // creates and displays the lorenz attractor each frame
    public void run() {        
        // find amount to update by
        float tempX = 1 - (a * x * x) + y;
        float tempY = b * x;
        float tempZ = 0;
        // update the x,y,z each frame
        x = tempX;
        y = tempY;    
        z = tempZ;
        
        int pointsAmount = points.size();
        if (pointsAmount == maxPoints) {
            println("Hit maximum allowed points. Visualization complete.");
            points.add(new PVector(x, y, z));
            modelRunning = false;
        } else if (pointsAmount <= maxPoints) {
            points.add(new PVector(x, y, z));
        }        
        
        // draw the "state of system over time"
        int boundW = width / 2;
        int boundH = height / 2;
        translate(boundW, boundH);
        scale(2.25);
        strokeWeight(.75);
        
        float hue = 0;
        for (PVector p : points) {
            // map points for better visuals given pixel count
            float plotX = map(p.x, -1.5, 1.5, -boundW *.6 ,boundH *.6);
            float plotY = map(p.y, -1.5, 1.5, -boundW *.6 ,boundH *.6);
            float plotZ = p.z;
            stroke(hue, 255, 255);
            point(plotX, plotY, plotZ);
            // expansion offset
            
            
            hue +=.08;
            if (hue > 255) {
                hue = 0;
            }
        }
    }
    
}
