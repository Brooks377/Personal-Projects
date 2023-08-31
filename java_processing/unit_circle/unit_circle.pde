float radius;
float theta;
float sliderX;

void setup() {
    size(800, 600);
    radius = 150;
    sliderX = 0;
}

void draw() {
    background(0);
    translate(width / 2 - 200, height / 2);
    
    // unit circle
    noFill();
    stroke(255);
    ellipseMode(RADIUS); // make the radius actually the radius
    circle(0, 0, radius);
    
    // x and y axis
    stroke(255, 75);
    line(0, height, 0, -height);
    line( -width, 0, width, 0);
    
    println(mouseX, mouseY);
    
    // theta slider
    stroke(255);
    line(0, -250, 300, -250);
    text("0", -4, -260);
    text("2PI",295, -260);
    text("PI",146, -260);
    text("PI/2",66, -260);
    text("3PI/2",212, -260);
    if (mousePressed) {
        if (mouseY > 30 && mouseY < 70) {
            if (mouseX > 345 && mouseX < 355) { // snap point check PI
                sliderX = 150;
            } else if (mouseX > 270 && mouseX < 280) { // snap point check PI / 2
                sliderX = 75;
            } else if (mouseX > 420 && mouseX < 430) { // snap point check 3PI / 2
                sliderX = 225;
            } else if (mouseX > 500) { // upper bound
                sliderX = 300;
            } else if (mouseX < 200) { // lower bound
                sliderX = 0;
            } else {
                sliderX = mouseX - 200; // position given no snaps
            } 
        }
    }
    // indicator of current slider position
    fill(255);
    circle(sliderX, -250, 5);
    noFill();
    
    // line that moves around circle according to mouse
    stroke(255, 0, 0);
    theta =  - sliderBar(sliderX); // invert because processing works upside down
    line(0, 0, cos(theta) * radius, sin(theta) * radius);
    
    // draw triangle simulating x = cos y = sin 
    stroke(255, 165, 0);
    line(cos(theta) * radius, sin(theta) * radius, cos(theta) * radius, 0);
    stroke(255,  100, 0);
    line(0, 0, cos(theta) * radius, 0);
    
    // show trig function values in decimal (and in common PI form)
    rectMode(CORNERS);
    stroke(255);
    fill(0);
    rect(300, -200, 550, 200);
    fill(255,  200, 0);
    text(sinForTable(theta), 310, -180);
    fill(255,  110, 0);
    text(cosForTable(theta), 310, -160);
    fill(255);
    text(tanForTable(theta), 310, -140);
    text(cscForTable(theta), 310, -120);
    text(secForTable(theta), 310, -100);
    text(cotForTable(theta), 310, -80);

    text("Note: Infinity == approaching pos/neg infinity", 310, 180);
}

// modifier bar produces 0 - 2PI
float sliderBar(float sliderX) {
    return map(sliderX, 0, 300, 0, 2 * PI);
}

// convert theta to radian form
String theta2Radians(float theta) {
    float piAmount = theta / PI;
    return String.format("%.2fPI", piAmount);
}

// Sin function in table of answers
String sinForTable(float theta) {
    return String.format("Sin(%s) = %.2f", theta2Radians(theta), sin(theta));
}

// Cos function in table of answers
String cosForTable(float theta) {
    return String.format("Cos(%s) = %.2f", theta2Radians(theta), cos(theta));
}

// Tan function in table of answers
String tanForTable(float theta) {
    return String.format("Tan(%s) = %.2f", theta2Radians(theta), (tan(theta) > 1000 || tan(theta) < -1000) ? (1f / 0f) : tan(theta));
}

// csc function in table of answers
String cscForTable(float theta) {
    return String.format("csc(%s) = %.2f", theta2Radians(theta), (1 / sin(theta) > 1000 || 1 / sin(theta) < -1000) ? (1f / 0f) : 1 / sin(theta));
}

// sec function in table of answers
String secForTable(float theta) {
    return String.format("sec(%s) = %.2f", theta2Radians(theta), (1 / cos(theta) > 1000 || 1 / cos(theta) < -1000) ? (1f / 0f) : 1 / cos(theta));
}

// cot function in table of answers
String cotForTable(float theta) {
    return String.format("cot(%s) = %.2f", theta2Radians(theta), (1 / tan(theta) > 1000 || 1 / tan(theta) < -1000) ? (1f / 0f) : 1 / tan(theta));
}