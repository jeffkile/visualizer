//The MIT License (MIT) - See Licence.txt for details

//Copyright (c) 2013 Mick Grierson, Matthew Yee-King, Marco Gillies
//
//Run this code using this command from the command line: 
//processing-java --sketch=/Users/jeff/Coursera/DigitalMedia/JeffKile1 --output=/Users/jeff/Coursera/DigitalMedia/out --force --run
//

Maxim maxim;
AudioPlayer player;
//int HORIZONTAL=0;
float[] spec;
float[] lastSpec;
int[] colors;
int xPos;
boolean playit;
float max = 0;
float total = 0, count = 0;
int weight = 100;
float offset = 0;
Slider numOfLines;

void setup()
{
  size(1500, 600);
  numOfLines = new Slider("slider", 5, 1, 50, width-300, 0, 300, 30, HORIZONTAL);

   maxim = new Maxim(this);
  // the sine.wav file contains a rising sine tone
  // to illustrate the meaning of the spectral data
  //player = maxim.loadFile("https://s3.amazonaws.com/Coursera_Processing/SS.wav");
  player = maxim.loadFile("SS.wav");
  // tell the player to analyse its output
  player.setAnalysing(true);

  colorMode(HSB, 100);
  background(0);
  xPos = 0;
  playit = false;

  spec = player.getPowerSpectrum();
  int arrLength = spec.length/weight+1;
  lastSpec = new float[arrLength];
  
  colors = new int[arrLength];
  for(int c=0; c<arrLength; c++)
  {
    colors[c] = (int)random(100);
  }

}

void draw()
{
    numOfLines.display();

  if (playit) {
    player.play();
    // get the analysis output from the player
    spec = player.getPowerSpectrum();
    // we will draw 1x1 pixel dots
    float temp = 0;
    int xChange = 2;
    strokeWeight(1);
    if (spec!=null) // got something to plot!
    {
      // iterate over the values in the spectrum, plotting them down the screen
      //print(spec.length);
      for (int i=1; i< spec.length; i++) 
      {
        if(i%weight==0)
        {
//          stroke(reds[i/weight], blues[i/weight], greens[i/weight]);
            stroke(map(i, 0, spec.length, 60, 100), 100, 100);

          temp += spec[i];
          temp = temp/weight;

          offset = 1.15*i*(height/spec.length); 
          print("\noffset" + offset);
          print("\ni" + i);
           
          if(lastSpec != null)
          {
//            print("\netemp" + temp);
//            print("\n" + (xPos-xChange ) +" " + (int)(lastSpec[i/weight] * height) + " " + xPos + " " +  (int)(temp * height));  

            line(xPos-xChange, 1.35*height -  offset - (int)(lastSpec[i/weight] * height), xPos,  1.35*height - offset - (int)(temp * height));
          }
          else
          {
//            print("lastSpec is null");
            line(0, height + offset, xPos, temp*height+offset);
          }

//          print("lastSpec value " + lastSpec[i/weight]);
          lastSpec[i/weight] = temp;
          temp = 0;
        }
        else if(i==spec.length-1) 
        {
        //do something here
        }

        else
        {
          temp += spec[i];
        }
      }
    }
    // move along the screen 
    xPos += xChange;
    // wipe the screen when we get to the end
    if (xPos > width) {
      xPos = 0;
      background(0);
    }
  }

}

// in mobile safari, we have to trigger the audio playback
// from a finger tap
void mousePressed(){

  if(!numOfLines.mousePressed()){
        
    playit = !playit;
    
    if (playit){
        player.play();
    }
    else {
        player.stop();
    }
  }
}

void mouseDragged(){
    numOfLines.mouseDragged();
}

void mouseReleased(){
    numOfLines.mouseReleased();

    weight = (int)(spec.length/numOfLines.get());
}
