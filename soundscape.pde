
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.spi.*;
import java.util.Arrays; 
Minim minim;

int currentRide = 0;

Ride[] rides = new Ride[5];

void setup()
{
  size(1400, 1000, P3D);

  minim = new Minim(this);
  rides[0] = new Ride(minim, "ride_1a.wav", 100);
  rides[1] = new Ride(minim, "ride_2a.wav", 100 + 200);
  rides[2] = new Ride(minim, "ride_3a.wav", 100 + 400);
  rides[3] = new Ride(minim, "ride_4a.wav", 100 + 600);
  rides[4] = new Ride(minim, "ride_5a.wav", 100 + 800);
}

void drawAnnotation(int start, int end, int y, color c, String title) {
  stroke(c);
  fill(c, 40);
  rect(10,10,100,20);
}

void draw()
{
  // jump back to start position when we get to the end
  
  background(255);
  for(int i = 0; i < rides.length; i++) {
    rides[i].drawSpectrum(currentRide == i);
    if(i == currentRide) {
      rides[i].drawPlayhead();
    } else {
      rides[i].drawPlayhead(rides[currentRide].player);
    }
  }
  /*ride1.drawSpectrum();
  ride2.drawSpectrum();
  ride3.drawSpectrum();
  ride4.drawSpectrum();
  ride1.drawPlayhead();
  ride2.drawPlayhead(ride1.player);
  ride3.drawPlayhead(ride1.player);
  ride4.drawPlayhead(ride1.player);*/
  /*AudioPlayer song = rides[currentRide].player;
  for(int i = 0; i < song.left.size() - 1; i++)
  {
    line(i, 50 + song.left.get(i)*50, i+1, 50 + song.left.get(i+1)*50);
    line(i, 150 + song.right.get(i)*50, i+1, 150 + song.right.get(i+1)*50);
  }
  drawAnnotation(0,0,0,color(0,100,100),"hallo");*/
}

void keyPressed() 
{
  if ( key == 'p' ) {
    if(rides[currentRide].player.isPlaying()) {
      rides[currentRide].player.pause();
    } else {
      rides[currentRide].player.play();
    }
  }
  if (key == CODED) {
    if (keyCode == DOWN) {
      if(currentRide < rides.length - 1) {
        if(rides[currentRide].player.isPlaying()) {
          rides[currentRide].player.pause();
          
          rides[currentRide + 1].player.play();
        }
        rides[currentRide + 1].player.skip(rides[currentRide].player.position() - rides[currentRide + 1].player.position());
        currentRide += 1;
        
      }
    } else if (keyCode == UP) {
      if(currentRide > 0) {
        if(rides[currentRide].player.isPlaying()) {
          rides[currentRide].player.pause();
          
          rides[currentRide - 1].player.play();
        }
        rides[currentRide - 1].player.skip(rides[currentRide].player.position() - rides[currentRide - 1].player.position());
        currentRide -= 1;
      }
    }  else if (keyCode == RIGHT) {
      rides[currentRide].player.skip(500);
    }  else if (keyCode == LEFT) {
      rides[currentRide].player.skip(-500);
    }
  }
  //if ( key == 'k' ) kick.trigger();
}
