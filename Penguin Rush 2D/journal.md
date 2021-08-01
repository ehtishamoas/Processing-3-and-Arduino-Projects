## Penguin Rush

### Game Description:
Penguine Rush would be a 2D platform game where a player character (a penguin) can be controlled using arrow keys. The player's target would be to move around the map and collect fishes while avoiding the seals and traps. This idea is inspired by the summer heat these days, and of course my love for the penguins.

### Progress:

#### June 8, 2021: 
I have gathered all the assets required for the game like penguin sprites, platform images, background images, and sounds etc.  
Here is a screenshot of few image assets I have collected for the game:  
![assests_screenshot](https://github.com/ehtishamoas/introToIM/blob/main/midtermProject/assets_screenshot.png)  

I have also started working on the initial structure of the code.

#### June 9, 2021:
I have created gameCharacters class where I included all the important attributes and methods like gravity, update, and display. Then, I created two subclasses one for enemies (seals) and one for the player character (penguin) and inherited both of these classes from the gameCharacters class. I have also created a platform class which will be used to create blocks where the penguin would be able to stand and move by jumping on it.

My next goal is to create the 'game' class where I will create ArrayLists of enemies and platforms and will decide on gameover and restart etc.  

#### June 10, 2021:
I randomly selected the y coordinates from lower part of the canvas (600) for ground, where all the seals and player will move. Then, I created game class where I initiated instances of Penguin class (to display a penguin which is controlled by user) and Seal class (I created 2 seals using an array which appear at a random x direction on canvas).  

I have also roughly figured out math to detect collision between penguin and any seal, and when detected, the screen fills with white color with a text "game over" in the middle of the canvas. Then, when the user clicks anywhere on the screen, the game restarts.

Here is the [link](https://drive.google.com/file/d/1xW_otxVhifuPz0dJM12wCh62Gi3rXxcd/view?usp=sharing) to the video of gameplay.

Here is the code for my game class:

```
class Game {
  int w, h;
  float g, x_shift;
  Penguin penguin;
  ArrayList<Seal> seal = new ArrayList<Seal>();

  Game(int _w, int _h, float _g) { //g is the ground height. It is chosen as 600 right now.
    w = _w;
    h = _h;
    g = _g;
    
    penguin = new Penguin(100, 100, 35, g, "penguin.png", 57, 65, 4); // 11 is number of sprites in an image
    
    for (int i = 0; i<2; i++) {
      seal.add(new Seal(random(200, 1100), 100, 35, g, "seal.png", 203, 80, 3, 200, 1100));
    }
  }

  void  display() {
    if (penguin.alive == false) {
      fill(0);
      textMode(CENTER);
      textSize(40);
      text("Game over", width/2, height/2);
      return;
    }

    for (int i = 0; i < game.seal.size(); i++) {
      game.seal.get(i).display();
    }
    penguin.display();
  }
}
```

#### June 11, 2021:
I have created an ArrayList of PImage objects in Game class, and added all the background layers in the list using for loop. I also created a functionality where the background layers scroll at a different speed when the player moves to the right or left.  

I have also created a Platform class which allows the player to jump onto a platform.

Here is the [link](https://drive.google.com/file/d/1uUqRb82YS-rx_NIwLMy65pXgnoKvLM4U/view?usp=sharing) to the video of the gameplay.

Here is the code for my current Game class:

```
class Game {
  int w, h;
  float g, x_shift, diff_x_shift;
  Penguin penguin;

  ArrayList<Platform> platforms = new ArrayList<Platform>();
  ArrayList<Seal> seal = new ArrayList<Seal>();
  ArrayList<PImage> backgrounds = new ArrayList<PImage>();

  Game(int _w, int _h, float _g) { //g as in ground height. It is 585 for this image.
    w = _w;
    h = _h;
    g = _g;
    x_shift = 0;
    penguin = new Penguin(100, 100, 35, g, "penguin.png", 57, 65, 4); // 4 is number of sprites in an image

    // 200, 500
    // 500, 400
    // 800, 300
    for (int i = 0; i<3; i++) {
      platforms.add(new Platform(200 + i * 300, 450 - (i * 100), 128, 75, "platform.png"));
    }
    platforms.add(new Platform(2000, 450, 128, 75, "platform.png"));
    for (int i = 0; i<2; i++) {
      seal.add(new Seal(random(200, 1100), 100, 35, g, "seal.png", 203, 80, 3, 200, 1100));
    }
    for (int i = 0; i<2; i++) {
      seal.add(new Seal(random(2000, 2800), 100, 35, g, "seal.png", 203, 80, 3, 2000, 2800));//last two are limits where seals can move
    }
    for (int i = 3; i>0; i--) {
      PImage img;
      img = loadImage("/images/layer" + str(i) + ".png");
      backgrounds.add(img);
    }
  }

  void  display() {
    if (penguin.alive == false) {
      fill(0);
      textMode(CENTER);
      textSize(40);
      text("Game over", width/2, height/2);
      return;
    }  
    int cnt = 0;
    for (int i = 0; i < game.backgrounds.size(); i++) {

      // Below statement is used to move all the background images at different speeds to give a natural look.
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

    for (int i = 0; i < game.platforms.size(); i++) {
      game.platforms.get(i).display();
    }    

    // strokeWeight(0)
    // fill(0, 125, 0)
    // rect(0, g, w, h)

    for (int i = 0; i < game.seal.size(); i++) {
      game.seal.get(i).display();
    }
    penguin.display();
  }
}
```

#### June 12, 2021:
I have created Fish class and score variable, so that player can collect fishes in the game and the score (visible on the top-right will be increased). I have also created a spike class, so that when the penguin collides with any of the spikes, the game overs. Lastly, I have created igloo class, so at th end of each level, player will have to move the penguin to the igloo to successfully pass it. 

I have also structured the game class by creating the 2 functions for each level (levelSetting and levelUpdate). This allows the player to play next levels, and continue from the current level if game overs there. I have not created any proper level yet. But I have created 2 very small levels just to ensure that everyting is working properly.

Lastly, I finalized and added the sounds for background, jump, fish collection, game over, and level completion.

As I showed the game to my friends, they pointed out that it would be illogical for the penguin to be able to eliminate seals by jumping on their heads. Morever, the game would also become much easier. This critique seemed plausible to me, and thus I removed that feature.

Here is the [link](https://drive.google.com/file/d/1ncwYIQ4nh55_DclKunNT5kAw6Oz4yK1z/view?usp=sharing) to the gameplay video as of now.

#### June 13, 2021:
I have created background_objects class to add trees, rocks, crystals, snowmen, and signboards to make the game more appealing. 

Then, I constructed 1 complete level of the game to submit for the assignment.

Furthermore, I added snowfall effect using ellipses.

I also wanted to add gaps in the ground platform, falling where would result in game over. But since I implemented ground platform as a background layer, I could not just add the image of gaps while making the last background layer a backgroung of the gap. I have an idea to include this feature: to implement the ground platform layer just like I implemented the above platforms (in level_setting method using a loop). But due to time constraints, I decided to make the game without this feature.

Here is the [link](https://drive.google.com/file/d/1_TCsxud2RSg_5_bGwGXWPmjoosXdw0EB/view?usp=sharing) to the gameplay of the final version of the game.
