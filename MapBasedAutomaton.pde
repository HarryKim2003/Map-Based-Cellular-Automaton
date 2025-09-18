//Creator: Harry Kim//

import processing.sound.*;
SoundFile file;

int n = 300; //Too little or too much will result in a goofy animation.
//Note: Values of n that are too high will blend the cells together, so avoid going beyond 300-ish. 
//400 looks pretty cool though. Especially if you do True-True and spam Left/Right all over the peninsula
//Also avoid very small values. Anything lower than 70 will make the peninsula look goofy. 

// Note 2: The way that this function sets up the cells to stay within land 
// Reminds me of an integral! (Rectangular Approximation Methods). 

boolean favorCapitalists = true;      //Set one of these to false, and the other to true for a win on either side.
boolean favorCommunists = false;        //if you set both to false or both to true... I mean it's gonna be a stalemate (Duh.)
int blinksPerSecond = 60;              // In my opinion, the most interesting animations are created by True-True. Try spamming left/right buttons all over for the best animations.
                                      //False-False is absolutely boring. 
                                       //Change Blinks Per Second as you desire. 
              
boolean playMusic = false; // If you turn this on, it will play some music. HOWEVER! Code may take a few seconds to load up the music file.                                       
                                       
                                       
//READ ME READ ME READ ME READ ME 
// To set the initial distribution of Communism/Capitalistm, hit the LEFT button to place Capitalist states, and hit the RIGHT button to place Communist states.
// If you wish to play God and place more Communists and Capitalists around the country, feel free to do so. 

//Some Variables that will be used in the future. 
float cellSize;        
int hmm = n - n/10;
int counting;

color black = color(0);
color white = color(255);
color red = color(255, 0, 0);
color blue = color(0, 0, 255);

//Here are the double arrays used. 
int[][] communistLevel = new int[n][n];
int[][] capitalistLevel = new int[n][n];
int[][] validSquares = new int[n][n];
int[][] counter = new int[n][n];
int[][] fillColor = new int[n][n];
int[][] pixelData = new int[749][1000]; //Stores data on which pixels are black and white pixels are white.
boolean[][] land;

PImage img;

void setup() {
  //noStroke();  //Reduces blending of the cells.
  size(1000, 1000);  
  cellSize = ((width)/float(n));  
  img = loadImage("KoreanPeninsula.jpg"); //Loads image of Korea from Google. 
  land = new boolean[height][width]; //Booking Hotel Rooms for Land. 
  
  background(255); //Background.
  image(img, 130, 0); //Sets up image such that the orientation is in the middle of the screen. 

  loadPixels();
  landDetermine();
  setInitialValues();
  frameRate(blinksPerSecond); 
  
  if(playMusic == true){
      file = new SoundFile(this, "darius.mp3");
      file.play();
    }
  }
  

void draw() {
  float y = 0; //New Variable for cells y-coordinate. 
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      float x = j*cellSize;

      try {       
        if ( (land[int((2*y+cellSize)/2)][int((2*x+cellSize)/2)])|| (land[int(y)][int(x)]) || (land[int(y+cellSize)][int(x)]) || (land[int(y)][int(x+cellSize)]) || (land[int(y+cellSize)][int(x+cellSize)]) ) {
          determineColor(i, j);  //The line above just detects if a cell is within the Peninsula (Checks all 4 corners, as well as the center. ) If it is within the penisula, the cell is drawn.
          rect(x, y, cellSize, cellSize);
          
        }
      }
      catch(Exception e) {
        //nuthin' ;)
      }
    }  
    y += cellSize;
  }

  setNextGeneration();
}

// Sets all initial cells to be Neutral.
void setInitialValues(){
  for( int rows = 0; rows < n; rows++){
    for( int cols = 0; cols < n; cols++){
        capitalistLevel[rows][cols] = 0;
        communistLevel[rows][cols] = 0;
        //neutral
    }
  }
}

void mousePressed(){      //This is the function that places Communist/Capitalist cells depending on which mouse is pressed. 
  //If the right button is pressed, it sets up a Communist State. 
  if (mouseButton == RIGHT){
   int rowCommunist = int(mouseY/cellSize);
   int colCommunist = int(mouseX/cellSize);
  
  capitalistLevel[rowCommunist][colCommunist] = 0;
  communistLevel[rowCommunist][colCommunist] = 3;
  }
  
  //If the left button pressed, it sets up a Capitalist State. 
  else if (mouseButton == LEFT){
   int rowCommunist = int(mouseY/cellSize);
   int colCommunist = int(mouseX/cellSize);
  
  capitalistLevel[rowCommunist][colCommunist] = 3;
    
  }
}


//Determines what color each cell should be. Used in void draw()
void determineColor(int rows, int cols){
  
  if(communistLevel[rows][cols] == 3){
    fill(255,0,0);
  }
  
  else if (communistLevel[rows][cols] == 2)
    fill(170,0,0);
  
  else if (communistLevel[rows][cols] == 1)
    fill(85,0,0);
    
  else if (capitalistLevel[rows][cols] == 1){
    fill(0,0,85);
  }
    
  else if(capitalistLevel[rows][cols] == 2){
    fill(0,0,170);
  }
  else if(capitalistLevel[rows][cols] == 3){
    fill(0,0,255);
  }
   else
    fill(0,100,0);
}


//Function that determines the next generation.
void setNextGeneration() {
  for ( int rows = 0; rows < n; rows ++) {
    for (int cols = 0; cols < n; cols ++) {
      int communistNeighbours = countCommunistNeighbours(rows, cols);  //Counts communist neighbours
      int capitalistNeighbours = countCapitalistNeighbours(rows, cols); //Counts capitlist neighbours. 
      int thingy = round(random(0,1)); //... definitely could've picked a better name. This gives a 50/50 chance for the favored government to take over the lesser one. 

      if (communistLevel[rows][cols] == 3) {  //If the state is full communist...
        if(capitalistNeighbours > 1){
          if(favorCapitalists == true){ //Only takes place when communism is not favored.
            if(thingy != 1)
            capitalistLevel[rows][cols] = round(random(0,2));    // 1/2 chance to turn into a state 0,1,2 capitalist.
            communistLevel[rows][cols] = 0;
          }
        }
      } 
      
      else if (capitalistLevel[rows][cols] == 3) {      //If the state is full communist...
        if(communistNeighbours > 1){
          if(favorCommunists == true){          //Similar to above, but vis versa. 
            if(thingy != 1)
              communistLevel[rows][cols] = round(random(0,2));
              capitalistLevel[rows][cols] = 0;
          }       
        }
      }
      
      
      else if (communistLevel[rows][cols] == 2) {
        if (communistNeighbours > capitalistNeighbours) {
          counter[rows][cols] += 2;     //After a certain amount of time being around communists, the cell evolves to the next level of communism. 
          if (counter[rows][cols] >= 14) { //Evolution. 
            communistLevel[rows][cols] += 1;
            counter[rows][cols] = 0;
          }
        } else if (communistNeighbours < capitalistNeighbours) { 
          counter[rows][cols] -= 2; //Other way around. After being around a capitalist state as a communist state for too long, it starts losing its feelings towards Communism!
          if (counter[rows][cols] <= -14) {  //Devolution 
            communistLevel[rows][cols] -= 1;
            counter[rows][cols] = 0;
          }
        } else { //commmunistNeighbours = capitalistNeighbours
          counter[rows][cols] += 1;
          if (counter[rows][cols] >= 5) {
            communistLevel[rows][cols] += 1;  //If they're equal, the communist state will continue to evolve. 
            counter[rows][cols] = 0;
          }
        }

      } 
      
      // The else if statements below are essentally exactly the same as the one above, with a few tweaks here and there. 
      
      else if (capitalistLevel[rows][cols] == 2) {

        if (communistNeighbours > capitalistNeighbours) {
          counter[rows][cols] -= 2;
          if (counter[rows][cols] <= -10) {
            capitalistLevel[rows][cols] -= 1;
            counter[rows][cols] = 0;
          }
        } else if (communistNeighbours < capitalistNeighbours) { 
          counter[rows][cols] += 2;
          if (counter[rows][cols] >= 14) {
            capitalistLevel[rows][cols] += 1;
            counter[rows][cols] = 0;
          }
        } else { //commmunistNeighbours = capitalistNeighbours
          counter[rows][cols] += 1;
          if (counter[rows][cols] >= 10) {
            capitalistLevel[rows][cols] += 1;
            counter[rows][cols] = 0;
          }
        } 
      } 
      
      
      else if (communistLevel[rows][cols] == 1) {

        if (communistNeighbours > capitalistNeighbours) {
          counter[rows][cols] += 1;
          if (counter[rows][cols] >= 12) {
            communistLevel[rows][cols] += 1;
            counter[rows][cols] = 0;
          }
        } else if (communistNeighbours < capitalistNeighbours) { 
          counter[rows][cols] -= 1;
          if (counter[rows][cols] <= -12) {
            communistLevel[rows][cols] -= 1;
            counter[rows][cols] = 0;
          } else { //commmunistNeighbours = capitalistNeighbours
          }
        }
        
        
      }       
      else if (capitalistLevel[rows][cols] == 1) {

        if (communistNeighbours < capitalistNeighbours) {
          counter[rows][cols] += 1;
          if (counter[rows][cols] >= 12) {
            capitalistLevel[rows][cols] += 1;
            counter[rows][cols] = 0;
          }
        }
        else if (communistNeighbours > capitalistNeighbours) {
          counter[rows][cols] -= 1;
          if (counter[rows][cols] <= -12){
            capitalistLevel[rows][cols] -= 1;
            counter[rows][cols] = 0;
            
          }
          
        } 
        else { //commmunistNeighbours = capitalistNeighbours
        }        
      } 
      
      // If the cell is neutral...
      
      else if (communistLevel[rows][cols] == 0) {


        if (communistNeighbours > capitalistNeighbours) {
          counter[rows][cols] += 1;
          if(counter[rows][cols] >= 3){ //The cell can be influenced either way! Notice how this one increases the communist level, while the other increases capitalist level.
            communistLevel[rows][cols] += 1;
            counter[rows][cols] = 0;
          }
        } 
        else if (communistNeighbours < capitalistNeighbours) {
          counter[rows][cols] -=1;
          if(counter[rows][cols] <= -3){
            capitalistLevel[rows][cols] += 1;
            counter[rows][cols] = 1;
          }          
        } 
        else { //commmunistNeighbours = capitalistNeighbours
        //nuthin. Neutrals gonna stay neutral. 
        }
      } 

    }
  }
}

int countCommunistNeighbours(int r, int c) {
  int countingLevels = 0; //Coding monkey has coded a simple way to scout for communist neighbours.

  for (int i = -(n/hmm); i <= (n/hmm); i++) {
    for(int j = -(n/hmm); j <= (n/hmm); j++) {
      
      try{
        if((communistLevel[r+i][c+j] == 3) && (i != 0 || j != 0)){
          countingLevels += 3;
        }
        else if((communistLevel[r+i][c+j] == 2) && (i != 0 || j !=0)){
          countingLevels += 2;
      }
        else if((communistLevel[r+i][c+j] == 1) && (i != 0 || j !=0)){
          countingLevels += 1;
        }
      }
      catch(Exception E){
        //nuthin'
      }
    }
  }
  return(countingLevels);
}

int countCapitalistNeighbours(int r, int c) {
  int countingLevels = 0; //Coding monkey has coded a simple way to scout for capitalist neighbours.

  for (int i = -(n/hmm); i <= (n/hmm); i++) {
    for(int j = -(n/hmm); j <= (n/hmm); j++) {
      
      try{
        if((capitalistLevel[r+i][c+j] == 3) && (i != 0 || j != 0)){
          countingLevels += 3;
        }
        else if((capitalistLevel[r+i][c+j] == 2) && (i != 0 || j !=0)){
          countingLevels += 2;
      }
        else if((capitalistLevel[r+i][c+j] == 1) && (i != 0 || j !=0)){
          countingLevels += 1;
        }
      }
      catch(Exception E){
        //nuthin'
      }
    }
  }
  return(countingLevels);
}



void landDetermine() {
  loadPixels(); //Clever little trick. Scans the image for black pixels, and determines that those pixels are made of land. :). 

  for (int i = 0; i< height; i++) {
    for (int j = 0; j < width; j++) {
      if (pixels[width*(i)+j] == black) {
        land[i][j] = true;
      } else {
        land[i][j] = false;
      }
    }
  }  
  updatePixels();
}

