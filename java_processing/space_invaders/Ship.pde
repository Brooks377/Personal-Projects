class Ship {
    private float velocity;
    int playerX;
    int playerH;
    int playerW;
    int playerY;
    PVector playerMid;
    boolean isDead;
    float styleW;
    float styleH;
    
    // constructor
    public Ship() {
        playerX = width / 2;
        playerH = 30;
        playerW = 20;
        playerY = height - playerH;
        playerMid = new PVector(playerX + (playerW / 2), playerY);
        isDead = false;
    }
    
    // shows player each frame
    public void show() {
        
        fill(255);
        rect(playerX, playerY, playerW, playerH);
        
        // some style
        float styleScale = isDead ? .7 : .25;
        styleW = playerW * styleScale;
        styleH = playerH * styleScale;
        fill(0);
        rect(playerX, playerY, styleW, styleH);
        rect(playerX + (playerW * (1 - styleScale)), playerY, styleW, styleH);
        fill(255);
        rect(playerX - (styleW *.75), height - (playerH *.5), styleW, playerH *.5);
        rect(playerX + playerW - (styleW *.25), height - (playerH *.5), styleW, playerH *.5);
        
        // set new midpoint for bullet
        playerMid.set(playerX + (playerW / 2), playerY);
    }
    
    // makes changes to the player in draw
    public void updateSpeed() {
        playerX += velocity;
    }
    
    // sets the speed in keypressed and keyreleased
    public void setVelocity(int vel) {
        this.velocity = vel;
    }
    
    // occurs when player is hit by the enemy
    public void playerDeathCheck(Bullet enemyBullet) {
        if ((enemyBullet.xPos <= playerX + playerW + (styleW *.75) + 2 && enemyBullet.xPos >= playerX - (styleW *.75) - 2) && (enemyBullet.yPos <= height && enemyBullet.yPos >= height - (playerH *.5))) {
            isDead = true;
            show();
            textAlign(CENTER);
            stroke(255);
            text("Game Over", width / 2, height / 2);
            text("Press Enter/Return to play again", width / 2, height / 2 + 20);
        }
    }
}