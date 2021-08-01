/* Author: Ehtisham Ul Haq 
 * Assignment: Final Project
 * Game Name: Freekick Football
 * Due Date: July 8, 2021
*/

//Import the libraries:
import processing.serial.*;
import processing.sound.*;

Serial myPort;  //serial port

//Boolean variables declaration for controlling different things in the game
boolean isKicking = false;
boolean settingUP = false;
boolean settingDOWN = false;
boolean settingLEFT = false;
boolean settingRIGHT = false;
boolean isSetting = false;
boolean isReady = false;
boolean timeReading = false;
boolean readingTaken = false;
boolean shotTaken = false;
boolean goalScored = false;
boolean goalScreen = false;
boolean goalSfx = false;
boolean gameEndSfx = false;

//Stores time provided by millis(), that's why long is used instead of integer
long startTime;
long movingTime;

//The variable to implement state machine:
int state = 0;
/*
 state = 0: display startscreen;
 state = 1: display instructionsScreen;
 state = 2: display tossScreen;
 state = 3: start the game;
 state = 4: display gameOverScreen;
 */

int turn = int(random(0, 2));
// turn = 0: RED;
// turn = 1: BLUE;

//0 is always coded to Red and 1 to Blue
int shots0 = 5;
int shots1 = 5;

int score0 = 0;
int score1 = 0;

//ArrayLists to store the nature of shots taken by the players (in terms of goal or miss)
ArrayList<Integer> shotsRed = new ArrayList<Integer>();
ArrayList<Integer> shotsBlue = new ArrayList<Integer>();

float LDRreading; //Gets reading from arduino
int goalDetectionThreshold = 150; //The threshold differs according to the brightness in different areas. For my room, 150 works best.

PImage startScreen, instructionsScreen, tossScreen, fieldScreen, statsScreen; //image assets
SoundFile backgroundSound, enterSound, gameOverSound, goalSound, goalMissedSound, whistleSound; //sound assets

void setup() {
  size(1366, 768); // very common resolution

  //Communication with arduino with handshaking:
  String portname=Serial.list()[0];
  myPort = new Serial(this, portname, 9600);
  myPort.clear();
  myPort.bufferUntil('\n');
  
  //Loading image assets:
  startScreen = loadImage("/images/startScreen.jpg");
  instructionsScreen = loadImage("/images/instructionsScreen.png");
  tossScreen = loadImage("/images/toss.jpg");
  fieldScreen = loadImage("/images/field1.png");
  statsScreen = loadImage("/images/statsScreen.png");

  //Loading sound assets:
  backgroundSound = new SoundFile(this, "/sounds/bg.mp3");
  enterSound = new SoundFile(this, "/sounds/enter.mp3");
  gameOverSound = new SoundFile(this, "/sounds/gameEnd.mp3");
  goalSound = new SoundFile(this, "/sounds/goal.mp3");
  goalMissedSound = new SoundFile(this, "/sounds/goalMiss.mp3");
  whistleSound = new SoundFile(this, "/sounds/whistle.mp3");

  backgroundSound.play(); //start playing background sound wth loop
  backgroundSound.loop();
}

void draw() {
  //call different functions on different values for state:
  if (state == 0) {
    startScreen();
  } else if (state == 1) {
    instructions();
  } else if (state == 2) {
    toss();
  } else if (state == 3) {
    game();
  } else if (state == 4) {
    gameOver();
  }
} 

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// startScreen function:
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
void startScreen() {
  image(startScreen, 0, 0, width, height+100);
  PFont algerian = createFont("algerian", 70);
  textFont(algerian);
  fill (255);
  text("Free-kick Football", width/3.8, height/5);
  algerian = createFont("algerian", 40);
  textFont(algerian);
  text("Press Enter to continue...", width/3, height/3); // Swiping to next screen feature is implemented under keyPressed function
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// instructions function:
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

void instructions() {
  image(instructionsScreen, 0, 0, width, height);
}


//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// toss function:
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

//The toss is basically done already while declaring turn variable. This function just shows player who got the first turn:
void toss() {
  image(tossScreen, 0, 0, width, height);
  PFont algerian = createFont("algerian", 35);
  textFont(algerian);
  if (turn == 0) {

    fill(0);
    text("Player", width/2.1, height/1.4);
    fill (255, 0, 40);
    text("RED", width/1.72, height/1.4);
    fill (0);
    text("will take the first shot!", width/1.57, height/1.4);
  } else {
    fill(0);
    text("Player", width/2.1, height/1.4);
    fill (40, 0, 255);
    text("Blue", width/1.72, height/1.4);
    fill (0);
    text("will take the first shot!", width/1.53, height/1.4);
  }
  text("Press Enter to continue...", width/1.8, height/1.25);
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// game function:
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

void game() {
  if (shots0 == 0 && shots1 == 0) { // checks whether the game is still on, otherwise changes state which in turn makes the draw function call the gameOver function
    state = 4;
    gameEndSfx = true; //boolean used to make sure the sound.play() is not called on loop. More on that in gameOver function.
  } else {
    if (!shotTaken) { //this boolean variable allows the statistics screen to show until enter is pressed after which, the next player takes the turn.

      isSetting = true; //When state 3 is reached, player can start setting the ball
      displayField(); //Field with all the instructions to both players is shown.

      if (isReady) { //Once the shot taking player presses R, the below code starts executing:
        
        if (timeReading) {
          
          // Start time(in seconds) is taken only once while movingTime updates continously. So, the difference between these two times will be used to show remaining time to hit the goal...   
          startTime = millis()/1000; 
          movingTime = millis()/1000;
          
          readingTaken = true; // This boolean variable makes sure that if player presses R again, StartTime value remains unchanged
        } 
        
        timeReading = false; // turning timeReading boolean makes sure that StartTime reading is taken only once even whilst we are in the loop by draw function.
        
        if (movingTime-startTime <= 12 && !goalScored) { //goalScored boolean is doing multiple things. Here, it makes sure that as soon as ball is detected by LDR, this if statement which has RETURN keyword becomes false. 
          
          if (movingTime-startTime <= 10) { //Player will be shown 10 seconds time but 2 seconds will be extra since ball takes time to reach LDR. So, if ball goes in the hole at 0 or 1 second remaining, the goal wil be registered because of grace period.
            PFont algerian = createFont("algerian", 30);
            textFont(algerian);
            fill (0);
            text("Remaining Time: " + (10-(movingTime-startTime)), width/2.5, height/10); //Show the time from 10 to 0
          }

          if (LDRreading <= goalDetectionThreshold) {
            goalScored = true;
          }
          movingTime = millis()/1000; // moving Time keeps on updating continously
          goalScreen = true; // boolean used to show the goal score screen untill enter is pressed (see below if statement)
          goalSfx = true; // boolean used to make sure the goal sound effect is played only once while we are in the draw function's loop(see below if statement)
          return; 
        }

        if (turn == 0) {
          if (goalScored) {
            if (goalSfx) {
              goalSound.play();
              goalSfx = false; // So, here we turn this boolean false so this if condition would play only once
            }  
            if (goalScreen) {
              PImage goalScreen = loadImage("/images/goal.png");
              image(goalScreen, 0, 0, width, height);
              return; //Using return keyword so the function would not go any further and the goal screen will be shown until player press enter
            }
            score0++;
            shots0--;
            shotsRed.add(1); // adding 1 means goal scored, adding 0 means goal missed.
          } else {
            if (goalSfx) {
              goalMissedSound.play();
              goalSfx = false;
            }  
            if (goalScreen) {
              PImage goalScreen = loadImage("/images/goalMissed.png");
              image(goalScreen, 0, 0, width, height);
              return;
            }
            shots0--;
            shotsRed.add(0);
          }
        } else {
          if (goalScored) {
            if (goalSfx) {
              goalSound.play();
              goalSfx = false;
            }
            if (goalScreen) {
              PImage goalScreen = loadImage("/images/goal.png");
              image(goalScreen, 0, 0, width, height);
              return;
            }
            score1++;
            shots1--;
            shotsBlue.add(1);
          } else {
            if (goalScreen) {
              if (goalSfx) {
                goalMissedSound.play();
                goalSfx = false;
              }  
              PImage goalScreen = loadImage("/images/goalMissed.png");
              image(goalScreen, 0, 0, width, height);
              return;
            }
            shots1--;
            shotsBlue.add(0);
          }
        }

        displayStats();
        PFont algerian = createFont("algerian", 50);
        textFont(algerian);
        text ("Press Enter to continue...", width/3.8, height/1.2);

        turn = (turn + 1) % 2; // alternate the turn
        goalScored = false;
        isSetting = false;
        readingTaken = false;
        shotTaken = true; // Here we are making tis true so the major part of game function would not be executed until player presses enter
        isReady = false;
      }
    }
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// displayField function, called in game function:
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//


void displayField() {
  image(fieldScreen, 0, 0, width, height);


  if (turn == 0) { //RED's turn to take shot

    fill(0);
    PFont algerian = createFont("algerian", 30);
    textFont(algerian);
    text("Player", width/25, height/3);
    fill (255, 0, 40);
    text("Red", width/7, height/3);
    algerian = createFont("algerian", 14);
    textFont(algerian);
    fill (0);
    text("Adjust the ball position using arrow keys", width/300, height/2.5);
    text("Press R when you are ready to shoot", width/60, height/2.2);

    fill(0);
    algerian = createFont("algerian", 30);
    textFont(algerian);
    text("Player", width/1.24, height/3);
    fill (40, 0, 255);
    text("Blue", width/1.10, height/3);
    algerian = createFont("algerian", 15);
    textFont(algerian);
    fill (0);
    text("Set your fielders on the table", width/1.27, height/2.5);
    text("Follow all the given rules", width/1.25, height/2.2);
  } else if (turn == 1) {

    fill(0);
    PFont algerian = createFont("algerian", 30);
    textFont(algerian);
    text("Player", width/25, height/3);
    fill (40, 0, 255);
    text("Blue", width/7, height/3);
    algerian = createFont("algerian", 14);
    textFont(algerian);
    fill (0);
    text("Adjust the ball position using arrow keys", width/300, height/2.5);
    text("Press R when you are ready to shoot", width/60, height/2.2);

    fill(0);
    algerian = createFont("algerian", 30);
    textFont(algerian);
    text("Player", width/1.24, height/3);
    fill (255, 0, 40);
    text("Red", width/1.10, height/3);
    algerian = createFont("algerian", 15);
    textFont(algerian);
    fill (0);
    text("Set your fielders on the table", width/1.27, height/2.5);
    text("Follow all the given rules", width/1.25, height/2.2);
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// displayStats function, called in game function:
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

void displayStats() {
  //Checks if the scores are tied when the game overs. If that's the case, it increments the remaining shots of both players.
  if (shots0 == 0 && shots1 == 0) {
    if (score0 == score1) {
      shots0++;
      shots1++;
    }
  }
  image(statsScreen, 0, 0, width, height);
  
  //Display green or red ellipses to indicate how the last shots went
  if (shotsRed.size() <= 5) {
    for (int i = 0; i<shotsRed.size(); i++) {
      if (shotsRed.get(i) == 0) {
        fill(255, 0, 40);
      } else {
        fill(0, 255, 40);
      }
      ellipse((width/3.45 + (i*20)), height/3.08, 10, 10);
    }
    
  // if the scores were tied and new shots are given until one of the players wins, the ellipses for the latest five shots are displayed (like what happens in other football games and penalties mathces broadcasts.
  
  } else { 
    for (int i = shotsRed.size() - 5; i<shotsRed.size(); i++) {
      if (shotsRed.get(i) == 0) {
        fill(255, 0, 40);
      } else {
        fill(0, 255, 40);
      }
      ellipse((width/3.45 + ((i-(shotsRed.size() - 5))*20)), height/3.08, 10, 10);
    }
  }  

  if (shotsBlue.size() <= 5) {
    for (int i = 0; i<shotsBlue.size(); i++) {
      if (shotsBlue.get(i) == 0) {
        fill(255, 0, 40);
      } else {
        fill(0, 255, 40);
      }
      ellipse((width/1.47 + (i*20)), height/3.08, 10, 10);
    }
  } else {
    for (int i = shotsBlue.size() - 5; i<shotsBlue.size(); i++) {
      if (shotsBlue.get(i) == 0) {
        fill(255, 0, 40);
      } else {
        fill(0, 255, 40);
      }
      ellipse((width/1.47 + ((i-(shotsBlue.size() - 5))*20)), height/3.08, 10, 10);
    }
  }  

  fill(0);
  PFont algerian = createFont("algerian", 30);
  textFont(algerian);
  text("Player", width/4.5, height/5);
  fill (255, 0, 40);
  text("Red", width/3.05, height/5);
  algerian = createFont("algerian", 20);
  textFont(algerian);
  fill (0);
  
  text("Shots: ", width/4.4, height/3);
  text("Remaining Shots: " + shots0, width/4.4, height/2.5);

  fill(0);
  algerian = createFont("algerian", 30);
  textFont(algerian);
  text("Player", width/1.65, height/5);
  fill (40, 0, 255);
  text("Blue", width/1.4, height/5);
  algerian = createFont("algerian", 20);
  textFont(algerian);
  fill (0);
  
  text("Shots: ", width/1.62, height/3);
  text("Remaining Shots: " + shots1, width/1.62, height/2.5);
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// gameOver function
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//


void gameOver() {
  
  displayStats();
  
  //Display the total score at the end of the game as well:
  
  text("Score: " + score1, width/1.53, height/2.2);
  text("Score: " + score0, width/3.8, height/2.2);
  
  PFont algerian = createFont("algerian", 40);
  textFont(algerian);
  if (score0 > score1) {
    text ("Player", width/2.95, height/1.3);
    fill(255, 0, 40);
    text ("RED", width/2.13, height/1.3);
    fill(0);
    text ("wins!!!", width/1.83, height/1.3);
  } else {
    text ("Player", width/2.95, height/1.3);
    fill(40, 0, 255);
    text ("BLUE", width/2.15, height/1.3);
    fill(0);
    text ("wins!!!", width/1.83, height/1.3);
  }
  algerian = createFont("algerian", 30);
  textFont(algerian);
  text ("click on the screen to restart!", width/3.2, height/1.1);
  if (gameEndSfx) {
    gameOverSound.play();
    gameOverSound.loop();
    gameEndSfx = false; // This allows this if condition to be executed only once while inside the draw function's loop
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// restart function:
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//


void restart() {
  gameOverSound.stop();
  backgroundSound.play();
  backgroundSound.loop();

  isKicking = false;
  settingUP = false;
  settingDOWN = false;
  settingLEFT = false;
  settingRIGHT = false;
  isSetting = false;
  isReady = false;
  timeReading = false;
  readingTaken = false;
  shotTaken = false;
  goalScored = false;
  goalScreen = false;
  state = 0;
  turn = int(random(0, 2));
  shots0 = 5;
  shots1 = 5;
  score0 = 0;
  score1 = 0;
  shotsRed = new ArrayList<Integer>();
  shotsBlue = new ArrayList<Integer>();
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// keyPressed function:
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

void keyPressed() {
  if (state == 0 && keyCode == ENTER) {
    state = 1;
    enterSound.play();
  } else if (state == 1 && keyCode == ENTER) {
    state = 2;
    enterSound.play();
  } else if (state == 2 && keyCode == ENTER) {
    state = 3;
    backgroundSound.stop();
    enterSound.play();
  }

  if (state == 3 && isSetting) {
    if (keyCode == ' ') {
      isKicking = true;
    } else if (keyCode == UP) {
      settingUP = true;
    } else if (keyCode == DOWN) {
      settingDOWN = true;
    } else if (keyCode == LEFT) {
      settingLEFT = true;
    } else if (keyCode == RIGHT) {
      settingRIGHT = true;
    }
  }

  if (state == 3 && keyCode == 'R' && !shotTaken && !goalScreen) {
    if (!readingTaken) {
      timeReading = true;
    }
    isReady = true;
    whistleSound.play();
  }
  if (state == 3 && keyCode == ENTER) {
    if (shotTaken) {
      shotTaken = false;
      enterSound.play();
    }
    if (goalScreen) {
      goalScreen = false;
      enterSound.play();
    }
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// keyReleased function:
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

void keyReleased() {
  isKicking = false;
  settingUP = false;
  settingDOWN = false;
  settingLEFT = false;
  settingRIGHT = false;
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// mousePressed function:
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

void mousePressed() {
  if (state == 4) {
    restart();
  }
}

//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// SerialEvent function:
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

void serialEvent(Serial myPort) {

  String inString = myPort.readStringUntil('\n');
  // checking to make sure the string isn't empty
  if (inString != null) {
    // trimming off whitespace:
    inString = trim(inString);
    // convert to a float
    LDRreading = float(inString); //storing the value from arduino into LDRreading variable
  }
  myPort.write(int(isKicking)+","+int(settingUP)+","+int(settingDOWN)+","+int(settingLEFT)+","+int(settingRIGHT)+"\n"); //Send the motors control values to arduino
}
