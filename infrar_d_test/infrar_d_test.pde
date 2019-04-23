/**
* REALLY simple processing sketch for using webcam input
* This sends 100 input values to port 6448 using message /wek/inputs
**/

import processing.video.*;
import oscP5.*;
import netP5.*;

int numPixelsOrig;
int numPixels;
boolean first = true;

int boxWidth = 64;
int boxHeight = 48;

int numHoriz = 640/boxWidth;
int numVert = 480/boxHeight;

color[] downPix = new color[numHoriz * numVert];
color[] darkPix = new color[numHoriz * numVert];


Capture video;

OscP5 oscP5;
NetAddress dest;

void setup() {
 // colorMode(HSB);
  size(640, 480, P2D);

  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    video = new Capture(this, 640, 480);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
   /* println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    } */

   video = new Capture(this, 640, 480);
    
    // Start capturing the images from the camera
    video.start();
    
    numPixelsOrig = video.width * video.height;
    loadPixels();
    noStroke();
  }
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,9000);
  dest = new NetAddress("127.0.0.1",6448);
  
}

void draw() {
  
  if (video.available() == true) {
    video.read();
    
  video.loadPixels(); // Make the pixels of video available
  int boxNum = 0;
  int tot = boxWidth*boxHeight;
  for (int x = 0; x < 640; x += boxWidth) {
     for (int y = 0; y < 480; y += boxHeight) {
        float dark = 0;
        //Læg lysværdierne sammen for hver enkelt pixel i boxen
        for (int i = 0; i < boxWidth; i++) {
           for (int j = 0; j < boxHeight; j++) {
              int index = (x + i) + (y + j) * 640;
              dark += brightness(video.pixels[index]);
           } 
        }
       darkPix[boxNum] =  color(dark/tot);

       fill(darkPix[boxNum]);       
       rect(x, y, boxWidth, boxHeight);
       fill(0);
       text("Box " + boxNum, x, y);
       boxNum++;
     } 
  }

  if(frameCount % 2 == 0)
    sendOsc(darkPix);
  }
 
}

//Send inputs only from left and right top corner
void sendOsc(int[] px) {
  OscMessage msg = new OscMessage("/wek/inputs");
      msg.add(float(px[1])); 
      msg.add(float(px[2])); 
      msg.add(float(px[3])); 
      msg.add(float(px[4])); 
      msg.add(float(px[7])); 
      msg.add(float(px[8])); 
      msg.add(float(px[9])); 
      msg.add(float(px[11])); 
      msg.add(float(px[12])); 
      msg.add(float(px[13])); 
      msg.add(float(px[14])); 
      msg.add(float(px[17])); 
      msg.add(float(px[18])); 
      msg.add(float(px[19])); 
      msg.add(float(px[21])); 
      msg.add(float(px[22]));
      msg.add(float(px[23])); 
      msg.add(float(px[24])); 
      msg.add(float(px[27])); 
      msg.add(float(px[28])); 
      msg.add(float(px[29])); 
      msg.add(float(px[71])); 
      msg.add(float(px[72])); 
      msg.add(float(px[73]));
      msg.add(float(px[74])); 
      msg.add(float(px[77])); 
      msg.add(float(px[78])); 
      msg.add(float(px[79])); 
      msg.add(float(px[81])); 
      msg.add(float(px[82])); 
      msg.add(float(px[83])); 
      msg.add(float(px[84]));
      msg.add(float(px[87])); 
      msg.add(float(px[88])); 
      msg.add(float(px[89])); 
      msg.add(float(px[91])); 
      msg.add(float(px[92])); 
      msg.add(float(px[93])); 
      msg.add(float(px[94])); 
      msg.add(float(px[97]));
      msg.add(float(px[98])); 
      msg.add(float(px[99])); 
  oscP5.send(msg, dest);
/* 
1,2,3,4,11,12,13,14,21,22,23,24
71,72,73,74,81,82,83,84,91,92,93,94
7,8,9,17,18,19,27,28,29
77,78,79,87,88,89,97,98,99
*/
}
