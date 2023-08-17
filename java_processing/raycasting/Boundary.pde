public class Boundary {

    public PVector a, b;
    // constructor
    public Boundary(float x1, float y1, float x2, float y2) {
        a = new PVector(x1, y1);
        b = new PVector(x2, y2);
    }

    public void show() {
        stroke(255);
        line(a.x, a.y, b.x, b.y);
    }
}