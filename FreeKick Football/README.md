## Freekick Football:

### Game Description:
For my final project, I have created a two-player football freekick game. The processing window shows all the instructions for both the players at the start of the game.

On every turn, one player sets their three players on the game table aiming to prevent the goal from the other player. However, there are certain restrictions for the
players' positions to make the game fair and strategic. The other player of course aims to find their way to hit the ball into the goal with all the fielders on the table.

At first, both of the players get 5 shots each and one with more goals wins the game.
If the game ties after the first 5 shots, both players keep on getting an extra shot until one of them wins the game. After the game ends, hte players can restart the game by clicking on the screen.

### Game Design:

I used a small wooden table and a model-making sheet to make the field. To make the goal, I used some paper straws and small piece of nylon net.

For taking the shot, player can use arrow keys to adjust the shoe's position and spacebar to kick the ball. I used the UHU glue to fix servo motor at the other end of the table from the goal. On top of the servo motor was attached the dc motor. And finally, 
with the dc motor, I attached a small shoe using paper straw and glue. The player can control the servo motor using left and right arrow keys. The dc motor can be controlled
using up and down arrow keys to adjust the shoe's position. Once the player adjusts the shoe's position, they can kick the ball using spacebar. The dc motor moves at full speed
while kicking the ball but the shoe's position has great effect on how hard the shoe hits the ball.

For the goal detection, I came up with a mechanism to use the photoresistor to detect the goal. On the processing side, once the player adjusts the shoe's position and is ready to shoot the ball, they have to press R to indicate that they ae ready. Then, there would be 
10 seconds to hit the ball into goal. In that time, if photoresistor's reading is below the threshold, goal is declared. Otherwise, the goal missed is declared.

### The Codes:

In processing, I used a combination of texts, shapes and free images and sound assets from the internet to make every state of the game (from toss to game over and restart).

My arduino code takes values from processing for operating the motors and gives photoresitor values using handshaking.

The codes for both processing and arduino along with the image and sound assets can be found in my github repository under the Final Project folder.

### Pictures and Videos:

#### Gameplay Video:

Here is the [link](https://drive.google.com/file/d/1EUguWiRGTzXcS7Ev2WdxcLKLuRvj87ar/view?usp=sharing) to the extensive gameplay showing all the features of the game.

#### Circuit Schematic:

Here is the picture of the circuit schematic for the project:

![Photograph](https://github.com/ehtishamoas/introToIM/blob/main/Final%20Project/schematic.png)

#### Pictures of the project:

Here are a few pictures of the project:

The game table with Blue team's players:
![Photograph](https://github.com/ehtishamoas/introToIM/blob/main/Final%20Project/gameTable.png)

The tunnel and the Photoresistor:
![Photograph](https://github.com/ehtishamoas/introToIM/blob/main/Final%20Project/July5Pic2.jpg)

The breadboard and Arduino:
![Photograph](https://github.com/ehtishamoas/introToIM/blob/main/Final%20Project/breadboardAndArduino.png)


### Major Problems Encountered:

The first problem I encountered was related to the goal detection. At first, I tried using the ultrasonic distance-measuring sensor. But the values were inaccurate and thus unreliable.
I solved the problem by using the photoresistor, which proved to be quite accurate and helpful. The only drawback is that one has to update the goal-detection threshold when 
the room light settings change.

The second problem I faced was the uneven surface of the model-making sheet. At first the surface was quite even but after attaching things like goal and servo motor, the sheet 
got pressed from different regions. I used two more layers of chart papers and added some spacings under the table to reduce the effect to great extent. Nevertheless, I have learnt
a lesson to use some harder and more resilient material for such kind of project in the future.

### Clever Things About This Project:

In the goal area, I made a small hole and attached a tunnel to it. At the end of the tunnel, I attached the photoresistor. The idea is that when the ball reaches the end of the tunnel,
it stops right in front of photoresistor which affects the photoresistor's reading by much. I put the photoresistor at the end of the tunnel so that even in a dark room, the photoresistor senses much of the light
and there is reasonable difference in the reading when the ball is in front of it.

Moreover, since it takes some time for the ball to reach photoresistor from the goal, I added 2 seconds grace period so that if the ball reaches goal at 0 or 1 second remaining, the goal would still be declared and the game would be more fair.

Also, instead of just showing the score in numbers, I implemented the more traditional and professional way of displaying the scores. I used green and red ellipses to display the score and when the game ties,
only the last five points are shown like it happens in the famous football games and football penalties broadcasts.
