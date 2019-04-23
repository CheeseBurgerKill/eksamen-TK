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

int [] graypix = new int [numHoriz * numVert];

Capture video;

OscP5 oscP5;
NetAddress dest;

void setup() {
 // colorMode(HSB);
  size(640, 480);

  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    video = new Capture(this, 640, 480);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
   println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    } 

    video = new Capture(this, 640, 480);
    // Start capturing the images from the camera
    video.start();
    
    numPixelsOrig = video.width * video.height;
    loadPixels();
    noStroke();
  }
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,10000);
  dest = new NetAddress("127.0.0.1",6448);
  
}

void draw() {
  
  if (video.available() == true) {
    video.read();
    image(video, 0, 0);
    
    video.loadPixels(); // Make the pixels of video available
    int boxNum = 0;
    int tot = boxWidth*boxHeight;
  
    for (int x = 0; x < 640; x += boxWidth) {
     for (int y = 0; y < 480; y += boxHeight) {
      float bright = 0; 
        for (int i = 0; i < boxWidth; i++) {
           for (int j = 0; j < boxHeight; j++) {
              int index = (x + i) + (y + j) * 640;
              bright += brightness(video.pixels[index]);
           } 
        }
        println(bright/tot);
        color outp;
        if(bright/tot > 100){
         graypix[boxNum] =  255;
         outp = color(255,255,255,100);
        }else{
         graypix[boxNum] =  0;      
         outp = color(0,0,0,100);
        }
      // downPix[boxNum] = color((float)red/tot, (float)green/tot, (float)blue/tot);
       fill(outp);
       int index = x + 640*y;

       rect(x, y, boxWidth, boxHeight);
       boxNum++;
     } 
  }
  if(frameCount % 2 == 0)
    sendOsc(graypix);
  }
  first = false;
  //fill(0);
  text("Sending 100 inputs to port 6448 using message /wek/inputs", 10, 10);
}


void sendOsc(int[] px) {
  OscMessage msg = new OscMessage("/wek/inputs");
 // msg.add(px);
   for (int i = 0; i < px.length; i++) {
      msg.add(float(px[i])); 
   }
  oscP5.send(msg, dest);
}
