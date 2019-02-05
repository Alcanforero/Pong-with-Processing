import processing.sound.*;

Ball ball;
Player pl1, pl2;
boolean flag, end;
SoundFile bell, bounce1, bounce2, bounce3;

class Ball {
  float x, y, i, j;
  int size;
    
  Ball(int x, int y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
    j = random(6)-3;
    if (random(2)-1 > 0.5) i = 5;
    else i = -5;
    
  }
  
  void paint() {
    ellipse(x, y, size, size);
    move();
  }
  
  void move() {    
    x += i;
    y += j;
    collision();
  }
  
  void collision() {
    if (x > width || x < 0) {
      flag = true;
      thread("sound1");
    }
    if (y > height-size/2 || y < size/2) {
      j *= -1;
      thread("sound2");
    }
    if (x == pl1.getX()+pl1.getW() && (y >= pl1.getY() && y <= pl1.getY()+50.0)) {
      i *= -1;
      thread("sound3");
    }
    if (x == pl2.getX() && (y >= pl2.getY() && y <= pl2.getY()+50.0)) {
      i *= -1;
      thread("sound3");
    }
  }
  
  float getX() { return x; }
}

class Player {
  float x, y;
  int w, h;
  int points;
  
  Player(float x, float y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    points = 0;
  }
  
  void paint() {
    rect(x, y, w, h);
  }
  
  float getX() { return x; }
  float getY() { return y; }
  void setY(float y) { this.y = y; }
  int getW() { return w; }
  int getPoints() { return points; }
  void setPoint(int points) { this.points = points; }
}

void setup() {
  size(800, 500);
  background(0);
  fill(255,255,255);
  textSize(20);
  
  bell = new SoundFile(this, "sounds\\bell.wav");
  bounce1 = new SoundFile(this, "sounds\\bounce1.wav");
  bounce2 = new SoundFile(this, "sounds\\bounce2.wav");
  bounce3 = new SoundFile(this, "sounds\\bounce3.wav");
  
  resetGame();
  //if (keyPressed) keyPressed();
}

void resetGame() {
  ball = new Ball(width/2, height/2, 10);
  pl1 = new Player(50, height/2, 10, 50);
  pl2 = new Player(width-50, height/2, 10, 50);
  flag = false;
  end = false;
}

void draw() {
  background(0);
  fill(100,100,100);   
  text(pl1.getPoints() + " | " + pl2.getPoints(), 375, 50);
  fill(255,255,255);
  
  if (!end) run();
  else {
    if (pl1.getPoints() > pl2.getPoints())
      text("Ha ganado el Jugador 1", 290, 240);
    else
      text("Ha ganado el Jugador 2", 290, 240);
    fill(100,100,100);   
    text("Pulse ENTER para volver a jugar", 250, 270);
  }  
}

void run() {
  if (flag) {
    if (ball.getX() > 0) {
      pl1.setPoint(pl1.getPoints()+1);
    } else {
      pl2.setPoint(pl2.getPoints()+1);
    }
    ball = new Ball(width/2, height/2, 10);
    flag = false;
  }
  ball.paint();
  pl1.paint();
  pl2.paint();
    
  if (pl1.getPoints() == 5 || pl2.getPoints() == 5) {
    end = true;
    thread("sound4");
  }
}

void keyPressed() {
  switch (key) {
    case 'w':
    case 'W': pl1.setY(pl1.getY()-20); break;
    case 's':
    case 'S': pl1.setY(pl1.getY()+20); break;
  }
  switch (keyCode) {
    case UP: pl2.setY(pl2.getY()-10); break;
    case DOWN: pl2.setY(pl2.getY()+10); break;
    case ENTER: if(end) resetGame(); break;
  }
}

void sound1() {
  bounce1.play();
}
void sound2() {
  bounce2.play();
}
void sound3() {
  bounce3.play();
}
void sound4() {
  bell.play();
}
