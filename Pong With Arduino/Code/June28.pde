/*
 * Student Name: Ehtisham Ul Haq
 * Assignment due date: June 28, 2021
 */

import processing.serial.*;

boolean startGame = false;
float ballSize = 20; //size of the pong ball
float barSize = 200; //size of player's movable bar

//background color and fill color are determined based on the value from LDR:
int backgroundColor;
int fillColor;

Game game;
Serial myPort;  // The serial port

void setup() {
  size(1360, 768);

  String portname=Serial.list()[0];
  myPort = new Serial(this, portname, 9600);
  myPort.clear();
  myPort.bufferUntil('\n');

  game = new Game();
}

class Ball { //This class is used for all the aspects of ball
  float x, y, speedX, speedY, maxSpeedX, maxSpeedY;
  boolean gameOver = false;

  Ball() { //constructor
  
  //starting position of the ball is at the center
    x = width/2; 
    y = height/2;
    
    //ball starts with random speed in x and y directions:
    speedX = random(3, 6);
    speedY = random(3, 6);
    maxSpeedX = 11;
    maxSpeedY = 13;
  }  

  void update() {
    x += speedX;
    y += speedY;

    // if ball hits movable bar, invert Y direction and lights the Green LED for a very short time
    if ( y > height-35 && y < height-20 && x > game.xPos && x < game.xPos+barSize ) {
      game.greenLED = true;
      speedY *= -1;
      y += speedY;
    }

    // if ball hits any of the left or right walls, change the direction of X and increase the speed
    //the speed of the ball increases everytime it hits left and rights walls until it reaches maximum speed.
    
    if (x < 30 || x > width-(30)) {
      if (speedX < maxSpeedX && speedY < maxSpeedY) {
        speedX *= -1.1;
        speedY *= 1.1;
      } else {
        speedX *= -1;
        speedY *= 1;
      }    
    }

    // if ball hits upper wall, change the direction of Y   
    if (y < 30) {
      speedY *= -1;
    }
    
    //if ball goes beyond the movable bar at the bottom, game overs and red LED lits
    if (y > height) {
      game.redLED = true;
      gameOver = true;
    }
  }
  void display() {
    if (startGame) {
      update();
      circle(x, y, ballSize);
    }
  }
}




class Game {
  Ball[] ball = new Ball[2]; // More balls can be created by using bigger array
  float xPos = width/2-barSize; //x position of the player's movable bar.
  boolean keyLeft = false, keyRight = false, redLED = false, greenLED = false;

  Game() {
    for (int i = 0; i < ball.length; i++) {
      ball[i] = new Ball();
    }
  }
  void display() {

    //Check if the game is over:
    for (int i = 0; i < ball.length; i++) {
      if (ball[i].gameOver) {
        background(backgroundColor);

        PFont algerian = createFont("algerian", 40);
        textFont(algerian);
        text("Game Over", width/2.4, height/2.2);
        text("Click To Restart", width/2.7, height/1.8);
        return;
      }
    }

    //Turn both the LEDs off:
    redLED = false;
    greenLED = false;

    //Update the X position of player's bar using the values from two switches on arduino:
    if (keyLeft == true && xPos > 0) {
      xPos -= 15;
    } else if (keyRight == true && xPos < width-barSize) {
      xPos += 15;
    }

    //Display ball(s):
    for (int i = 0; i < ball.length; i++) {
      ball[i].display();
    }

    //Display walls:
    noStroke();
    rect(0, 0, 20, height);
    rect(0, 0, width, 20);
    rect(width-20, 0, 20, height);

    //Display player's bar:
    rect(xPos, height-30, barSize, 20);
  }
}  


void draw() { 
  background(backgroundColor);
  fill(fillColor);
  if (startGame) {
    game.display();
  }
}

void mousePressed() {
  for (int i = 0; i < game.ball.length; i++) { // When game is over, a mouse click will restart the game
    if (game.ball[i].gameOver) {
      game = new Game();
    }
  }
}

void serialEvent(Serial myPort) {
  
  String s=myPort.readStringUntil('\n');
  s=trim(s);
  
  if (s!=null) {
    startGame = true; //do not start the game before getting a value from arduino

    int values[]=int(split(s, ','));

    if (values.length==3) {
      if (values[0] == 1) { //If yellow switch is on, make game.keyRight = true, which in turns update game.xPos variable to move the bar towards right, else make it false and stop the movement.
        game.keyRight = true;
      } else {
        game.keyRight = false;
      }

      if (values[1] == 1) { //If blue switch is on, make game.keyLeft = true, which in turns update game.xPos variable to move the bar towards left, else make it false and stop the movement.
        game.keyLeft = true;
      } else {
        game.keyLeft = false;
      }

      if (values[2] > 400) { // If LDR value is higher than certain level, make the background white with black ball and walls, otherwise make the background black with white ball and walls.
        backgroundColor = 255;
        fillColor = 0;
      } else {
        backgroundColor = 0;
        fillColor = 255;
      }
    }
  }
  myPort.write(int(game.greenLED)+","+int(game.redLED)+"\n"); //Send the LED values back to arduino
}
