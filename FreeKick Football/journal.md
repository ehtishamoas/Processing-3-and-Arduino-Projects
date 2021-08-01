## Final Project:

### Proposal:
I plan to create a football free-kick game where the player will use servo motor with a small shoe attached will be used to kick the ball with an objective to hit the goal. 

Using processing, player will be instructed to place the ball on the marked location on the field made of cardboard. The servo motor will be placed inside cardboard in such a way that the player can adjust its location by sliding it.

The player will also be instructed to set the field as per shown on the screen.

Then, the player will be asked to press the a certain keyboard button to indicate that he/she is ready to take a shot. The player will then have limited time to take a shot (using a certain keyboard button) and hit the goal after he/she presses the ready button.

If the ball goes inside goal within that time, the ultrasonic sensor will detect the ball and player will be awarded a point. Otherwise, player will lose one try.

Player will have three tries before the game overs. The high score will be placed inside a file, which will be updated at the end of each game where any player crosses the high score. 

The game difficulty can be changed by placing more or less players on the field to stop/prevent the ball to reach the goal.

#### Arduino:
The project will require servo motor, ultrasonic sensor, LED lights, and a buzzer.

#### Processing:
The project will use images, sounds, text, and file.

## Journal entries:

### July 2, 2021:

Today I purchased a small ball and model making sheet to be used as the field and pasted a green colored chart paper on it.

Then, I cut 3 boundries from the model making sheet and pasted it on the field. At first I was thinking of using cardoard but the ball does not rebound well from it.

I also made 4 legs for the table by combining many straws.

Furthermore, I bought a shoe shaped keychain, removed the chain from it, and hooked it with the servo motor.

Here is the picture of the material and the progress I made today:

![Photograph](https://github.com/ehtishamoas/introToIM/blob/main/Final%20Project/July2Pic.jpeg)


### July 3, 2021:

Today I created a goal using small net and some paper straws. I also created a hole in the goal place where the ball will fall and detected by the ultrasonic sensor.

I also found the servo motor's speed to be very low. So, I decided to use the dc motor instead. Now I will add the feature to allow the player to use up and down arrow keys to adjust the position of foot and then use the spacebar to kick the ball.

Another next thing I plan on doing is to use servo motor to adjust the horizontal position of the foot. Then, I will draw a semi circle on which the player can set the ball anywhere. Combining this mechanism will provide much greater interactivity to the player and make the game more strategic for the player (especially when there will be fielders on the ground).

Here is the [link](https://drive.google.com/file/d/1hSnmU6uASnU4daqbiLh_kcRR7AeGvoaM/view?usp=sharing) to the video and below is the picture of the table as of now:


![Photograph](https://github.com/ehtishamoas/introToIM/blob/main/Final%20Project/July3Pic.jpeg)


### July 4, 2021:

I have fixed servo motor on the game board (field) and on it the dc motor that is used to move the shoe which in turns kicks the ball.

I have also added features that allows player to control the servo motor (between certain angles) with LEFT and RIGHT arrow keys which allows the player to kick the ball in many different directions to plan the strategy to hit the goal when fielders are on the board.

I have also added the functionality to control the dc motor using keyboard keys in order to adjust the foot and hit the ball.

Moreover, I have started using a super-bouncy rubber ball instead of a plastic ball since the rubber ball retains much of its momentum after colliding with the side walls.

Here is [link](https://drive.google.com/file/d/1IKEQx1xOQliZmNfA6ZptG4-nyvMgKJqo/view?usp=drivesdk) to the video illustrating the working.

For tomorrow, I plan to buy some male to female jumper wires to add the extension to the wires in a way that ultrasonic sensor would be underneath the table just before the goal hole to make it able to detect the falling ball.


### July 5, 2021:

Today I bought some small plastic-made characters and turned them into players using blue and white acrylic paint.

Here is a picture of the game board with players:

![Photograph](https://github.com/ehtishamoas/introToIM/blob/main/Final%20Project/July5Pic1.jpg)

Secondly, I made a small tunnel under the goal which narrows down as the ball slides down so that the ball would leave through one position only.

Then, I made some experiments using ultrasonic distance-measuring sensor. I found the results to be inaccurate and not helpful.

Thus, I acted upon Professor Shiloh's advice to use the Photoresistor. I added the resistor at the end of the tunnel where the ball would stop right in front of it.
So, even in a not-so-bright room, the difference between the photoresistor's readings is quite detectable when the ball is front of it and when the ball is not in front of it.

Here is the picture of the under-the-table set up (photoresistor is marked with red circle):

![Photograph](https://github.com/ehtishamoas/introToIM/blob/main/Final%20Project/July5Pic2.jpg)

Now, my work on the arduino side is done and my focus would be entirely on the processing side for the next couple of days.


### July 6, 2021:

As I started working on the processing, I happened to discuss the game idea with my friends. They suggested that if the game is to be single player, it would be boring. Moreover, one player can always cheat by not placing the fielders on the given positions or by putting the ball inside the goal by hand. Thus, I decided to turn it into a two-player game where each of the players would get 5 shots each. At each turn, one players adjust the shoe's position and takes a shot, while the other player sets the fielders on the board according to the told rules. Both players will make sure that the other one does not cheat.

I also painted three players red while left the other three blue. Each player gets to place three fielders considering the size of the board.

Most imporantly, I used the state machine idea from today's lecture and created different states where each state calls a function. So far, I have created the start screen, the instructions screen, and the toss screen. 

Here is the [link](https://drive.google.com/file/d/1vkTXBu4o-TCMzgL33O_8alJADQYYQHLM/view?usp=sharing) to the video illustrating the working so far.

Below is the code of my draw function so far:

 ```
 void draw() {
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
 ```
 
 And below is the code of my keyPressed function so far:
 
 ```
 void keyPressed() {
  if (state == 0 && keyCode == ENTER) {
    state = 1;
  } else if (state == 1 && keyCode == ENTER) {
    state = 2;
  } else if (state == 2 && keyCode == ENTER) {
    state = 3;
  }

  if (state == 3 && keyCode == 'R') {
    isReady = true;
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
}
 ```

### July 7, 2021:

I have completed creating the final version of my game today.

I added a game function in processing that is the main controlling function of the code. I added the functionality to put red and green ellipses in the stats screen on the basis of whether the player has hit the goal missed. Also, I tried to mimic the football penalties by adding the no-tie rule. So, if the game ties at the first 5 shots, the remaining shots for both players keep on increasing by 1 until one of them wins the game. The ellipses show the last five shots only, just like in all the famous footballl penalty games. However, the total score (number of goals) is displayed at the end of the game.

I also added restart function to make the game capable of restarting rather than closing the program.

Lastly, I added some cool sound effects from internet including background music, screen swipe sound, whistle sound, goal score sound etc.

In processing, I have used images, texts, sounds, and shapes (ellipses) while in arduino, I have used servo motor, dc motor, photoresistor, analog input and analog output. 

Here is the [link](https://drive.google.com/file/d/1EUguWiRGTzXcS7Ev2WdxcLKLuRvj87ar/view?usp=sharing) to the extensive gameplay showing all the features of the game.

The codes for both processing and arduino along with the image and sound assets can be found in my github repository under the Final Project folder.
