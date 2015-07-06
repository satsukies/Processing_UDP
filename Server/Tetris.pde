static Field[] f = new Field[2];

static boolean[] ready = {
  false, false
};

static boolean begin = true;
static boolean gameStart = false;

static int countDown = 3;
static int second = 0;

static void isGameOverNotif(int playerId) {
  for (int i = 0; i < 2; i++) {
    if (i != playerId - 1) {
      f[i].isWinner = true;
    }
  }
}

class Tetris {
  Tetris() {
    //  size(740, 680);
    //  frameRate(120);

    f[0] = new Field(1);
    f[1] = new Field(2);
  }

  void draw() {
    if (isReady() && gameStart) {
      f[0].draw();
      f[1].draw();
    } else if (begin) {
      for (int i = 0; i < 2; i++) {
        if (ready[i]) {
          drawReady(i);
        }
      }
    } else {
      countDown();
    }
  }

  void keyPressed() {
    f[0].keyPressed();
    f[1].keyPressed();
  }

  void drawReady(int id) {
    rect(f[id].offsetWidth + 70, f[id].offsetHeight + 310, 260, 60);
    textAlign(CENTER);
    textSize(42);
    fill(COLOR_EMPTY);
    text("READY...", f[id].offsetWidth + 200, f[id].offsetHeight + 355);
    fill(COLOR_BLACK);
  }

  void drawCount(int sec) {
    println("drawConunt");
    for (int id = 0; id < 2; id++) {
      rect(f[id].offsetWidth + 70, f[id].offsetHeight + 310, 260, 60);
      textAlign(CENTER);
      textSize(42);
      fill(COLOR_EMPTY);
      text(sec, f[id].offsetWidth + 200, f[id].offsetHeight + 355);
      fill(COLOR_BLACK);
    }
  }

  void recieveUDP(int code, int playerId) {
    if (!ready[playerId - 1]) {
      ready[playerId - 1] = true;
    }

    f[playerId - 1].recieveUdpCode(code);
  }

  boolean isReady() {
    for (int i = 0; i < 2; i++) {
      if (!ready[i]) {
        return false;
      }
    }

    if (begin) {
      begin = false;
      second = second();
    }
    return true;
  }

  void countDown() {
    if (!gameStart) {
      if (second() - second > 0) {
        drawCount(countDown--);
        second = second();
      }

      if (countDown < 0) {
        for(int i = 0; i < 2; i++){
          f[i].setMs();
        }
        gameStart = true;
      }
    }
  }
}

