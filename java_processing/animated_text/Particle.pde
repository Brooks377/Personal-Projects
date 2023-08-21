public class Particle {
    
    PVector pos, target, vel, acc;
    int maxSpeed;
    float maxForce;
    
    public Particle(PVector pos) {
        this.pos = new PVector(random(width), random(height));
        target = pos.copy();
        vel = new PVector(random( -5, 5), random( -5, 5));
        acc = new PVector();
        maxSpeed = 10;
        maxForce = 1;
    }
    
    public void update() {
        // handle physics
        pos.add(vel);
        vel.add(acc);
        acc.mult(0);
    }
    
    public void behavoirs() {
        // find original position
        PVector arrive = arrive(target);
        // run away from mouse
        PVector mouse = new PVector(mouseX, mouseY);
        PVector flee = flee(mouse);

        arrive.mult(1);
        flee.mult(5);
        
        applyForce(arrive);
        applyForce(flee);
    }
    
    public void applyForce(PVector force) {
        acc.add(force);
    }
    
    public PVector arrive(PVector target) {
        PVector targetOG = target.copy();
        PVector desired = targetOG.sub(pos);
        float dist = desired.mag();
        
        float speed = maxSpeed;
        if (dist < 100) {
            speed = map(dist, 0, 100, 0, maxSpeed);
        }
        
        desired.setMag(speed);
        PVector steer = desired.sub(vel);
        steer.limit(maxForce);
        return steer;
    }
    
    public PVector flee(PVector target) {
        PVector targetOG = target.copy();
        PVector desired = targetOG.sub(pos);
        float dist = desired.mag();
        if (dist < 50) {
            desired.setMag(maxSpeed);
            desired.mult( - 1);
            PVector steer = desired.sub(vel);
            steer.limit(maxForce);
            return steer;
        } else {
            PVector nullVec = new PVector(0,0);
            return nullVec;
        }
    }
    
    public PVector seek(PVector target) {
        PVector targetOG = target.copy();
        PVector desired = targetOG.sub(pos);
        desired.setMag(maxSpeed);
        PVector steer = desired.sub(vel);
        steer.limit(maxForce);
        return steer;
    }
    
}