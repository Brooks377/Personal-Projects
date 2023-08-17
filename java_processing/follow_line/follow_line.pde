

void setup() {
    size(500, 500, P2D);
    textSize(50);
    // noStroke();    
    background(0);
}

void draw() {
    background(0);
    
    int timeElapsed = millis();
    
    // start game countdown
    if (timeElapsed <= 4500) {
        int countdown = 4 - (timeElapsed / 1000);
        fill(255, 255, 255);
        text(countdown+"...", 225, 100);
        delay(1000);
        
    } else {
        stroke(255);
        line(mouseX, mouseY, pmouseX, pmouseY);
    } 
} 
