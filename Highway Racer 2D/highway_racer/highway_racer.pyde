# Project: Highway Racer
# Team Members: Badr (ba2134@nyu.edu) and Ehtisham Ul Haq (eu2028@nyu.edu)    
#---------------------------------------------------

#██╗░░██╗██╗░██████╗░██╗░░██╗░██╗░░░░░░░██╗░█████╗░██╗░░░██╗   ██████╗░░█████╗░░█████╗░███████╗██████╗░
#██║░░██║██║██╔════╝░██║░░██║░██║░░██╗░░██║██╔══██╗╚██╗░██╔╝   ██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗
#███████║██║██║░░██╗░███████║░╚██╗████╗██╔╝███████║░╚████╔╝░   ██████╔╝███████║██║░░╚═╝█████╗░░██████╔╝
#██╔══██║██║██║░░╚██╗██╔══██║░░████╔═████║░██╔══██║░░╚██╔╝░░   ██╔══██╗██╔══██║██║░░██╗██╔══╝░░██╔══██╗
#██║░░██║██║╚██████╔╝██║░░██║░░╚██╔╝░╚██╔╝░██║░░██║░░░██║░░░   ██║░░██║██║░░██║╚█████╔╝███████╗██║░░██║
#╚═╝░░╚═╝╚═╝░╚═════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝░░░╚═╝░░░   ╚═╝░░╚═╝╚═╝░░╚═╝░╚════╝░╚══════╝╚═╝░░╚═╝

#---------------------------------------------------
# Use LEFT/RIGHT arrows to move the car
# Use SPACE to honk
# Invisibility icon allows you to avoid collisions
#---------------------------------------------------

add_library("minim")
import os, random
player=Minim(this)
path=os.getcwd()

# Global variables:
X=440 # Initial X Coords of the Player's car
Y=630 # Y Coords of the Player's car
KEY_HANDLER = {LEFT:False, RIGHT:False, "1":False, "2":False, "3":False, "p":False, "space":False}

# Other variables:
lst=[]
scroll=20 # For scrolling the background
snow_scroll = 20 # Forscrolling snow effect in snow mode 
car_scroll=20 # For scrolling the first generated vehicle on right side of highway
car2_scroll=20 # For scrolling the next generated vehicle on right side of highway
car_scroll_left=20 # For scrolling the first generated traffic vehicle on left/right side of highway
car2_scroll_left=20 # For scrolling the next generated traffic vehicle on left/right side of highway
feature_scroll = 20 # For scrolling the invisibility icon on left/right side of highway
feature_display = 0 # For displaying the invisibility icon on left/right side of highway
speed=5 # Factor involved in scrolling the background
speed1=5 # Current speed
distance=0 # Current distance 
thescore=0 # Current score
cnt=1 #Multiplier for score boost
mapname="nighttime"

# Boolean variables:
lobby1_display=False 
lobby2_display=False
lobby_display= True 
switch=False
sound1_condition=True
sound2_condition=True
sound3_condition=True

# Importing SFX
lobby_music = player.loadFile(path + "/sounds/lobby.mp3")
menu_sfx = player.loadFile(path + "/sounds/menu.wav")
engine_sfx = player.loadFile(path + "/sounds/engine.wav")
traffic_sfx = player.loadFile(path + "/sounds/traffic.mp3")





#===================================================================================================


class Playercar:
    def __init__(self):
        self.invisible = False
        self.honk = player.loadFile(path + "/sounds/honk.mp3")

    def update(self):  
        if self.invisible == False:
            self.playercar=loadImage(path+"/items/yellowcar"+mapname+".png")
        else:
            self.playercar=loadImage(path+"/items/invisiblecar"+mapname+".png")        
        
        # Move the player car(left or right)
        global X
        if KEY_HANDLER[LEFT] == True and X>83:
            X-=speed//2.5
            if X<=83:
                X=83
        elif KEY_HANDLER[RIGHT] == True and X<508:
            X+=speed//2.5
            if X>=508:
                X=508
        elif KEY_HANDLER["space"] == True:
            self.honk.setGain(-15)
            self.honk.rewind()
            self.honk.play()
        
        # Off-road effect (decreasing the speed of background scroll and traffic vehicles)
        if 220<X<360:
            global scroll, car_scroll, car2_scroll, car_scroll_left, car2_scroll_left
            if 295<=X<360:
                X+=(speed//4)-2
                scroll-=speed//3
                car_scroll-=speed//3
                car2_scroll-=speed//3
                car_scroll_left-=speed//3.5
                car2_scroll_left-=speed//3.5
            if 220<X<295:
                X-=(speed//4)-2
                scroll-=speed//3
                car_scroll-=speed//3
                car2_scroll-=speed//3
                car_scroll_left-=speed//3.5
                car2_scroll_left-=speed//3.5
              
                              
        
    def display(self):
        global X
        self.update()   
        if mapname=="nighttime":
            image(self.playercar, X, Y,65, 125)
        else:
            image(self.playercar, X, Y)
                
        
#===================================================================================================        

# Traffic vehicles on right side of the highway    
class Traffic_right:
    def __init__(self):
        self.taxi_night=loadImage(path+"/items/taxi"+mapname+".png")
        self.graycar=loadImage(path+"/items/graycar"+mapname+".png")
        self.policecar_night=loadImage(path+"/items/policecar"+mapname+".png")
        self.carX=random.choice([370,440,505]) # X coordinate of the first car instantiated on right side of highway on any of the three lanes
        self.car2X=random.choice([370,440,505]) # X coordinate of the next car instantiated on right side of the highway on any of the three lanes
        self.random_car = random.randint(1,3) # For randomly choosing the type of traffic vehicle to be generated first
        self.random_car2 = random.randint(1,3) # For randomly choosing the type of traffic vehicle to be generated next
        self.carY = 0 # This variable will store the changing Y values of first generated traffic vehicle
        self.car2Y = 0 # This variable will store the changing Y values of next generated traffic vehicle
        self.car2_gen = random.choice([ 0, 200, 400, 600, 800, 1000, 1200]) # This list is used to randomly choose the Y distance between the first and the next generated vehicle.
        self.on_road = False # This flag will be used to check if the second vehicle (that is generated relative to the first vehicle) is on the screen or not 
        self.crash = False # This flag becomes true when player car crashes with any of the traffic vehicles
        
    # Generating the first cars on the right side
    def firstcars(self): 
        if self.random_car == 1:
            image(self.taxi_night, self.carX, self.carY-400)
        elif self.random_car == 2:
            image(self.graycar, self.carX, self.carY-400)
        elif self.random_car == 3:
            image(self.policecar_night, self.carX, self.carY-400)
    
    # Moving the first vehicles on right side of the highway      
    def update_firstcars(self):
        global speed, car_scroll, X
        
        # Check if the player car crashes with any vehicles
        if (self.carY >= 940 and self.carY <= 1150) and ((self.carX >= X and self.carX <= X + 55) or (self.carX + 50 >= X and self.carX + 50 <= X + 55)):
            if game.player_car.invisible == False:
                self.crash = True
                
        car_scroll+=speed//1.5
        self.carY = car_scroll - car_scroll//4
        
        
        if self.carY > 1500:
            self.carY= 0
            self.carX= random.choice([370,440,505])
            self.random_car = random.randint(1,3)
            car_scroll=20
            

     
    # Moving the next vehicles on right side of the highway RELATIVE to the first generated vehicle. 
    def update_nextcars(self):
        global speed, car2_scroll, X
        
        if (self.car2Y >= 940 and self.car2Y <= 1150) and ((self.car2X >= X and self.car2X <= X + 55) or (self.car2X + 50 >= X and self.car2X + 50 <= X + 55)):
            if game.player_car.invisible == False:
                self.crash = True
        
        car2_scroll+=speed//1.5
        self.car2Y = car2_scroll - car2_scroll//4
        
        
        if self.car2Y > 1200:    
            self.on_roads = False
            self.car2Y =0
            self.car2_gen = random.choice([0, 200, 400, 600, 800, 1000, 1200])
            self.car2X = random.choice([370,440,505])
            self.random_car2 = random.randint(1,3)
            car2_scroll=20
            self.car2Y = car2_scroll - car2_scroll//4
            
    # Generating other vehicles (without collision)
    def nextcars(self):
         if self.on_road == False:
            if self.carY >= self.car2_gen: 
                    self.on_road = True
            
         if self.on_road == True:
             
             # Avoid multiple cars at the same location
                if (self.carX != self.car2X):
                    self.update_nextcars()
                
                    if self.random_car2 == 1:
                        image(self.taxi_night, self.car2X, self.car2Y-400)
                    elif self.random_car2 == 2:
                        image(self.graycar, self.car2X, self.car2Y-400)
                    elif self.random_car2 == 3:
                        image(self.policecar_night, self.car2X, self.car2Y-400)
                    
                elif (self.carX == self.car2X) and (self.car2Y + 190 < self.carY or self.car2Y - 190 > self.carY):
                    self.update_nextcars()
                
                    if self.random_car2 == 1:
                        image(self.taxi_night, self.car2X, self.car2Y-400)
                    elif self.random_car2 == 2:
                        image(self.graycar, self.car2X, self.car2Y-400)
                    elif self.random_car2 == 3:
                        image(self.policecar_night, self.car2X, self.car2Y-400)
                else:
                    self.car2Y=0
               
    def display(self):
        self.update_firstcars()
        self.firstcars()
        self.nextcars()
     
           
#===================================================================================================
 
# Traffic vehicles on left side of the highway                   
class Traffic_left:
    def __init__(self):
        self.taxi_night=loadImage(path+"/items/taxi"+mapname+"_left.png")
        self.graycar=loadImage(path+"/items/graycar"+mapname+"_left.png")
        self.policecar_night=loadImage(path+"/items/policecar"+mapname+"_left.png")    
        self.carX=random.choice([84,149,212]) # X coordinate of the first car instantiated on right side of highway on any of the three lanes
        self.car2X=random.choice([84,149,212]) # X coordinate of the second car instantiated on right side of the highway on any of the three lanes 
        self.random_car = random.randint(1,3)
        self.random_car2 = random.randint(1,3)
        self.carY = 0
        self.car2Y = 0
        self.car2_gen = random.choice([ 0, 200, 400, 600, 800, 1000, 1200])
        self.on_road = False
        self.crash = False
    
    # Generating the first cars on the left side        
    def firstcars(self): 
        if self.random_car == 1:
            image(self.taxi_night, self.carX, self.carY-400)
        elif self.random_car == 2:
            image(self.graycar, self.carX, self.carY-400)
        elif self.random_car == 3:
            image(self.policecar_night, self.carX, self.carY-400)
    
    # Moving the first vehicles on left side of the highway    
    def update_firstcars(self):
        global speed, car_scroll_left, X
        
        if (self.carY >= 940 and self.carY <= 1150) and ((self.carX >= X and self.carX <= X + 55) or (self.carX + 50 >= X and self.carX + 50 <= X + 55)):
            if game.player_car.invisible == False:
                self.crash = True
        
        car_scroll_left+=speed
        self.carY = car_scroll_left + car_scroll_left//3
        
        
        
        if self.carY > 1500:
            self.carY= 0
            self.carX= random.choice([84,149,212])
            self.random_car = random.randint(1,3)
            car_scroll_left=20
            
    # Moving the next vehicles on left side of the highway RELATIVE to the first generated vehicle.
    def update_nextcars(self):
        global speed, car2_scroll_left, X
        
        if (self.car2Y >= 940 and self.car2Y <= 1150) and ((self.car2X >= X and self.car2X <= X + 55) or (self.car2X + 50 >= X and self.car2X + 50 <= X + 55)):
            if game.player_car.invisible == False:
                self.crash = True
        
        car2_scroll_left+=speed
        self.car2Y = car2_scroll_left + car2_scroll_left//3
        
        
        if self.car2Y > 1200:    
            self.on_roads = False
            self.car2Y =0
            self.car2_gen = random.choice([0, 200, 400, 600, 800, 1000, 1200])
            self.car2X = random.choice([84,149,212])
            self.random_car2 = random.randint(1,3)
            car2_scroll_left=20
            self.car2Y = car2_scroll_left + car2_scroll_left//3
            
    # Generating other vehicles (without collision)        
    def nextcars(self):
        
         if self.on_road == False:
            if self.carY >= self.car2_gen:
                    self.on_road = True
            
         if self.on_road == True:
            
                # Avoid multiple cars at the same location            
                if (self.carX != self.car2X):
                    self.update_nextcars()
                    if self.random_car2 == 1:
                        image(self.taxi_night, self.car2X, self.car2Y-400)
                    elif self.random_car2 == 2:
                        image(self.graycar, self.car2X, self.car2Y-400)
                    elif self.random_car2 == 3:
                        image(self.policecar_night, self.car2X, self.car2Y-400)
                    
                elif (self.carX == self.car2X) and (self.car2Y + 190 < self.carY or self.car2Y - 190 > self.carY):
                    self.update_nextcars()
                    if self.random_car2 == 1:
                        image(self.taxi_night, self.car2X, self.car2Y-400)
                    elif self.random_car2 == 2:
                        image(self.graycar, self.car2X, self.car2Y-400)
                    elif self.random_car2 == 3:
                        image(self.policecar_night, self.car2X, self.car2Y-400)
                else:
                    self.car2Y=0
    
    def display(self):    
        self.update_firstcars()
        self.firstcars()
        self.nextcars()


#===================================================================================================    

# Feature: Invisibility                                                
class Feature_invisible:
    
    def __init__(self):
        self.icon = loadImage(path+"/items/invisible_icon.png")
        self.X = random.choice([84,149,212,370,440,505])
        self.Y = 0
        self.on_road = False
        self.started = False
        
        
    def update(self):
        global feature_scroll, speed, X, feature_display
        feature_scroll+=speed//1.5
        self.Y = feature_scroll - feature_scroll//2
        
        if (self.Y >= 980 and self.Y <= 1150) and ((self.X >= X and self.X <= X + 55) or (self.X + 50 >= X and self.X + 50 <= X + 55)):
            game.player_car.invisible = True
            self.started = True
            self.on_road = False
            self.Y = 0
            self.X = random.choice([84,149,212,370,440,505])
            feature_scroll = 20
                       
        if self.Y > 1200:
            self.on_road = False
            self.Y = 0
            self.X = random.choice([84,149,212,370,440,505])
            feature_scroll = 20
                    
    def display(self):
        self.update()
        image(self.icon, self.X, self.Y-400)
                               

#===================================================================================================


class Game:
    def __init__(self):
        self.player_car=Playercar()
        self.traffic_right = Traffic_right()
        self.traffic_left = Traffic_left()
        self.feature = Feature_invisible()
        self.game_over = False # To declare game over.
        self.restart_game = False # To restart the game when user clicks on screen
        self.background_sound = player.loadFile(path + "/sounds/engine.wav")
        

    # Movement of the background    
    def update(self):
        global scroll,speed,speed1,distance, snow_scroll
        scroll += speed
        snow_scroll += speed*3
        
        # Car speed
        speed += 0.4
        if switch==False:
            speed1 += 1.2
            
        if scroll >= 800:
            scroll = 0    
            
        if snow_scroll >= 800:
            snow_scroll = 0
            
        # Max car speed
        if speed >= 40:
            speed = 40
        if speed1>=120:
            speed1=120
        
       
                         
    # Game over / Restart the game        
    def gameOver(self):
        global speed1,distance,thescore, engine_sfx, X
        gameover1=loadImage(path+"/items/gameover.png")
        self.crashgif=loadImage(path+"/items/crash2.gif")
        image(self.crashgif,X-100,Y-150)
        image(gameover1,70,350)
        engine_sfx.mute()
        traffic_sfx.mute()
        speed1=speed1
        distance=distance
        thescore=thescore

        # Restart the game when user clicks on screen.
        if self.restart_game == True:
            
            # Re-initiating all the variables
            global scroll, car_scroll, car2_scroll, car_scroll_left, car2_scroll_left, speed, speed1, feature_display, feature_scroll, lobby2_display, lobby1_display, switch, engine_sfx, lobby_music
            self.__init__()
            scroll=20
            car_scroll=20
            car2_scroll=20
            car_scroll_left=20 
            car2_scroll_left=20
            speed1=5
            distance=0
            thescore=0
            feature_scroll = 20
            feature_display = 0
            speed=5
            X=440 
            sound1_condition=True
            sound2_condition=True
            sound3_condition=True
            lobby2_display=False
            lobby1_display=True
            switch=False
            engine_sfx.mute()
            traffic_sfx.mute()
            lobby_music.unmute()
            
            self.game_over = False 
            self.restart_game == False

    def display(self):
        global sound1_condition
        self.background = loadImage(path+"/items/map"+mapname+".png")
        
        
        
            
        image(self.background, 0, scroll, 650, 800)
        image(self.background, 0, -800+scroll, 650, 800)
        
        if mapname == "snowtime":
            self.snow = loadImage(path+"/items/snow.gif")
            image(self.snow, 0, snow_scroll, 650, 800)
            image(self.snow, 0, -800+snow_scroll, 650, 800)
        
        
        if self.traffic_right.crash == True or self.traffic_left.crash == True:
            if sound1_condition==True:
                crash_sound = player.loadFile(path + "/sounds/crash.wav")
                crash_sound.rewind()
                crash_sound.play()
                sound1_condition=False
            self.game_over = True
            self.gameOver()
        else:
            sound1_condition=True
            self.update()
            self.traffic_right.display()
            self.traffic_left.display()
            self.player_car.display()
            
     # Invisibility properties
            global feature_display, speed1, sound2_condition
            feature_display += int(speed1//30)
        
            if feature_display >= 500 and feature_display <= 520:
                self.feature.on_road = True
            if self.feature.on_road == True:
                self.feature.display()
            
            # The below conditional statement shows warning when there is very less time left for the car to become visible again
            
            if (feature_display > 1020 and feature_display <= 1100) and self.feature.started == True:
                alert = player.loadFile(path + "/sounds/alert.wav")
                if sound2_condition==True:
                    alert.rewind()
                    alert.play()
                    sound2_condition=False
                textSize(20)
                text("Invisibility is \n expiring", 400, 100)
            
            # Generating the invisibility icon 
            if feature_display > 1150:
                sound2_condition=True
                feature_display = 0
                self.feature.started = False
            elif feature_display > 1100:
                sound2_condition=True
                self.player_car.invisible = False
                
            
        
game=Game()

#===================================================================================================    

def setup():
    size(650,800)
    engine_sfx.setGain(-20)
    engine_sfx.loop()
    engine_sfx.mute()
    traffic_sfx.setGain(-10)
    traffic_sfx.loop()
    traffic_sfx.mute()
    lobby_music.setGain(-10)
    lobby_music.loop()
        

def draw():
    frameRate(60)
    
    global lobby_display, lobby1_display, lobby2_display, cnt, mapname, X, switch, game, speed1, distance, thescore, lst, feature_display, lobby_music, sound3_condition
    
    #Below statements are used to display lobby 1 and lobby 2 where player can choose between different maps using different keyboard keys.
    
    lobby1=loadImage(path+"/items/lobby1.png")
    if lobby_display==True:
        image(lobby1,0,0)

    if KEY_HANDLER["p"] == True:
        menu_sfx.rewind()
        menu_sfx.play()
        lobby1_display=True 

    if lobby1_display==True:
        lobby2=loadImage(path+"/items/lobby2.png")
        image(lobby2,0,0)

        if KEY_HANDLER["1"] == True:
            menu_sfx.rewind()
            menu_sfx.play()
            mapname="daytime"
            game=Game()
            lobby2_display=True
        elif KEY_HANDLER["2"] == True:
            menu_sfx.rewind()
            menu_sfx.play()
            mapname="nighttime"
            game=Game()
            lobby2_display=True
        elif KEY_HANDLER["3"] == True:
            menu_sfx.rewind()
            menu_sfx.play()
            mapname="snowtime"
            game=Game()
            lobby2_display=True
            
    if lobby2_display==True:
        lobby_display=False
        lobby1_display=False
        lobby_music.mute()
        game.display()
        
        #Below condition is used to lower the car speed on offroad part between roads
        
        if 220<=X<360 and game.game_over != True:
            lst.append(speed1)
            switch=True
            if speed1<max(lst)//1.2:
                speed1=speed1
            else:
                speed1-=2
        
        if X >=360 or X<220:
            switch=False
            lst=[]
            
        #Below statements are used to display score, distance, and speed on the screen with the relevant images.    
            
        if 0<X<=220 and game.game_over != True:
            textSize(20)
            cnt=2
            if sound3_condition==True:
                score_sound = player.loadFile(path + "/sounds/score2.wav")
                score_sound.rewind()
                score_sound.play()
                sound3_condition=False
            stroke(10)
            text("Score x2",145,80)
        if X>220:
            cnt=1
            sound3_condition=True
            
        speedpng=loadImage(path+"/items/speedpng.png")
        speedleft=loadImage(path+"/items/speedleft.png")
        speedright=loadImage(path+"/items/speedright.png")
        scorepng=loadImage(path+"/items/score1.png")
        image(scorepng,214.5,3)
        image(speedleft,0,740)
        image(speedright,448,740)
        fill(255,255,0)
        textSize(11)
        text("Speed: "+ str(int(speed1))+" km/h", 493, 774)
        if game.game_over != True and lobby2_display==True:
            engine_sfx.unmute()
            traffic_sfx.unmute()
            distance += int(speed1//30)
            thescore += int(((distance+speed)//80)*cnt)
        text("Distance: "+ str(distance)+" m", 67,774)
        textSize(13)
        text("Score: "+str(thescore),285,30)

            
        
#===================================================================================================

def keyPressed():
    if keyCode == LEFT:
        KEY_HANDLER[LEFT] = True
    elif keyCode == RIGHT:
        KEY_HANDLER[RIGHT] = True
    elif key =="1":
        KEY_HANDLER["1"] = True 
    elif key =="2":
        KEY_HANDLER["2"] = True
    elif key =="3":
        KEY_HANDLER["3"] = True
    elif key =="p" or key =="P":
        KEY_HANDLER["p"] = True
    elif key ==" ":
        KEY_HANDLER["space"] = True
        
def keyReleased():
    if keyCode == LEFT:
        KEY_HANDLER[LEFT] = False
    elif keyCode == RIGHT:
        KEY_HANDLER[RIGHT] = False
    elif key =="1":
        KEY_HANDLER["1"] = False
    elif key =="2":
        KEY_HANDLER["2"] = False
    elif key =="3":
        KEY_HANDLER["3"] = False
    elif key =="p" or key =="P":
        KEY_HANDLER["p"] = False
    elif key ==" ":
        KEY_HANDLER["space"] = False
        
def mouseClicked():
    if game.game_over== True:
        game.restart_game = True       
