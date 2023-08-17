Ship player;
Bullet bullet;
Bullet[] enemyBullet;
Enemy[] enemies;

int speed;
boolean moveLeft, moveRight;
int rowOffset;
int[] rowIntervalDiff;
int[] lastEnemyShotTime;

// difficulty sliders
public int enemyRows = 4;
public int numEnemies = 8;
int shotInterval = 1000; // ~ 5 seconds between shots
int rowShootingOffset = 1500;

void setup() {
    size(600, 500);
    background(0);
    player = new Ship();
    bullet = new Bullet();
    enemyBullet = new Bullet[enemyRows];
    enemies = new Enemy[enemyRows];
    rowIntervalDiff = new int[enemyRows];
    lastEnemyShotTime = new int[enemyRows];
    speed = 4;
    rowOffset = 0;
    
    for (int i = 0; i < enemies.length; i++) {
        enemies[i] = new Enemy(numEnemies, 50 + rowOffset);
        rowOffset += enemies[i].spacingOffset;
        enemyBullet[i] = new Bullet();
        rowIntervalDiff[i] = (int) random( -rowShootingOffset, rowShootingOffset);
    }
}


void draw() {
    background(0);
    noStroke();
    
    // show the player
    player.show();
    // update its position
    player.updateSpeed();
    // smoother movement
    handleMovement();
    
    // show and update the bullet    
    bullet.show();
    bullet.update();
    
    // for each row of enemies
    for (int i = 0; i < enemies.length; i++) {
        
        // delete bullet once it hits an enemy
        int killCheck = enemies[i].enemyKilled(bullet);
        bullet.checkKill(killCheck);
        
        // show and update enemies
        enemies[i].show();
        enemies[i].update(bullet);
        
        // show and update enemy bullet
        enemyBullet[i].show();
        enemyBullet[i].update();
        
        // check if enemy kills player
        player.playerDeathCheck(enemyBullet[i]);
    }
    
    for (int i = 0; i < enemies.length; i++) {
        if (millis() - lastEnemyShotTime[i] > shotInterval + rowIntervalDiff[i]) {
            randomEnemyShot(i);
            rowIntervalDiff[i] = (int) random( -rowShootingOffset, rowShootingOffset);
            lastEnemyShotTime[i] = millis();
        }
    }
    
    // win condition check
    checkForWin();
    
    // loss condition check
    if (player.isDead) {
        noLoop();
    }
}

void checkForWin() {
    int check = enemies.length;
    for (int i = 0; i < enemies.length; i++) {
        if (enemies[i].enemyList.size() == 0) {
            check--;
        }
    }
    if (check == 0) {
        textAlign(CENTER);
        text("You Win!!", width / 2, height / 2);
        text("Press Enter/Return to play again", width / 2, height / 2 + 20);
        player.isDead = true; // FIXME seems to work for now...
        noLoop();
    }
}

void randomEnemyShot(int i) {
    if (enemyBullet[i].yPos > height || enemyBullet[i].yPos == -1) {
        PVector temp = enemies[i].pickRandomEnemy();
        enemyBullet[i].shootFrom(enemies[i], temp, -5);
        println(i);
        
    }
}

void keyPressed() {
    if (keyCode == RIGHT) {
        moveRight = true;
    }
    if (keyCode == LEFT) {
        moveLeft = true;
    }
    if (keyCode == ' ' && !bullet.bulletAlive) {
        bullet.shootFrom(player,8);
    }
    
    // only available if the game is over
    if (player.isDead) {
        if (keyCode == ENTER) {
            player = new Ship();
            bullet = new Bullet();
            rowOffset = 0;
            for (int i = 0; i < enemies.length; i++) {
                enemies[i] = new Enemy(numEnemies, 50 + rowOffset);
                rowOffset += enemies[i].spacingOffset;
                enemyBullet[i] = new Bullet();
            }
            loop();
        }
    }
}

void keyReleased() {
    if (keyCode == RIGHT) {
        moveRight = false;
    }
    if (keyCode == LEFT) {
        moveLeft = false;
    }
}

void handleMovement() {
    if (moveLeft == true && moveRight == false) {
        player.setVelocity( -speed);
    }
    else if (moveRight == true && moveLeft == false) {
        player.setVelocity(speed);
    }
    else {
        player.setVelocity(0);
    }
}