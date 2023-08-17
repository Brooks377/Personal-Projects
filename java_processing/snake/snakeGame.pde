Snake playerSnake;
Food gameFood;
ScoreManager manager;

boolean gameStarted = false;
int countdown = 3;
int fps = 12;
int highScore;

enum Direction {
    UP, DOWN, LEFT, RIGHT
}
Direction direction;

void setup() {
    size(990, 990, P2D);
    textSize(50);
    background(0);
    frameRate(fps);
    playerSnake = new Snake();
    gameFood = new Food();
    manager = new ScoreManager();
}

void draw() {
    background(255);
    fill(0);
    square(40, 40, 904);

    if (!gameStarted) {
        fill(255);
        rect(width / 2 - 100, height / 2 - 50, 200, 100);
        fill(0);
        text("Start", width / 2 - 50, height / 2);
        return;
    } else if (countdown >= 0) {
        fill(255);
        text(countdown-- + "...", 475, 200);
        delay(1000);
        return;
    }
    
    // draw scoreboard
    manager.displayCurrentScore();
    manager.displayHighScore();
    
    // check if player is near enough to food; increment length; set new location for food
    if (((playerSnake.headPosX <= gameFood.foodX + 10) && (playerSnake.headPosX >= gameFood.foodX - 10)) 
        && ((playerSnake.headPosY <= gameFood.foodY + 10) && (playerSnake.headPosY >= gameFood.foodY - 10))) {
        
        playerSnake.growSnake();
        gameFood.newFood();
    }
    
    // player input in loop
    if (gameStarted && countdown < 0) {
        if (direction == Direction.UP) {
            playerSnake.takeFStepY();
        } else if (direction == Direction.DOWN) {
            playerSnake.takeBStepY();
        } else if (direction == Direction.RIGHT) {
            playerSnake.takeFStepX();
        } else if (direction == Direction.LEFT) {
            playerSnake.takeBStepX();
        } 
        playerSnake.drawSnake();
        gameFood.drawFood();
    }        
    
    // check game over condition
    if (playerSnake.gameOverCheck()) {
        manager.updateHighScore();
        fill(255);
        text("             GAME OVER\n\nPress Enter to play again", width / 2 - 150, height / 6);
        noLoop();
    }
} 

// handle mouse click events
void mousePressed() {
    if (!gameStarted) {
        if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 && 
            mouseY > height / 2 - 50 && mouseY < height / 2 + 50) {
            gameStarted = true;
            gameFood.newFood();
        }
    }
}

// handle key press events for player input
void keyPressed() {
    
    if (playerSnake.justMoved && key == CODED) {
        switch(keyCode) {
            case UP:
                if (direction != Direction.DOWN) {
                    direction = Direction.UP;
                    playerSnake.justMoved = false; // reset justMoved after movement
                }
                break;
            case DOWN:
                if (direction != Direction.UP) {
                    direction = Direction.DOWN;
                    playerSnake.justMoved = false;
                }
                break;
            case RIGHT:
                if (direction != Direction.LEFT) {
                    direction = Direction.RIGHT;
                    playerSnake.justMoved = false;
                }
                break;
            case LEFT:
                if (direction != Direction.RIGHT) {
                    direction = Direction.LEFT;
                    playerSnake.justMoved = false;
                }
                break;
        }
    }
    
    // only available if the game is over
    if (playerSnake.gameOverCheck()) {
        if (keyCode == ENTER) {
            playerSnake = new Snake();
            gameFood = new Food();
            direction = null;
            gameFood.newFood();
            loop();
            
        }
    }
}
