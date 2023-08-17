public class Enemy {
    
    public ArrayList<PVector> enemyList;
    public ArrayList<PVector> initEnemyPos;
    int numEnemies;
    int size;
    int XdanceOffset;
    int YdanceOffset;
    float spawnX;
    float spawnY;
    float spacing;
    float spacingOffset;
    boolean movingRight;
    
    public Enemy(int numEnemies, float spawnY) {
        enemyList = new ArrayList<>();
        initEnemyPos = new ArrayList<>();
        this.numEnemies = numEnemies;
        size = 30;
        spawnX = 50;
        this.spawnY = spawnY;
        spacing = 0;
        spacingOffset = 40;
        XdanceOffset = 125;
        YdanceOffset = 100; // FIXME unused
        movingRight = true;
        
        
        for (int i = 0; i < numEnemies; i++) {
            PVector temp = new PVector(spawnX + spacing, spawnY);
            PVector temp2 = new PVector(spawnX + spacing, spawnY);
            enemyList.add(temp);
            initEnemyPos.add(temp2);
            spacing += spacingOffset;
        }
    }
    
    public void show() {
        for (PVector e : enemyList) {
            square(e.x, e.y, size);
        }
    }
    
    public void update(Bullet b) {
        // remove enemies that are killed
        int i = enemyKilled(b);
        if (i != -1) {
            enemyList.remove(i);
            initEnemyPos.remove(i);
        }
        
        // move the rest of the enemies in a pattern
        moveLeftRight();
    }
    
    // simple left-right pattern for enemy movement
    private void moveLeftRight() {
        for (int j = 0; j < enemyList.size(); j++) {
            if (enemyList.get(j).x == initEnemyPos.get(j).x + XdanceOffset) {
                movingRight = false;
            }
            if (enemyList.get(j).x == initEnemyPos.get(j).x) {
                movingRight = true;
            }
            
            if (movingRight) {
                enemyList.get(j).add(1, 0);
            } else {
                enemyList.get(j).add( -1, 0);
            } 
        }
    }
    
    
    // if enemy is killed, return position of index for removal
    public int enemyKilled(Bullet bill) {
        for (int i = 0; i < enemyList.size(); i++) {
            PVector e = enemyList.get(i);
            if ((bill.yPos <= e.y + size && bill.yPos >= e.y) && (bill.xPos >= e.x - 2 && bill.xPos <= e.x + size + 2)) {
                return i;
            }
        }
        return - 1;
    }
    
    // to create enemy bullets
    public PVector pickRandomEnemy() {
        if (enemyList.size() > 0) {
            return enemyList.get((int)(random(enemyList.size())));
        }
        return null;
    }
}