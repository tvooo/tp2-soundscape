import ddf.minim.*;
import processing.core.*;


public class Ride {
  String filename;
  public AudioPlayer player;
  AudioSample sample;
  float[][] spectrum;
  color col;
  int middlePosition;
  
  Ride(Minim minim, String fn, int midPos) {
    filename = fn;
    player = minim.loadFile(filename, 2048);
    sample = minim.loadSample(filename, 2048);
    spectrum = analyzeUsingAudioSample(sample);
    middlePosition = midPos;
    
    col = color(0,150,0);
  }
  
  public void drawSpectrum(boolean colored) {
    float scaleMod = (float(width) / float(spectrum.length));
    /*println("--");
    println(width);
    println(spectrum.length);
    println(scaleMod);*/
    int scale = 50;
    //int maxValue = max(
    if(colored){
      stroke(col);
    } else {
      stroke(100);
    }
    for(int s = 0; s < spectrum.length; s++)
    {
      
      int i =0;
      float total = 0; 
      for(i = 0; i < spectrum[s].length-1; i++)
      {
          total += spectrum[s][i];
      }
      total = total / scale;
      line(s*scaleMod,total+middlePosition,s*scaleMod,-total+middlePosition);
    }
    stroke(255,0,0);
    line(spectrum.length * scaleMod, 1000, spectrum.length *scaleMod, 0+300);
  }
  
  public void drawPlayhead() {
    drawPlayhead(player);
  }
  
  public void drawPlayhead(AudioPlayer pl) {
    float x;
    if(pl.position() > player.length())
       x = width;
    else
       x = map(pl.position(), 0, player.length() - 1, 0, width);
    strokeWeight(2);
    if(player.isPlaying()) {
      stroke(255,0,0);
    } else {
      stroke(0);
    }
    line(x,middlePosition-50,x,middlePosition+50);
  }
  
  private float[][] analyzeUsingAudioSample(AudioSample jingle)
    {
      float[][] spectra;
      float[] leftChannel = jingle.getChannel(AudioSample.LEFT);
      
      // then we create an array we'll copy sample data into for the FFT object
      // this should be as large as you want your FFT to be. generally speaking, 1024 is probably fine.
      int fftSize = 1024;
      float[] fftSamples = new float[fftSize];
      FFT fft = new FFT( fftSize, jingle.sampleRate() );
      
      // now we'll analyze the samples in chunks
      int totalChunks = (leftChannel.length / fftSize) + 1;
      
      // allocate a 2-dimentional array that will hold all of the spectrum data for all of the chunks.
      // the second dimension if fftSize/2 because the spectrum size is always half the number of samples analyzed.
      spectra = new float[totalChunks][fftSize/2];
      
      for(int chunkIdx = 0; chunkIdx < totalChunks; ++chunkIdx)
      {
        int chunkStartIndex = chunkIdx * fftSize;
       
        // the chunk size will always be fftSize, except for the 
        // last chunk, which will be however many samples are left in source
        int chunkSize = min( leftChannel.length - chunkStartIndex, fftSize );
       
        // copy first chunk into our analysis array
        arraycopy( leftChannel, // source of the copy
                   chunkStartIndex, // index to start in the source
                   fftSamples, // destination of the copy
                   0, // index to copy to
                   chunkSize // how many samples to copy
                  );
          
        // if the chunk was smaller than the fftSize, we need to pad the analysis buffer with zeroes        
        if ( chunkSize < fftSize )
        {
          // we use a system call for this
          Arrays.fill( fftSamples, chunkSize, fftSamples.length - 1, 0.0 );
        }
        
        // now analyze this buffer
        fft.forward( fftSamples );
       
        // and copy the resulting spectrum into our spectra array
        for(int i = 0; i < 512; ++i)
        {
          spectra[chunkIdx][i] = fft.getBand(i);
        }
      }
      
      jingle.close(); 
      
      return spectra;
    }
}
