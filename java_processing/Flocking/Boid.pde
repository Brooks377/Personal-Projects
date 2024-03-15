public class Boid {
    
    PVector pos;
    PVector vel;
    PVector acc;
    
    public Boid(float xPos, float yPos) {
        this.pos = new PVector(xPos, yPos);
        // fixme: how to initialize velocity and acceleration
        this.vel = new PVector(random( -1, 1), random( -1, 1));
        this.acc = new PVector();
    }
    
    public void doPhysics() {
        // handle physics
        pos.add(vel);
        vel.add(acc);
        acc.mult(0);
    }
    
    void draw() {
        float baseDiff = 7;
        // left base
        PVector p1 = new PVector(pos.x + baseDiff, pos.y);
        // right base
        PVector p2 = new PVector(pos.x - baseDiff, pos.y);
        // center point
        PVector p3 = new PVector(pos.x, pos.y + baseDiff + 10);        
        triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
    }
}