/* Author Name: Ehtisham Ul Haq
   Assignment: Mid Term Project
   Due Date: June 14, 2021
   Game Name: Penguin Rush
*/   

import processing.sound.*;
Game game; 
boolean start = false;
int level = 1;
int total_levels = 2; //As we create more levels, we can increase this variable to allow them to be played. Currently, the game will allow player to play from the start again after finishing level 2.
SoundFile background_sound, jump_sound, collect_sound, gameOver_sound, levelPass_sound;
PImage startScreen, levelPassScreen, gameOverScreen;

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//GameCharacter Class:
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

class GameCharacter {
  float x, y, r, g, vy, vx;
  PImage img;
  int img_w, img_h, num_frames, frame, dir;

  // here, arguments after g are for images of creatures, where w is width of img, h is height, and num_frames is number of sprites in img, as an img has many small sprites to simulate movement.
  GameCharacter(float _x, float _y, float _r, float _g, String _img, int _w, int _h, int _num_frames) {
    x = _x; // x coordinate of the top left corner of image
    y = _y; // y coordinate of the top left corner of image
    r = _r; // estimate of characters' length and width. It would be used instead of image's length and width because it is more accurate and simpler. The image might contain some empty portions at the side. 
    g = _g; // Ground
    vy = 0; // Velocity y axis
    vx = 0; // Velocity x axis
    img = loadImage("/images/" + _img);
    img_w = _w;
    img_h = _h;
    num_frames = _num_frames;
    frame = 0; //Using the velocity x (vx) of character and num_frames variable, we will manipulate the frame variable to show consecutive image frames to simulate movement.
    dir = RIGHT; //default direction is towards right
  }
  void gravity() {
    // if the character is above the ground, it will slowly move down until it reaches the ground 
    if (y + r >= g) { //r is added to y so that the bottom end of the image will be compared to ground
      vy = 0;
    } else { 
      vy += 0.3;
      if (y + r + vy > g) {
        vy = g - (y + r);
      }
    }  

    for (int i = 0; i < game.platforms.size(); i++) {
      //if character's x and y are within the range of platform's x and y, change the ground variable
      if (y + r <= game.platforms.get(i).y && x + r >= game.platforms.get(i).x && x - r <= game.platforms.get(i).x + game.platforms.get(i).w) {
        g = game.platforms.get(i).y;
        break;
      } else {
        g = game.g;
      }
    }
  }

  void update() {
    gravity();
    y += vy;
    x += vx;
  }

  void display() { //Display methods of all the classes will be called in the display mehod of Game class. And the display method of Game class will be called in draw method
    update();

    if (dir == RIGHT) {
      // Here, the last 4 parameters are used to crop the image to required sprite based  on x_shift and frame variables:
      image(img, x - img_w/2 - game.x_shift, y - img_h/2, img_w, img_h, frame * img_w, 0, (frame + 1) * img_w, img_h); 
    } else if (dir == LEFT) {
      image(img, x - img_w/2 - game.x_shift, y - img_h/2, img_w, img_h, (frame + 1) * img_w, 0, frame * img_w, img_h);
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//Seal Class (Inherited from GameCharacter class):
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

class Seal extends GameCharacter {
  float limitL, limitR;
  Seal(float _x, float _y, float _r, float _g, String _img, int _w, int _h, int _num_frames, float _limitL, float _limitR) {
    super(_x, _y, _r, _g, _img, _w, _h, _num_frames); //invoking constructor of GameCharacter class.

    vx = random(2, 5); //random speed

    int randomDir = int(random(0, 2)); //here 0 would mean left, 1 mean right.

    if (randomDir == 0) { //no need for the condition to set to right because default is already set to right.
      dir = LEFT;
      vx *= -1;
    }    
    
    //Limits on x axis within which a seal can move.
    limitL = _limitL;
    limitR = _limitR;
  }
  void update() {
    gravity();

    y += vy;
    x += vx;
    
    // If the character is moving, the sprite is changed where the rate of change(speed) is calculated by using MOD function with frameCount
    
    if (abs(vx) <=3) {  //if the speed pf seal is slow, then rate of change of sprites will also be slow to give realistic effect.
      if (frameCount%15 == 0 && vx != 0 && vy == 0) {
        frame = (frame + 1) % num_frames;
      } else if (vx == 0) {
        frame = 0;
      }
    } else {
      if (frameCount%10 == 0 && vx != 0 && vy == 0) {
        frame = (frame + 1) % num_frames;
      } else if (vx == 0) {
        frame = 0;
      }
    }  
    
    //Change direction if seal reaches either of the limits
    if (x < limitL) {
      vx *= -1;
      dir = RIGHT;
    } else if ( x>limitR) {
      vx *= -1;
      dir = LEFT;
    }
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//Penguin Class (Inherited from GameCharacer class):
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

class Penguin extends GameCharacter {
  boolean alive = true;
  boolean keyUp = false, keyLeft = false, keyRight= false;

  Penguin(float _x, float _y, float _r, float _g, String _img, int _w, int _h, int _num_frames) {
    super(_x, _y, _r, _g, _img, _w, _h, _num_frames);
  }

  //-----------------------------------------------------------------------------------------------------------------//
  //Update method
  //-----------------------------------------------------------------------------------------------------------------//

  void update() {
    gravity();
    
    //Move the Penguin using left, right, and up keys
    if (keyLeft == true && x - r > 0) {
      vx = -5; 
      dir = LEFT;
    } else if (keyRight == true && x <= game.igloo.x + 200) {
      vx = 5;
      dir = RIGHT;
    } else {
      vx = 0;
    }
    if (keyUp == true && y + r == g) {
      jump_sound.play();
      vy = -10;
    }    

    y += vy;
    x += vx;
    
    if (frameCount%5 == 0 && vx != 0 && vy == 0) { //change of sprites just as in the case with seal class
      frame = (frame + 1) % num_frames;
    } else if (vx == 0) {
      frame = 0;
    }
    
    //determine value for game.x_shift variable using vx value of penguin to scroll background and display objects and images accordingly.
    if (x >= game.w/2) {
      game.x_shift += vx;
    } else if (x < game.w/2) {
      game.x_shift = 0;
    }

    //Level completion:
    
    if ((x == game.igloo.x + 30) && (y > game.igloo.y + game.igloo.w/2)) {
      game.level_pass = true;
      level += 1;
      background_sound.stop();
      levelPass_sound.play();
    }

    //Collision with Seal: 

    for (int i = 0; i < game.seal.size(); i++) {
      if (distance(game.seal.get(i).x, game.seal.get(i).y) <= 110) { //110 is a values obtained using hit and trial method
        // collision
        alive = false;
        background_sound.stop();
        gameOver_sound.play();
      }
    }

    //Collision with spikes: 
    
    Spike s;
    for (int i = 0; i < game.spike.size(); i++) {
      s = game.spike.get(i);
      //cannot use distance formula (with the coordinates of corners of spikes) here because let's say if the penguin jumps in the middle of the spike, collision won't be detected.
      //values 10 and 15 are obtained through hit and trial. They are being added to compensate for empty area at the sides of the png images. 
      if ((x >= s.x && x <= s.x + s.w + 15)||(x+10 >= s.x && x+10 <= s.x + s.w)) { 
        if ((y >= s.y && y <= s.y + s.h)||(y+r >= s.y && y+r <= s.y + s.h)) {
          // collision
          alive = false;
          background_sound.stop();
          gameOver_sound.play();
        }
      }
    }
    
    //Fish collection:
    
    for (int i = 0; i < game.fishes.size(); i++) {
      if ((distance(game.fishes.get(i).x, game.fishes.get(i).y) <= r) || (distance(game.fishes.get(i).x + game.fishes.get(i).w, game.fishes.get(i).y) <= r)) {
        // collection
        collect_sound.play();
        game.score += 5;
        game.fishes.remove(i);
      }
    }
  }
  //-----------------------------------------------------------------------------------------------------------------//
  //Distance method
  //-----------------------------------------------------------------------------------------------------------------//
  float distance (float x1, float y1) {
    return pow((pow((x - x1), 2) + pow((y -y1), 2)), 0.5); //coordinates distance formula
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//Platform Class:
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
class Platform {
  float x, y;
  int w, h;
  PImage img; 
  Platform( float _x, float _y, int _w, int _h, String _img) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    img = loadImage("/images/" + _img);
  }    

  void display() {
    image(img, x - game.x_shift, y, w, h);
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//Fish Class:
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

class Fish {
  float x, y;
  int w, h;
  PImage img; 
  Fish( float _x, float _y, int _w, int _h, String _img) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    img = loadImage("/images/" + _img);
  }    

  void display() {
    image(img, x - game.x_shift, y, w, h);
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//Igloo Class:
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

class Igloo {
  float x, y;
  int w, h;
  PImage img; 
  Igloo( float _x, float _y, int _w, int _h, String _img) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    img = loadImage("/images/" + _img);
  }
  void display() {
    image(img, x - game.x_shift, y, w, h);
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//Spike Class:
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

class Spike {
  float x, y;
  int w, h;
  PImage img; 
  Spike( float _x, float _y, int _w, int _h, String _img) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    img = loadImage("/images/" + _img);
  }    

  void display() {
    image(img, x - game.x_shift, y, w, h);
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//Background Objects Class:
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

class Bg_Objects {
  float x, y;
  int w, h;
  PImage img; 
  Bg_Objects( float _x, float _y, int _w, int _h, String _img) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    img = loadImage("/images/" + _img);
  }
  void display() {
    image(img, x - game.x_shift, y, w, h);
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//SnowFall Class:
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

class Snow {
  float x = random(width);
  float y = random(-200,-20); //An array of ellipses from differetn locations above the canvas to give the snowfall effect
  float w = random(5,10);
  float h = random(5,10);
  float speed = random(2,8); // random speed of ellipses ensures the natural snowfall effect
  
  void fall() {
    y += speed;
    if (y > height) {
      y = random(-200,-20);
    }
  }
  
  void display() {
    noStroke();
    fill(255);
    ellipse(x,y,w,h);
  }  
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//Game Class:
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

class Game {
  int w, h, score;
  float g, x_shift, diff_x_shift; //diff_x_shift will be used for bakground scrolling in the level_update methods.
  boolean level_pass;
  PImage scoreBoard = loadImage("/images/ScoreBoard.png");

  Penguin penguin;
  Igloo igloo;

  ArrayList<Platform> platforms = new ArrayList<Platform>();
  ArrayList<Fish> fishes = new ArrayList<Fish>();
  ArrayList<Seal> seal = new ArrayList<Seal>();
  ArrayList<Spike> spike = new ArrayList<Spike>();
  ArrayList<Bg_Objects> bgObjects = new ArrayList<Bg_Objects>();
  ArrayList<PImage> backgrounds = new ArrayList<PImage>();
  Snow[] snow = new Snow[100];

  //--------------------------------------------------------------------//
  //Constructor:
  //--------------------------------------------------------------------//

  Game(int _w, int _h, float _g) { //g is the ground height from top of the canvas. It is 585 for this image.
    w = _w;
    h = _h;
    g = _g;
    level_pass = false;
    
    for (int i = 0; i < snow.length; i++) {
      snow[i] = new Snow();
    }  

    if (level == 1) {
      level_1_settings();
    } else if (level == 2) {
      level_2_settings();
    }
  }

  //--------------------------------------------------------------------//
  //Game Display Method:
  //--------------------------------------------------------------------//

  void  display() { //This method is called in draw() function
    //Check gameover:
    if (penguin.alive == false) {
      image(gameOverScreen, 0, 0, width, height);
      PFont algerian = createFont("algerian", 40);
      textFont(algerian);
      fill (255, 240, 7);
      text("Score: " + score, width/2.4, height/2.2);
      return; //If game overs, this return command will prevent the display method to run beyond this point. This will ensure that the game over image and text will stay on the canvas until player restarts the game.
    }

    //Check level completion:
    if (level_pass) {
      image(levelPassScreen, 0, 0, width, height);
      fill(0, 250, 154);
      textSize(30);

      if (level <= total_levels) {
        text("Level " + (level - 1) + ": Completed", width/2.8, height/2.9);
        text("Click on the screen to start next level", width/3.5, height/2.5);
        PFont algerian = createFont("algerian", 40);
        textFont(algerian);
        fill (255, 240, 7);
        text("Score: " + score, width/2.7, height/2.1);
      } else {
        text("All levels passed! Click on screen to restart from level 1", width/6.5, height/2.7);
      }  
      return;
    }
    
    //Level update method mainly concerns background layers and their scrolling
    if (level == 1) {
      level_1_update();
    } else if (level == 2) {
      level_2_update();
    }  

    //Display Score
    image(scoreBoard, width/1.17, 0);
    fill(255);
    textSize(20);
    text("Score: " + score, width/1.14, height/8);

    //Display Background Objects
    for (int i = 0; i < game.bgObjects.size(); i++) {
      game.bgObjects.get(i).display();
    }  

    //Display platforms
    for (int i = 0; i < game.platforms.size(); i++) {
      game.platforms.get(i).display();
    }  

    //Display seals
    for (int i = 0; i < game.seal.size(); i++) {
      game.seal.get(i).display();
    }
    //Display igloo

    igloo.display();

    //Display fishes
    for (int i = 0; i < game.fishes.size(); i++) {
      game.fishes.get(i).display();
    }

    //Display Penguin
    penguin.display();

    //Display spikes
    for (int i = 0; i < game.spike.size(); i++) {
      game.spike.get(i).display();
    }
    
    //Display snow (ellipses).
    for (int i = 0; i < game.snow.length;i++) {
      game.snow[i].fall();
      game.snow[i].display();
    }  
  }

  //--------------------------------------------------------------------//
  //Level 1 Settings method:
  //--------------------------------------------------------------------//

  void level_1_settings () {
    x_shift = 0;
    score = 0;

    for (int i = 3; i>0; i--) {
      PImage img;
      img = loadImage("/images/layer" + str(i) + ".png");
      backgrounds.add(img);
    }
    //Here we will create the first level by adding things with accurate calculations:
    
    penguin = new Penguin(100, 100, 30, g, "penguin.png", 57, 65, 4);

    for (int i = 0; i<3; i++) {
      platforms.add(new Platform(200 + i * 300, 450 - (i * 100), 128, 72, "platform.png"));
    }
    for (int i = 0; i<3; i++) {
      fishes.add(new Fish(230 + (i * 300), 400 - (i * 100), 50, 30, "fish.png"));
    }  

    seal.add(new Seal(random(500, 1100), 500, 35, g, "seal.png", 203, 80, 3, 200, 1100));
    bgObjects.add(new Bg_Objects(1000, 457, 128, 128, "rock2.png"));
    bgObjects.add(new Bg_Objects(1100, 457, 128, 128, "tree4.png"));

    

    for (int i = 0; i<2; i++) {
      platforms.add(new Platform(1400 + (i * 400), 430, 128, 72, "platform.png"));
    }
    
    fishes.add(new Fish(1650, 260, 50, 30, "fish.png"));

    spike.add(new Spike(1600, 535, int(random(100, 200)), 50, "spike.png"));
    
    bgObjects.add(new Bg_Objects(2300, 305, 350, 280, "tree3.png"));
    
    
    
    seal.add(new Seal(random(2700, 3030), 500, 35, g, "seal.png", 203, 80, 3, 2700, 3030));
    seal.add(new Seal(random(3350, 3800), 500, 35, g, "seal.png", 203, 80, 3, 3350, 3800));
    
    fishes.add(new Fish(3170, 400, 50, 30, "fish.png"));
    
    platforms.add(new Platform(2750, 450, 64, 72, "platform.png"));
    
    platforms.add(new Platform(2950, 300, 128, 72, "platformStart.png"));
    for (int i = 0; i<2; i++) {
      platforms.add(new Platform(2950 + 128 + (i * 128), 300, 128, 72, "platformMid.png"));
    }
    platforms.add(new Platform(2950+(128*3), 300, 128, 72, "platformEnd.png"));
    fishes.add(new Fish(3170, 150, 50, 30, "fish.png"));
    
    bgObjects.add(new Bg_Objects(3000, 220, 100, 80, "crystal.png"));
    bgObjects.add(new Bg_Objects(3300, 175, 128, 128, "tree4.png"));
    
    
    
    platforms.add(new Platform(3800, 450, 64, 72, "platform.png"));
    fishes.add(new Fish(3930, 150, 50, 30, "fish.png"));
    
    spike.add(new Spike(3928, 535, 200, 50, "spike.png"));
    
    platforms.add(new Platform(4100, 300, 128, 72, "platformStart.png"));
    platforms.add(new Platform(4100 + 128, 300, 128, 72, "platformMid.png"));
    platforms.add(new Platform(4100+(128*2), 300, 128, 72, "platformEnd.png"));
    
    bgObjects.add(new Bg_Objects(4320, 150, 120, 150, "snowman.png"));
    
    fishes.add(new Fish(4250, 400, 50, 30, "fish.png"));
    bgObjects.add(new Bg_Objects(4200, 457, 128, 128, "rock1.png"));
    
    spike.add(new Spike(4460, 535, 200, 50, "spike.png"));
    
    bgObjects.add(new Bg_Objects(4800, 335, 128, 250, "tree1.png"));
    
    
    seal.add(new Seal(random(4800, 5150), 500, 35, g, "seal.png", 203, 80, 3, 4800, 5150));
    
    fishes.add(new Fish(5350, 400, 50, 30, "fish.png"));
    
    spike.add(new Spike(5300, 535, 200, 50, "spike.png"));
    
    for (int i = 0; i<2; i++) {
      seal.add(new Seal(random(5600, 6500), 500, 35, g, "seal.png", 203, 80, 3, 5600, 6500));
    }
    
    platforms.add(new Platform(5700, 440, 128, 72, "platform.png"));
    
    fishes.add(new Fish(5760, 150, 50, 30, "fish.png"));
    
    platforms.add(new Platform(6000, 300, 128, 72, "platformStart.png"));
    platforms.add(new Platform(6000 + 128, 300, 128, 72, "platformMid.png"));
    platforms.add(new Platform(6000+(128*2), 300, 128, 72, "platformEnd.png"));
    
    spike.add(new Spike(6230, 250, 150, 50, "spike.png"));
    
    bgObjects.add(new Bg_Objects(6600, 305, 228, 280, "tree2.png"));
    
    bgObjects.add(new Bg_Objects(6900, 455, 100, 128, "sign.png"));
    
    igloo = new Igloo(7200, 288, 300, 300, "igloo.png");
    
  }

  //--------------------------------------------------------------------//
  //Level 1 Update method:
  //--------------------------------------------------------------------//

  void level_1_update () {
    int cnt = 0;
    for (int i = 0; i < game.backgrounds.size(); i++) {

      // Below statement is used to move all the background layers at different speeds (the closer the faster) to give a natural motion look.
      // x_shift is controlled in Penguin class by vx variable.

      if (cnt == 0) {
        diff_x_shift = x_shift/4;
      } else if (cnt == 1) {
        diff_x_shift = x_shift/3;
      } else if (cnt == 2) {
        diff_x_shift = x_shift/2;
      } else {
        diff_x_shift = x_shift;
      }

      int width_right = int(diff_x_shift % w);
      int width_left = w - width_right;

      image(game.backgrounds.get(i), 0, 0, width_left, h, width_right, 0, w, h);
      image(game.backgrounds.get(i), width_left, 0, width_right, h, 0, 0, width_right, h);
      cnt += 1;
    }
  }

  //--------------------------------------------------------------------//
  //Level 2 Settings method:
  //--------------------------------------------------------------------//

  void level_2_settings () {
    x_shift = 0;
    score = 0;

    penguin = new Penguin(100, 100, 30, g, "penguin.png", 57, 65, 4); // 4 is number of sprites in an image

    igloo = new Igloo(1500, 288, 300, 300, "igloo.png");

    spike.add(new Spike(530, 535, int(random(100, 200)), 50, "spike.png"));

    platforms.add(new Platform(100, 400, 128, 75, "platform.png"));


    for (int i = 0; i<1; i++) {
      fishes.add(new Fish(500, 300, 50, 30, "fish.png"));
    }


    seal.add(new Seal(random(100, 400), 500, 35, g, "seal.png", 203, 80, 3, 100, 400));
    seal.add(new Seal(random(800, 1100), 500, 35, g, "seal.png", 203, 80, 3, 800, 1300));

    for (int i = 3; i>0; i--) {
      PImage img;
      img = loadImage("/images/layer" + str(i) + ".png");
      backgrounds.add(img);
    }
  }

  //--------------------------------------------------------------------//
  //Level 2 Update method:
  //--------------------------------------------------------------------//

  void level_2_update () {
    int cnt = 0;
    for (int i = 0; i < game.backgrounds.size(); i++) {

      // Below statement is used to move all the background images at different speeds (the closer the faster) to give a natural look.
      // x_shift is controlled in Penguin class by vx variable.

      if (cnt == 0) {
        diff_x_shift = x_shift/4;
      } else if (cnt == 1) {
        diff_x_shift = x_shift/3;
      } else if (cnt == 2) {
        diff_x_shift = x_shift/2;
      } else {
        diff_x_shift = x_shift;
      }

      int width_right = int(diff_x_shift % w);
      int width_left = w - width_right;

      image(game.backgrounds.get(i), 0, 0, width_left, h, width_right, 0, w, h);
      image(game.backgrounds.get(i), width_left, 0, width_right, h, 0, 0, width_right, h);
      cnt += 1;
    }
  }
}


//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//Setup Function:
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

void setup() {
  size(1280, 720);
  
  //images Load:
  startScreen = loadImage("/images/startScreen.png");
  levelPassScreen = loadImage("/images/levelCompleteScreen.png");
  gameOverScreen = loadImage("/images/gameOverScreen.png");

  //Sounds load:
  background_sound = new SoundFile(this, "/sounds/background.mp3");
  jump_sound = new SoundFile(this, "/sounds/jump.wav");
  collect_sound = new SoundFile(this, "/sounds/collect.mp3");
  levelPass_sound = new SoundFile(this, "/sounds/levelComplete.mp3");
  gameOver_sound = new SoundFile(this, "/sounds/gameover.mp3");
  background_sound.play();
  background_sound.loop();
  
  //game initalization:
  game = new Game(width, height, 585);
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//Draw Function:
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
void draw() {
  background(255);
  if (!start) {
    image(startScreen, 0, 0, width, height); // Shows the startscreen until player its SpaceBar key.
  } else {
    game.display();
  }
}



//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//Interaction Functions:
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//

void keyPressed() {
  if (keyCode == ' ') {
    start = true;
  } else if (keyCode == LEFT) {
    game.penguin.keyLeft = true;
  } else if (keyCode == RIGHT) {
    game.penguin.keyRight = true;
  } else if (keyCode == UP) {
    game.penguin.keyUp = true;
  }
}
void keyReleased() {
  if (keyCode == LEFT) {
    game.penguin.keyLeft = false;
  } else if (keyCode == RIGHT) {
    game.penguin.keyRight = false;
  } else if (keyCode == UP) {
    game.penguin.keyUp = false;
  }
}

void mouseClicked() {
  if (game.penguin.alive == false) {
    game = new Game(width, height, 585); // since the global variable 'level' keeps track of the level, the current level will be loaded on restart.
    gameOver_sound.stop();
    background_sound.play();
    background_sound.loop();
  }
  
  //If there are next levels from the current level, global variable 'level' (which is incremented after the level completion in penguin class update method) will not be changed 
  //and the game = new game... command will load next level with the help of if conditions in game constructor and display methods.  
  //Otherwise, level variable will be set to 1 and the game = new game... command will load 1st level.
  
  if ((game.level_pass == true) && (level <= total_levels)) { 
    game = new Game(width, height, 585);
    levelPass_sound.stop();
    background_sound.play();
    background_sound.loop();
  } else if ((game.level_pass == true) && (level > total_levels)) {
    level = 1;
    game = new Game(width, height, 585);
    levelPass_sound.stop();
    background_sound.play();
    background_sound.loop();
  }
}
