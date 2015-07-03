class Tetris {
  PFont font;
  boolean gameover=false;
  int y, x, i;
  int[][] field=new int[22][12];
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
  int block_type, block_mode=0;
  int block_gc_y, block_gc_x;//block grid chart
  int ms;
  int point=0, point_line=0;

  Tetris() {
    setup();
  }

  void setup() {
    //frameRate(360); 
    size(800, 680);
    background(0);
    noStroke();
    for (y=0; y<22; y++) {
      for (x=0; x<12; x++) {
        if (x==0||x==11||y==0||y==21) {
          field[y][x]=0;
        } else {
          field[y][x]=1;
        }
      }
    }
    ms=millis();
    font = loadFont("ArialMT-32.vlw");
    textFont(font, 32);
  }


  void draw() {
    if (field[1][5]==3||field[1][6]==3)gameover=true;
    if (millis()-ms>1000&&!gameover) {
      create_block();
      move_block();
      draw_field();
      clear_lines();
      ms=millis();
      message_box();
    } else if (gameover) {
      rect(70, 310, 260, 60);
      textAlign(CENTER);
      textSize(40);
      fill(#ffffff);
      text("gameover", 200, 350);
      fill(#000000);
    }
  }

  void keyPressed() {
    if (key==CODED&&!gameover) {
      if (keyCode==UP) {
        turn_block();
        draw_field();
      } else if (keyCode==DOWN) {
        move_block_down();
        draw_field();
      } else if (keyCode==RIGHT) {
        move_block_right();
        draw_field();
      } else if (keyCode==LEFT) {
        move_block_left();
        draw_field();
      }
    }
  }


  void draw_field() {
    for (y=0; y<22; y++) {
      for (x=0; x<12; x++) {
        if (field[y][x]==0) {
          fill(#cccccc);
          rect(x*30+10, y*30+10, 30, 30);
        } else if (field[y][x]==1) {
          stroke(#f0f0f0);
          fill(#ffffff);
          rect(x*30+10, y*30+10, 30, 30);
          noStroke();
        } else if (field[y][x]==2) {
          stroke(#f0f0f0);
          fill(#ff0000);
          rect(x*30+10, y*30+10, 30, 30);
          noStroke();
        } else if (field[y][x]==3) {
          stroke(#f0f0f0);
          fill(#4528ce);
          rect(x*30+10, y*30+10, 30, 30);
          noStroke();
        }
      }
    }
  }

  void create_block() {
    boolean flag=true;
    for (y=1; y<21; y++) {
      for (x=1; x<11; x++) {
        if (field[y][x]==2)flag=false;
      }
    }
    if (flag) {
      block_type=(int)random(7);
      block_gc_y=1;
      block_gc_x=4;
      block_mode=0;
      for (y=0; y<4; y++) {
        for (x=0; x<4; x++) {
          if (block[block_type][y][x]==1) {
            field[y+1][x+4]=2;
          }
        }
      }
      draw_field();
    }
  }

  void move_block() { 
    if (check_block_down()) {
      block_gc_y++;
      for (y=20; y>0; y--) {
        for (x=10; x>0; x--) {
          if (field[y][x]==2) {
            field[y+1][x]=2;
            field[y][x]=1;
          }
        }
      }
    } else {
      draw_field();
      lock_block();
    }
  }

  void move_block_down() { 
    boolean flag=false;
    if (check_block_down()) {
      for (y=0; y<22; y++) {
        for (x=0; x<12; x++) {
          if (field[y][x]==2) {
            ms=millis()-200;
            flag=true;
            break;
          }
        }
        if (flag)break;
      }
      block_gc_y++;
      for (y=20; y>0; y--) {
        for (x=10; x>0; x--) {
          if (field[y][x]==2) {
            field[y+1][x]=2;
            field[y][x]=1;
          }
        }
      }
    }
  }

  void move_block_right() { 
    if (check_block_right()) {
      block_gc_x++;
      for (y=20; y>0; y--) {
        for (x=10; x>0; x--) {
          if (field[y][x]==2) {
            field[y][x+1]=2;
            field[y][x]=1;
          }
        }
      }
    }
  }

  void move_block_left() {
    if (check_block_left()) {
      block_gc_x--;
      for (y=20; y>0; y--) {
        for (x=1; x<11; x++) {
          if (field[y][x]==2) {
            field[y][x]=1;
            field[y][x-1]=2;
          }
        }
      }
    }
  }

  void lock_block() {
    for (y=0; y<22; y++) {
      for (x=0; x<12; x++) {
        if (field[y][x]==2) {
          field[y][x]=3;
        }
      }
    }
  }

  boolean check_block_down() {
    for (y=21; y>=0; y--) {
      for (x=11; x>=0; x--) {
        if (field[y][x]==2) {
          if (field[y+1][x]==3||field[y+1][x]==0)return false;
        }
      }
    }
    return true;
  }

  boolean check_block_right() {
    for (y=21; y>=0; y--) {
      for (x=11; x>=0; x--) {
        if (field[y][x]==2) {
          if (field[y][x+1]==3||field[y][x+1]==0)return false;
        }
      }
    }
    return true;
  }

  boolean check_block_left() {
    for (y=21; y>=0; y--) {
      for (x=11; x>=0; x--) {
        if (field[y][x]==2) {
          if (field[y][x-1]==3||field[y][x-1]==0)return false;
        }
      }
    }
    return true;
  }

  void turn_block() {
    int[][] block_buf=new int [4][4];
    if (check_block_turn()) {
      for (y=0; y<4; y++) {
        for (x=0; x<4; x++) {
          if (field[block_gc_y+y][block_gc_x+x]==2)field[block_gc_y+y][block_gc_x+x]=1;
          block_buf[y][x]=block[block_type][x][3-y];
        }
      }
      for (y=0; y<4; y++) {
        for (x=0; x<4; x++) {
          if (block_buf[y][x]==1)field[block_gc_y+y][block_gc_x+x]=2;
          block[block_type][y][x]=block_buf[y][x];
        }
      }
      block_mode++;
      if (block_mode==4)block_mode=0;
    }
  }

  boolean check_block_turn() {
    for (y=0; y<4; y++) {
      for (x=0; x<4; x++) {
        if (block[block_type][x][3-y]==1
          &&field[block_gc_y+y][block_gc_x+x]==3
          ||field[block_gc_y+y][block_gc_x+x]==0)return false;
      }
    }
    return true;
  }

  boolean check_line_down() {
    int line=0;
    for (y=21; y>=0; y--) {
      for (x=1; x<11; x++) {
        if (field[y][x]==3) {
          if (field[y+1][x]==1) {
            for (x=1; x<11; x++)line+=field[y+1][x];
            if (line==10) {
              line=0;
              return true;
            } else {
              line=0;
              return false;
            }
          }
        }
      }
    }
    return false;
  }

  void clear_lines() {
    int line=0;
    int[] line_gc_y=new int [20];
    int count_line=0;
    boolean flag=false;
    for (y=1; y<21; y++) {
      for (x=1; x<11; x++) {
        line+=field[y][x];
      }
      if (line==30) {
        flag=true;
        for (x=1; x<11; x++) {
          field[y][x]=1;
        }
        line_gc_y[count_line++]=y;
      }
      line=0;
    }
    if (flag) {
      for (i=0; i<=count_line; i++) {
        for (y=line_gc_y[i]; y>1; y--) {
          for (x=1; x<11; x++) {
            if (field[y][x]==3) {
              field[y][x]=1;
              field[y+1][x]=3;
            }
          }
        }
      }
      if (count_line==1)point+=count_line*10;
      else if (count_line>1&&count_line<4)point+=count_line*20;
      else if (count_line==4)point+=100;
      point_line+=count_line;
      draw_field();
    }
  }

  void message_box() {
    fill(0);
    rect(370, 0, 500, 700);
    fill(#ffffff);
    text("Point :", 500, 570);
    text(point, 615, 570);
    text("Clear line count:", 380, 620);
    text(point_line, 615, 620);
    fill(#000000);
  }

  void recieveKeyData(int x, int y) {
    if (!gameover) {
      if (x == 1) {
        turn_block();
        draw_field();
      } else if (x == 2) {
        move_block_down();
        draw_field();
      } else if (x == 3) {
        move_block_right();
        draw_field();
      } else if (x == 4) {
        move_block_left();
        draw_field();
      }
    }
  }
}

