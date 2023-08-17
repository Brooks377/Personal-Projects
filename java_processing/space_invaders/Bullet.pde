public class Bullet {
    
    public float xPos, yPos;
    boolean bulletAlive;
    private int velocity;
    
    public void shootFrom(Ship s, int velocity) {   
        xPos = s.playerMid.x;
        yPos = s.playerMid.y - s.playerH / 3.5;
        this.velocity = velocity;
        bulletAlive = true;
    }
    
    // overload to work with enemies
    public void shootFrom(Enemy eClass, PVector enemy, int velocity) {
        if (enemy != null) {
            xPos = enemy.x + eClass.size / 2;
            yPos = enemy.y;
            this.velocity = velocity;
            bulletAlive = true;
        }
    }
    
    public void show() {
        if (bulletAlive) {
            circle(xPos, yPos, 5);
        }
    }
    
    public void update() {
        if (bulletAlive) {
            yPos -= velocity;
        } else {
            yPos = -1; // "remove" un-alived bullets
            xPos = -1;
        }
    }
    
    // delete bullet and allow for new shot if enemy hit or wall
    public void checkKill(int i) {
        if (yPos <= 5 || i != -1) {
            bulletAlive = false;
        }
    }
}