float radius;
float theta;
float sliderX;
float speed;
boolean sliderOn;
boolean justSwitched;
boolean minusMode;

void setup() {
    size(800, 600);
    radius = 150;
    sliderX = 0;
    sliderOn = true;
    theta = 0;
    speed =.01;
    justSwitched = false;
    minusMode = false;
}

void draw() {
    background(0);
    translate(width / 2 - 200, height / 2);
    
    // println(mouseX, mouseY, sliderX);
    
    // unit circle
    noFill();
    stroke(255);
    ellipseMode(RADIUS); // make the radius actually the radius
    circle(0, 0, radius);
    
    // x and y axis
    stroke(255, 75);
    line(0, height, 0, -height);
    line( -width, 0, width, 0);
    
    // theta slider
    stroke(255);
    line(0, -250, 300, -250);
    text("0", -4, -260);
    text("PI/4", 28, -260);
    text("PI/2",66, -260);
    text("3PI/4", 100, -260);
    text("PI",146, -260);
    text("5PI/4", 175, -260);
    text("3PI/2",213, -260);
    text("7PI/4", 251, -260);
    text("2PI",295, -260);
    if (mousePressed) {
        if (mouseY > 30 && mouseY < 70) {
            if (mouseX > 345 && mouseX < 355) { // snap point check PI
                sliderX = 150;
            } else if (mouseX > 270 && mouseX < 280) { // snap point check PI / 2
                sliderX = 75;
            } else if (mouseX > 420 && mouseX < 430) { // snap point check 3PI / 2
                sliderX = 225;
            } else if (mouseX > 232 && mouseX < 242) { // snap point check PI/4
                sliderX = 37.5;
            } else if (mouseX > 308 && mouseX < 318) { // snap point check 3PI / 4
                sliderX = 112.5;
            } else if (mouseX > 382 && mouseX < 392) { // snap point check 5PI/4
                sliderX = 187.5;
            } else if (mouseX > 458 && mouseX < 468) { // snap point check 7PI / 4
                sliderX = 262.5;
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
    
    // line that moves around circle according to slider or on its own
    stroke(255, 0, 0);
    if (keyPressed) {
        if (key == 'r') {
            sliderOn = false;
        }
        if (key == 's') {
            sliderOn = true;
        }
        if (key == ' ') {
            speed = 0;
        }
        if (key == '-') {
            if (!justSwitched) {
                if (theta > 0) {
                    theta = -theta;
                    minusMode = true;
                }
                if (speed > 0) {
                    speed = -speed;
                }
                justSwitched = true;
            }
        }
        if (key == '=') {
            theta = abs(theta);
            speed = abs(speed);
            minusMode = false;
        }
        if (key == CODED) {
            switch(keyCode) {
                case UP:
                    speed +=.001;
                    break;
                case DOWN:
                    speed -=.001;
                    break;
            }
        }
    }
    if (sliderOn) {
        if (minusMode) {
            theta = -sliderBar(sliderX);
        } else {
            theta = sliderBar(sliderX);
        }
    } else {
        theta += speed;
        float tempSlider = map(theta, 0, 2 * PI, 0, 300);
        sliderX = abs(tempSlider);
        if (theta > (2 * PI) || theta < ( -2 * PI)) {
            theta = 0;
        }
    }
    // indicate if theta is negative
    if (theta < 0) {
        text("Slider is Negative", -100, -250);
    }
    // invert following lines because grid is upside down
    line(0, 0, cos(theta) * radius, -sin(theta) * radius);
    
    // draw triangle simulating x = cos y = sin 
    stroke(255, 165, 0);
    line(cos(theta) * radius, -sin(theta) * radius, cos(theta) * radius, 0);
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
    
    text(String.format("Speed: %.3f", speed), 310, 100);
    text("Controls:\n - 'r' == rotate     UP/DOWN/SPACE control speed\n - 's' == slider\n - '-'/'=' set theta negative/positive", 310, 120);
    text("Note: Infinity == approaching pos/neg infinity", 310, 180);
}

void keyReleased() {
    if (justSwitched) {
        justSwitched = false;
    }
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
    return String.format("Tan(%s) = %.2f", theta2Radians(theta),(tan(theta) > 1000 || tan(theta) < - 1000) ? (1f / 0f) : tan(theta));
}

// csc function in table of answers
String cscForTable(float theta) {
    return String.format("csc(%s) = %.2f", theta2Radians(theta),(1 / sin(theta) > 1000 || 1 / sin(theta) < - 1000) ? (1f / 0f) : 1 / sin(theta));
}

// sec function in table of answers
String secForTable(float theta) {
    return String.format("sec(%s) = %.2f", theta2Radians(theta),(1 / cos(theta) > 1000 || 1 / cos(theta) < - 1000) ? (1f / 0f) : 1 / cos(theta));
}

// cot function in table of answers
String cotForTable(float theta) {
    return String.format("cot(%s) = %.2f", theta2Radians(theta),(1 / tan(theta) > 1000 || 1 / tan(theta) < - 1000) ? (1f / 0f) : 1 / tan(theta));
}