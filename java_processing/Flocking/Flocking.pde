ArrayList<Boid> boids;
int numBoids = 50;
int maxSpeed = 10;
float maxForce = 1;

void setup() {
    size(800, 800);
    boids = new ArrayList<>(numBoids);
    initialize_positions(numBoids);
}

void draw() {
    background(0);
    
    draw_boids();
    move_all_boids();
}

void move_all_boids() {
    for (Boid b : boids) {
        PVector offset1, offset2, offset3;
        
        offset1 = rule1(b);
        b.acc.add(offset1);
        
        // offset2 = rule2(b);
        // b.vel.add(offset2);
        
        // offset3 = rule3(b);
        // b.vel.add(offset3);
        
        b.vel.limit(maxSpeed);
        b.doPhysics();
    }
    
}

// rule 1: boids try to fly towards nearby "center of mass"
PVector rule1(Boid subject) {
    float caringRadius = width / 3;
    PVector perceivedCenter = new PVector();
    int boidsNearby = 0;
    for (Boid b : boids) {
        // only in neighborhood and don't check self
        if (b.pos.dist(subject.pos) <= caringRadius && subject != b) {
            perceivedCenter.add(b.pos);
            boidsNearby++;
        }
    }
    println(boidsNearby);
    if (boidsNearby > 1) {
        perceivedCenter.div(boidsNearby - 1);
    }
    println(perceivedCenter);
    PVector output = perceivedCenter.sub(subject.pos).div(100);
    output.limit(maxForce);
    return output;
}

// rule 2: boids try to keep a small distance from other boids

void draw_boids() {
    for (Boid b : boids) {
        b.draw();
    }
}

void initialize_positions(int numBoids) {
    // for now, random anywhere on screen
    for (int i = 0; i < numBoids; i++) {
        Boid temp = new Boid(random(width / 2), random(height / 2));
        boids.add(temp);
    }
}
