## Penguin Rush

![startscreen_shot](https://github.com/ehtishamoas/introToIM/blob/main/midtermProject/startScreen.png)

### Game Description:
Penguine Rush is a 2D platform game where a player controls a penguin using Left, Right, and Up arrow keys to steer it on the screen.  

The player's target is to move towards the right to explore the map and finish the level by entering an igloo while also collecting the fishes to increase the score and avoiding the seals and the ice spikes, colliding with which results in game over.  

The map is made by snow-themed background images, platforms, and different objects like trees and snowmen. Player can make the penguin jump and land on different platforms to collect the fishes and avoid the seals and ice spikes.  

The background music and sound effects for certain occassions (like jump, fish collection, level completion, and game over) are also included in the game.  


### Gameplay Instructions:
* Player can start the game by pressing spacebar button on keyboard.  
* The penguin can be steered using left, right, and up arrow keys on keyboard.  
* Player can increase their score by collecting the fishes. The score is visible on the top right corner of the screen.  
* If the penguin collides with any of the seals or ice spikes, the game would be over.  
* Player can complete a game level by enetering the gate of the igloo located at the end of each level.  
* Then, the player can move to next level or restart the game if all the levels are passed by clicking anywhere on the screen.  
* Once the game is over, the player will be able to restart the game from the current level by clicking on the screen.  

### Game Screenshots:

![gameScreenshot](https://github.com/ehtishamoas/introToIM/blob/main/midtermProject/penguinRushScreenshot.png)

![gameOverScreenshot](https://github.com/ehtishamoas/introToIM/blob/main/midtermProject/gameoverScreenshot.png)

![levelCompleteScreenshot](https://github.com/ehtishamoas/introToIM/blob/main/midtermProject/levelCompleteScreenshot.png)

![gameCompleteScreenshot](https://github.com/ehtishamoas/introToIM/blob/main/midtermProject/gameCompletionScreenshot.png)

### Gameplay Video:
Here is the [link](https://drive.google.com/file/d/1_TCsxud2RSg_5_bGwGXWPmjoosXdw0EB/view?usp=sharing) to the gameplay of the game.

### Major problems encountered and fixed:
* First major problem I experienced was that some of the png images or sprites had empty empty areas around the sides. So, the collisions in the game were inaccurate if I simply used coordinates and image width variables. So, I had to decrease those inaccuracies by using hit and trial method where I added and subtracted values from the variables. I also introduced variable 'r' to use instead of image width and height to lower inaccuracies in geometric calcuations.

* When I was writing code for collision with the spikes, I tried using the same code I used for collision with fishes (coordinates distance formula and variable 'r'). The collision was getting detected at the sides of the spikes but not at the middle. So, I decided to use nested if conditions to check if the x and y coordinates of either side of the penguin are in range of the coordinates of the sides of the spikes in order to accurately detect the collisions.

* When I was creating level 1 using the classes I had built, the height and width calculations to place objets at certain location took a lot of time because the image assets were not well-organized in terms of their sizes and empty areas on the sides. Due to time constraints, I was able to make only one complete level of the game to submit for the assignment. For making new levels in the future, I will first organize all the assets and then start working on the mathematics in order to make levels efficiently.

#### References: 
The free image assets are taken from [link](https://www.gameart2d.com/winter-platformer-game-tileset.html).
