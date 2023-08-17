public class ScoreManager {
    
    private int getHighScore() {
        String[] score = loadStrings("highscore.txt");
        return Integer.parseInt(score[0]);
    }
    
    public void displayCurrentScore() {
        int currentScore = playerSnake.length;
        fill(0);
        textSize(25);
        text("Current Length: " + currentScore, 10, height / 50);
    }
    
    public void displayHighScore() {
        int currentHighScore = getHighScore();
        fill(0);
        textSize(25);
        text("High Score: " + currentHighScore, width - 200, height / 50);
    }
    
    public void updateHighScore() {
        int currentHighScore = getHighScore();
        if (playerSnake.length > currentHighScore) {
            String strHS = playerSnake.length + "";
            String[] score = {strHS};
            saveStrings("highscore.txt", score);
        }
    }
}