public class Food {
    
    public int foodX;
    public int foodY;
    private int randNumX;
    private int randNumY;
    private int bodyPosAllowance = 50;
    private int headPosAllowance = 150;
    
    public void newFood() {
        randNumX = 45 + ((int) random(65)) * 14;
        randNumY = 45 + ((int) random(65)) * 14;
        
        // avoid spawn on player body
        for (int i = 0; i < playerSnake.previousPosX.size(); i++) {
            for (int j = 0; j < playerSnake.previousPosY.size(); j++) {
                int checkingX = playerSnake.previousPosX.get(i);
                int checkingY = playerSnake.previousPosY.get(j);
                if (dist(randNumX, randNumY, checkingX, checkingY) <= bodyPosAllowance) {
                    newFood();
                }
            }
        }
        
        // avoid spawn on player head
        if (dist(randNumX, randNumY, playerSnake.headPosX, playerSnake.headPosY) <= headPosAllowance) {
            newFood();
        } else {
            this.foodX = randNumX;
            this.foodY = randNumY;
        }
    }
    
    public void drawFood() {
        fill(255, 0, 0);
        circle(foodX, foodY, 8);
    }
}