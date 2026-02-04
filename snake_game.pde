int cellSize = 30;
ArrayList<Integer> snakeRow = new ArrayList<Integer>();
ArrayList<Integer> snakeCol = new ArrayList<Integer>();

boolean grow = false;
int appleRow;
int appleCol;

int dx = 1;
int dy = 0;

boolean gameOver = false;
boolean gameStarted = false;
boolean paused = false;

int moveDelay = 15; 
int moveCounter = 0;

int score = 0;

void setup() {
  size(510, 480); 
  resetGame();
}

void draw() {
  background(60);
  drawGrid();
  drawWalls();

  if (!gameStarted) {
    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("PRESS ENTER", width/2, height/2);
    return;
  }

  if (gameOver) {
    fill(255, 0, 0);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("GAME OVER!", width/2, height/2);
    drawScore();
    return;
  }

  drawApple();
  drawSnake();
  drawScore();

  if (!paused) {
    moveCounter++;
    if (moveCounter >= moveDelay) {
      moveSnake(dx, dy);
      moveCounter = 0;
    }
  } else {
    fill(255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("PAUSED", width/2, height/2);
  }
}

void drawGrid() {
  stroke(0, 255, 0);
  strokeWeight(2);
  for (int i = 0; i <= width; i += cellSize) line(i, 0, i, height-30); 
  for (int i = 0; i <= height-30; i += cellSize) line(0, i, width, i);
}

void drawWalls() {
  stroke(255, 0, 0);
  strokeWeight(4);
  noFill();
  rect(0, 0, width, height-30);
}

void drawSnake() {
  noStroke();
  for (int i = 0; i < snakeRow.size(); i++) {
    if (i == 0) fill(255, 255, 0);
    else fill(0, 200, 0);
    circle(snakeCol.get(i) + cellSize/2, snakeRow.get(i) + cellSize/2, cellSize);
  }
}

void moveSnake(int dxStep, int dyStep) {
  int newRow = snakeRow.get(0) + dyStep * cellSize;
  int newCol = snakeCol.get(0) + dxStep * cellSize;

  if (newCol < 0 || newCol > width - cellSize || newRow < 0 || newRow > height - 30 - cellSize) {
    gameOver = true;
    return;
  }

  for (int i = 0; i < snakeRow.size(); i++) {
    if (snakeRow.get(i) == newRow && snakeCol.get(i) == newCol) {
      gameOver = true;
      return;
    }
  }

  snakeRow.add(0, newRow);
  snakeCol.add(0, newCol);

  if (newRow == appleRow && newCol == appleCol) {
    grow = true;
    score++;
    eatApple();
  }

  if (!grow) {
    snakeRow.remove(snakeRow.size() - 1);
    snakeCol.remove(snakeCol.size() - 1);
  } else {
    grow = false;
  }
}

void keyPressed() {
  if (!gameStarted && key == ENTER) {
    gameStarted = true;
    return;
  }

  if (gameOver && key == ENTER) {
    resetGame();
    return;
  }

  if (key == ' ') {
    paused = !paused;
    return;
  }

  if (keyCode == UP && dy == 0) { dx = 0; dy = -1; }
  else if (keyCode == DOWN && dy == 0) { dx = 0; dy = 1; }
  else if (keyCode == LEFT && dx == 0) { dx = -1; dy = 0; }
  else if (keyCode == RIGHT && dx == 0) { dx = 1; dy = 0; }
}

void drawApple() {
  fill(255, 0, 0);
  noStroke();
  circle(appleCol + cellSize/2, appleRow + cellSize/2, cellSize);
}

void eatApple() {
  boolean valid = false;
  while (!valid) {
    appleRow = int(random((height-30) / cellSize)) * cellSize;
    appleCol = int(random(width / cellSize)) * cellSize;

    valid = true;
    for (int i = 0; i < snakeRow.size(); i++) {
      if (snakeRow.get(i) == appleRow && snakeCol.get(i) == appleCol) {
        valid = false;
        break;
      }
    }
  }
}

void drawScore() {
  fill(255);
  textSize(20);
  textAlign(LEFT, CENTER);
  text("Score: " + score, 10, height-15);
}

void resetGame() {
  snakeRow.clear();
  snakeCol.clear();
  snakeRow.add(210); snakeCol.add(210);
  snakeRow.add(210); snakeCol.add(180);
  snakeRow.add(210); snakeCol.add(150);

  dx = 1; dy = 0;
  grow = false;
  gameOver = false;
  paused = false;
  gameStarted = false;
  score = 0; 
  eatApple();
}
