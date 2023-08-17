public class Snake {
    
    public int length = 4;
    private int growAmount = 3;
    
    public int headPosX = 500;
    public int headPosY = 500;
    public boolean justMoved = true; // to prevent simultaneous keypresses
    
    public ArrayList<Integer> previousPosX = new ArrayList<>();
    public ArrayList<Integer> previousPosY = new ArrayList<>();
    
    private int stepDist = 15;
    private int[] rainbowColors = {
        color(255, 0, 0),
            color(255, 127, 0),
            color(255, 255, 0),
            color(0, 255, 0),
            color(0, 0, 255),
            color(75, 0, 130),
            color(148, 0, 211)
        };
    
    public Snake() {
        for (int i = 0; i < length; i++) {
            previousPosX.add(headPosX);
            previousPosY.add(headPosY);
        }
    }
    
    public void takeFStepX() {
        headPosX += stepDist;
        moveSnake();
        justMoved = true;
    }
    
    public void takeBStepX() {
        headPosX -= stepDist;
        moveSnake();
        justMoved = true;
    }
    
    public void takeFStepY() {
        headPosY -= stepDist;
        moveSnake();
        justMoved = true;
    }
    
    public void takeBStepY() {
        headPosY += stepDist;
        moveSnake();
        justMoved = true;
    }
    
    private void moveSnake() {
        for (int i = 0; i < length - 1; i++) {
            previousPosX.set(i, previousPosX.get(i + 1));
            previousPosY.set(i, previousPosY.get(i + 1));
        }
        previousPosX.set(length - 1, headPosX);
        previousPosY.set(length - 1, headPosY);
    }
    
    public void growSnake() {
        length += growAmount;
        for (int i = 0; i < growAmount; i++) {
            int xReplacement = previousPosX.get(0);
            int yReplacement = previousPosY.get(0);
            previousPosX.add(0, xReplacement);
            previousPosY.add(0, yReplacement);
        }
    }
    
    public void drawSnake() {
        // draw head differently
        int headIDX = previousPosX.size() - 1;
        fill(255);
        circle(playerSnake.headPosX, playerSnake.headPosY, 22);
        
        // draw the rest of body
        for (int i = 0; i < this.length - 1; i++) {
            fill(rainbowColors[i % 7]);
            circle(this.previousPosX.get(i), this.previousPosY.get(i), 20);
        }
    }
    
    public boolean gameOverCheck() {
        boolean gameOver = false;
        
        if ((this.headPosX > 944 || this.headPosX < 40) || (this.headPosY > 944 || this.headPosY < 40)) {
            gameOver = true;
        }
        
        // ignore boot up state
        // will allow player to cross itself at the origin point
        // appearantly also allows switchback movement if only one axis has been changed...
        if (this.headPosX != 500 && this.headPosY != 500) {
            for (int i = 0; i < this.length - 1; i++) {
                if (this.headPosX == this.previousPosX.get(i) && this.headPosY == this.previousPosY.get(i)) {
                    gameOver = true;
                }
            }
        }
        return gameOver;
    }
}
