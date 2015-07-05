static final int FIELD_WINDOW = 0;
static final int FIELD_EMPTY = 1;
static final int FIELD_MOVE = 2;
static final int FIELD_LOCK = 3;

static final int COLOR_WINDOW = #cccccc;
static final int COLOR_EMPTY = #ffffff;
static final int COLOR_MOVE = #ff0000;
static final int COLOR_LOCK = #0000ff;

static final int COLOR_STROKE = #f0f0f0;

static final int COLOR_BLACK = #000000;

static final int FIELD_HEIGHT = 22;
static final int FIELD_WIDTH = 12;

static final int CELL_SIZE = 30;

class Field {
  int x, y;

  int[][] fields = new int[FIELD_HEIGHT][FIELD_WIDTH];

  int offsetWidth = 0;
  int offsetHeight = 0;

  int moveBlockPosX = 0;
  int moveBlockPosY = 0;
  int moveBlockType = 0;

  boolean isWinner = false;

  int gameScore = 0;

  int[][][] block = 
  {
    {
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 1, 1, 0
      }
      , 
      {
        0, 0, 0, 0
      }
    }
    , 
    {
      {
        0, 0, 1, 0
      }
      , 
      {
        0, 0, 1, 0
      }
      , 
      {
        0, 1, 1, 0
      }
      , 
      {
        0, 0, 0, 0
      }
    }
    , 
    {
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 1, 1, 0
      }
      , 
      {
        0, 0, 1, 0
      }
      , 
      {
        0, 0, 0, 0
      }
    }
    , 
    {
      {
        0, 0, 1, 0
      }
      , 
      {
        0, 1, 1, 0
      }
      , 
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 0, 0, 0
      }
    }
    , 
    {
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 1, 1, 0
      }
      , 
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 0, 0, 0
      }
    }
    , 
    {
      {
        0, 1, 1, 0
      }
      , 
      {
        0, 1, 1, 0
      }
      , 
      {
        0, 0, 0, 0
      }
      , 
      {
        0, 0, 0, 0
      }
    }
    , 
    {
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 1, 0, 0
      }
      , 
      {
        0, 1, 0, 0
      }
    }
  };

  int playerId = 0;

  Field(int playerId) {
    this.init();
    this.playerId = playerId;

    offsetWidth = (playerId - 1) * (CELL_SIZE * FIELD_WIDTH);
  }

  //initialize
  void init() {
    for (y = 0; y < FIELD_HEIGHT; y++) {
      for (x = 0; x < FIELD_WIDTH; x++) {
        if (x == 0 || x == (FIELD_WIDTH - 1) || y == 0 || y == (FIELD_HEIGHT - 1)) {
          this.fields[y][x] = FIELD_WINDOW;
        } else {
          this.fields[y][x] = FIELD_EMPTY;
        }
        //if(y == 0 && (x == 0 || x == 11)) this.fields[y][x] = FIELD_LOCK;
      }
    }
  }

  void rectCell() {
    rect(offsetWidth + (x * CELL_SIZE) + 10, offsetHeight + (y * CELL_SIZE) + 10, CELL_SIZE, CELL_SIZE);
  }

  void moveBlock() {
    if (isBlockDown()) {
      moveBlockPosY++;
      for (y = FIELD_HEIGHT - 1; y > 0; y--) {
        for (x = FIELD_WIDTH - 1; x > 0; x--) {
          if (this.fields[y][x] == FIELD_MOVE) {
            this.fields[y + 1][x] = FIELD_MOVE;
            this.fields[y][x] = FIELD_EMPTY;
          }
        }
      }
    } else {
      lockBlock();
    }
  }

  boolean isBlockDown() {
    for (y = FIELD_HEIGHT - 1; y >= 0; y--) {
      for (x = FIELD_WIDTH - 2; x >= 0; x--) {
        if (this.fields[y][x] == FIELD_MOVE) {
          if (this.fields[y + 1][x] == FIELD_LOCK || this.fields[y + 1][x] == FIELD_WINDOW) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void lockBlock() {
    for (y = 0; y < FIELD_HEIGHT; y++) {
      for (x = 0; x < FIELD_WIDTH; x++) {
        if (this.fields[y][x] == FIELD_MOVE) {
          this.fields[y][x] = FIELD_LOCK;
        }
      }
    }
  }

  void generateBlock() {
    if (!isExistsMoveBlock()) {
      moveBlockType = (int)random(7);
      moveBlockPosX = 4;
      moveBlockPosY = 1;
      for (y = 0; y < 4; y++) {
        for (x = 0; x < 4; x++) {
          if (block[moveBlockType][y][x] == 1) {
            this.fields[y + moveBlockPosY][x + moveBlockPosX] = FIELD_MOVE;
          }
        }
      }
      drawField();
    }
  }

  boolean isExistsMoveBlock() {
    for (y = 1; y < FIELD_HEIGHT - 1; y++) {
      for (x = 1; x < FIELD_WIDTH - 1; x++) {
        if (this.fields[y][x] == FIELD_MOVE) {
          return true;
        }
      }
    }
    return false;
  }

  void gameOver() {
    rect(offsetWidth + 70, offsetHeight + 310, 260, 60);
    textAlign(CENTER);
    textSize(42);
    fill(COLOR_EMPTY);
    if (isWinner) {
      text("YOU WIN!", offsetWidth + 200, offsetHeight + 355);
    } else {
      text("YOU LOSE...", offsetWidth + 200, offsetHeight + 355);
    }
    fill(COLOR_BLACK);
  }

  boolean isGameOver() {
    for (x = 0; x < FIELD_WIDTH; x++) {
      if (this.fields[1][x] == FIELD_LOCK) {
        isGameOverNotif(playerId);
        return true;
      }
    }
    return false;
  }

  void moveDown() {
    if (isBlockDown()) {
      moveBlockPosY++;
      for (y = FIELD_HEIGHT - 2; y > 0; y--) {
        for (x = FIELD_WIDTH - 2; x > 0; x--) {
          if (this.fields[y][x] == FIELD_MOVE) {
            this.fields[y + 1][x] = FIELD_MOVE;
            this.fields[y][x] = FIELD_EMPTY;
          }
        }
      }
    }
  }

  void moveRight() {
    if (isBlockRight()) {
      moveBlockPosX++;
      for (y = FIELD_HEIGHT - 2; y > 0; y--) {
        for (x = FIELD_WIDTH - 2; x > 0; x--) {
          if (this.fields[y][x] == FIELD_MOVE) {
            this.fields[y][x + 1] = FIELD_MOVE;
            this.fields[y][x] = FIELD_EMPTY;
          }
        }
      }
    }
  }

  boolean isBlockRight() {
    for (y = FIELD_HEIGHT - 1; y >= 0; y--) {
      for (x = FIELD_WIDTH - 1; x >= 0; x--) {
        if (this.fields[y][x] == FIELD_MOVE) {
          if (this.fields[y][x + 1] == FIELD_LOCK || this.fields[y][x + 1] == FIELD_WINDOW) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void moveLeft() {
    if (isBlockLeft()) {
      moveBlockPosX--;
      for (y = FIELD_HEIGHT - 2; y > 0; y--) {
        for (x = 1; x < FIELD_WIDTH - 2; x++) {
          if (this.fields[y][x] == FIELD_MOVE) {
            this.fields[y][x] = FIELD_EMPTY;
            this.fields[y][x - 1] = FIELD_MOVE;
          }
        }
      }
    }
  }

  boolean isBlockLeft() {
    for (y = FIELD_HEIGHT - 1; y >= 0; y--) {
      for (x = FIELD_WIDTH - 1; x >= 0; x--) {
        if (this.fields[y][x] == FIELD_MOVE) {
          if (this.fields[y][x - 1] == FIELD_LOCK || this.fields[y][x - 1] == FIELD_WINDOW) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void moveTurn() {
    int[][] turnBuffer = new int[4][4];

    if (isBlockTurn()) {
      for (y = 0; y < 4; y++) {
        for (x = 0; x < 4; x++) {
          if (this.fields[moveBlockPosY + y][moveBlockPosX + x] == FIELD_MOVE) {
            this.fields[moveBlockPosY + y][moveBlockPosX + x] = FIELD_EMPTY;
          }
          turnBuffer[y][x] = block[moveBlockType][x][3-y];
        }
      }

      for (y = 0; y < 4; y++) {
        for (x = 0; x < 4; x++) {
          if (turnBuffer[y][x] == 1) {
            this.fields[moveBlockPosY + y][moveBlockPosX + x] = FIELD_MOVE;
          }
          block[moveBlockType][y][x] = turnBuffer[y][x];
        }
      }
    }
  }

  boolean isBlockTurn() {
    for (y = 0; y < 4; y++) {
      for (x = 0; x < 4; x++) {
        if (block[moveBlockType][x][3-y] == 1
          && this.fields[moveBlockPosY + y][moveBlockPosX + x] == FIELD_LOCK
          || this.fields[moveBlockPosY + y][moveBlockPosX + x] == FIELD_WINDOW) {
          return false;
        }
      }
    }
    return true;
  }

  void deleteLines() {
    int lineScore = 0;
    int[] deleteLineList = new int[FIELD_WIDTH - 2];
    int deleteLineNum = 0;
    boolean isExistsDeleteLine = false;

    for (y = 1; y < FIELD_HEIGHT - 1; y++) {
      for (x = 1; x < FIELD_WIDTH - 1; x++) {
        lineScore += this.fields[y][x];
      }

      if (lineScore == (FIELD_WIDTH - 2) * FIELD_LOCK) {
        isExistsDeleteLine = true;
        for (x = 1; x < FIELD_WIDTH - 1; x++) {
          this.fields[y][x] = FIELD_EMPTY;
        }
        deleteLineList[deleteLineNum++] = y;
      }
      lineScore = 0;
    }

    if (isExistsDeleteLine) {
      for (int i = 0; i <= deleteLineNum; i++) {
        for (y = deleteLineList[i]; y > 1; y--) {
          for (x = 1; x < FIELD_WIDTH - 1; x++) {
            if (this.fields[y][x] == FIELD_LOCK) {
              this.fields[y][x] = FIELD_EMPTY;
              this.fields[y + 1][x] = FIELD_LOCK;
            }
          }
        }
      }

      if (deleteLineNum >= 4) {
        gameScore += 100;
      } else if (deleteLineNum > 1) {
        gameScore += deleteLineNum * 20;
      } else if (deleteLineNum > 0) {
        gameScore += deleteLineNum * 10;
      }

      drawField();
    }
  }

  void draw() {
    if (isGameOver() || isWinner) {
      gameOver();
    } else {
      generateBlock();
      moveBlock();
      drawField();
      deleteLines();
    }
  }

  void drawField() {
    for (y = 0; y < FIELD_HEIGHT; y++) {
      for (x = 0; x < FIELD_WIDTH; x++) {
        switch(fields[y][x]) {
        case FIELD_WINDOW:
          fill(COLOR_WINDOW);
          rectCell();
          break;
        case FIELD_EMPTY:
          stroke(COLOR_STROKE);
          fill(COLOR_EMPTY);
          rectCell();
          noStroke();
          break;
        case FIELD_MOVE:
          stroke(COLOR_STROKE);
          fill(COLOR_MOVE);
          rectCell();
          noStroke();
          break;
        case FIELD_LOCK:
          stroke(COLOR_STROKE);
          fill(COLOR_LOCK);
          rectCell();
          noStroke();
          break;
        }
      }
    }
  }

  void keyPressed() {
    if (key==CODED) {
      if (keyCode==UP) {
        moveTurn();
      } else if (keyCode==DOWN) {
        moveDown();
      } else if (keyCode==RIGHT) {
        moveRight();
      } else if (keyCode==LEFT) {
        moveLeft();
      }
    }
  }

  void recieveUdpCode(int code) {
    if (!isGameOver()) {
      switch(code) {
      case 1:
        moveTurn();
        break;
      case 2:
        moveDown();
        break;
      case 3:
        moveRight();
        break;
      case 4:
        moveLeft();
        break;
      default:
        break;
      }
    }
  }
}

