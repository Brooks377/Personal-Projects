public class Ray {
    
    private PVector position;
    private PVector direction;
    private float t;
    private float u;
    
    public Ray(PVector position, float angle) {
        this.position = position;
        this.direction = PVector.fromAngle(angle);
    }
    
    public void show() {
        stroke(255);
        push(); // save canvas settings
        translate(position.x, position.y);
        line(0, 0, direction.x * 10, direction.y * 10);
        pop(); // restore saved canvas settings
    }
    
    public void setDirection(float x, float y) {
        direction.x = x - position.x;
        direction.y = y - position.y;
        direction.normalize(); // unit vector
    }
    
    public boolean cast(Boundary wall) {
        // https://en.wikipedia.org/wiki/Line%E2%80%93line_intersection
        // boundary points
        float x1 = wall.a.x;
        float y1 = wall.a.y;
        float x2 = wall.b.x;
        float y2 = wall.b.y;
        
        // ray points
        float x3 = position.x;
        float y3 = position.y;
        float x4 = position.x + direction.x;
        float y4 = position.y + direction.y;
        
        // perform intersection calculation
        float denominator = ((x1 - x2) * (y3 - y4)) - ((y1 - y2) * (x3 - x4));
        
        // check for parallel lines
        if (denominator == 0) {
            return false;
        }
        
        // determinant of a matrix (from Wikipedia)
        t = (((x1 - x3) * (y3 - y4)) - ((y1 - y3) * (x3 - x4))) / denominator;
        u = -(((x1 - x2) * (y1 - y3)) - ((y1 - y2) * (x1 - x3))) / denominator;
        
        // if the wall and ray intersect
        if (t > 0 && t < 1 && u > 0) {
            return true;
        } else {
            return false;
        }
    }
    
    public PVector findIntersection(boolean hasPoint, Boundary wall) {

        // boundary points
        float x1 = wall.a.x;
        float y1 = wall.a.y;
        float x2 = wall.b.x;
        float y2 = wall.b.y;
        
        PVector output = new PVector();
        if (hasPoint) {
            output.x = x1 + t * (x2 - x1);
            output.y = y1 + t * (y2 - y1);
            return output;
        } else {
            return null;
        }
    }
}