// Andrew Craigie
// BlurringImage class

import java.awt.Color;

class BlurringImage {

  PGraphics graphics;
  PGraphics buffer2;

  PImage image;

  NoiseArray noise_array;

  int w;
  int h;

  BlurringImage(int image_width, int image_height) {

    w = image_width;
    h = image_height;

    graphics = createGraphics(w, h);
    buffer2 = createGraphics(w, h);
    image = createImage(w, h, RGB);

    noise_array = new NoiseArray(w, h, 10, 0.04);
  }

  void clear_graphics() {
    graphics.clear();
  }

  int r(color forR) {
    return (forR >> 16) & 0xFF;
  }
  int g(color forG) {
    return (forG >> 8) & 0xFF;
  }
  int b(color forB) {
    return (forB & 0xFF);
  }
  int a(color forA) {
    return (forA >> 24) & 0xFF;
  }

  void blur() {

    // Blur using the two buffer images
    buffer2.beginDraw();
    graphics.loadPixels();
    buffer2.loadPixels();

    image.loadPixels();

    for (int x = 1; x < w-1; x++) {
      for (int y = 1; y < h-1; y++) {

        int index = x + y * w;

        int index1 = (x+1) + (y) * w;
        int index2 = (x-1) + (y) * w;
        int index3 = (x) + (y+1) * w;
        int index4 = (x) + (y-1) * w;
        color c1 = graphics.pixels[index1];
        color c2 = graphics.pixels[index2];
        color c3 = graphics.pixels[index3];
        color c4 = graphics.pixels[index4];

        int draw_to_index = x + (y-1) * w; // Set blurring 'direction'

        //color c5 = cooling.pixels[index];

        //float newC = brightness(c1) + brightness(c2) + brightness(c3) + brightness(c4);

        int newR = int((r(c1) + r(c2) + r(c3) + r(c4))  * 0.25);
        int newG = int((g(c1) + g(c2) + g(c3) + g(c4))  * 0.25);
        int newB = int((b(c1) + b(c2) + b(c3) + b(c4))  * 0.25);
        int newA = int((a(c1) + a(c2) + a(c3) + a(c4))  * 0.25);
        newA = newA - int((noise_array.get_value_at(index) ));

        color pixColor = color(newR, newG, newB, newA);
        
        buffer2.pixels[draw_to_index] = pixColor;
        image.pixels[index] = pixColor;
        
        
        
      }
    }

    image.updatePixels();
    buffer2.updatePixels();
    buffer2.endDraw();

    // Swap
    PGraphics temp = graphics;
    graphics = buffer2;
    buffer2 = temp;
    
    noise_array.scroll();
  }

  PImage get_image() {
    return image;
  }
}
