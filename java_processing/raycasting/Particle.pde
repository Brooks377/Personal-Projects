public class Particle {
    private PVector position;
    private ArrayList<Ray> rays = new ArrayList<>();
    
    // constructor 
    public Particle() {
        position = new PVector(width / 2, height / 2);
        for (int i = 0; i < 360; i += 1) {
            Ray ray2add = new Ray(position, radians(i));
            rays.add(0, ray2add);
        }
    }
    
    // change position of source
    public void update(float x, float y) {
        this.position.set(x, y);
    }
    
    // show the source of rays
    public void show() {
        fill(255);
        ellipse(position.x, position.y, 8, 8);
        for (int i = 0; i < rays.size(); i++) {
            rays.get(i).show();
        }
    }
    
    // draws the lines that intersect the boundary
    public void look(ArrayList<Boundary> walls) {
        
        // check each ray around source
        for (Ray ray : rays) {
            // find the closest boundary that intersects
            PVector closest = null;
            double record = Double.POSITIVE_INFINITY;

            // check every boundary
            for (Boundary wall : walls) {
                boolean intersects = ray.cast(wall); 
                
                // finds the intersection point
                PVector point = ray.findIntersection(intersects, wall);
                if (point != null) {
                    // check to make sure it is the closest boundary hit
                    
                    double d = PVector.dist(position, point);
                    if (d < record) {
                        record = d;
                        closest = point;
                    }
                } 
            }
            
            // draw the ray to boundary
            if (closest != null) {
                stroke(255, 100);
                line(closest.x, closest.y, this.position.x, this.position.y);
            }
        }
    }
}