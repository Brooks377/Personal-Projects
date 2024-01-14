float angle, branchHeight, scale, hue;

void setup() {
    size(1000, 1000);
    
    // adjustable parameters
    angle = PI / 3;
    branchHeight = 333;
    scale =.6;
}   

void draw() {
    background(0);
    translate(500, height);
    
    hue = 0;
    stroke(hue, 60, 20);
    // draw recursive tree
    branch(branchHeight);
}

void branch(float branchHeight) {
    // colored to show ordering
    // color order kinda confusing tho, still cool
    hue = (hue + 3) % 255;
    stroke(hue, 60, 20);
    // draw branch
    line(0, 0, 0, -branchHeight);
    // move to the end of the branch
    translate(0, -branchHeight);
    
    
    // continue if the length isn't too small
    if (branchHeight >= 1) {
        pushMatrix(); // save translate/rotate/color
        rotate(angle);
        branch(branchHeight * scale); // recursive call
        popMatrix(); // restore translate/rotate/color
        
        pushMatrix(); // save translate/rotate/color
        rotate( - angle);
        branch(branchHeight * scale); // other branch
        popMatrix(); // restore translate/rotate/color
    }
}