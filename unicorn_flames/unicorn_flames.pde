// Andrew Craigie
// blurring_algorithm_test_01.pde


PGraphics buffer1;
PGraphics buffer2;

PImage unicorn;
PImage unicorn_rainbow;
PGraphics uni;

BlurringImage blur_image;
BlurringImage fore_ground;
BlurringImage back_ground;

int w;
int h;

int startRows;

int loops = 0;

float colourdegrees = 0.0;

void setup() {
  size(500, 600);
  w = 500;
  h = 600;

  startRows = 5;

  blur_image = new BlurringImage(500, 600);
  fore_ground = new BlurringImage(500, 600);
  back_ground = new BlurringImage(500, 600);

  buffer1 = createGraphics(w, h);
  buffer2 = createGraphics(w, h);

  unicorn = loadImage("unicorn.png");
  unicorn_rainbow = loadImage("unicorn_rainbow_trans.png");
}

void mouseDragged() {

  // Draw directly into BlurringImage.buffer1
  blur_image.graphics.beginDraw();

  // Rainbow fireball
  colorMode(HSB, 360, 100, 100);
  float off = colourdegrees;
  colourdegrees += 1.5;
  colourdegrees %= 360;
  color rainbow = color((colourdegrees + off) % 360, 97, 100);
  blur_image.graphics.fill(rainbow);

  blur_image.graphics.noStroke();
  blur_image.graphics.ellipse(mouseX, mouseY, 60, 60);
  colorMode(RGB, 255, 255, 255);
  blur_image.graphics.endDraw();
}

void draw_rainbow_unicorn() {
  blur_image.graphics.beginDraw();
  blur_image.graphics.loadPixels();
  unicorn_rainbow.loadPixels();

  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {

      int index = x + y * w;
      color col = unicorn_rainbow.pixels[index];
      if (((col >> 24) & 0xFF) > 250) {            // Only seems to work if non-transparent pixels are copied
        blur_image.graphics.pixels[index] = col;
      }
    }
  }

  blur_image.graphics.updatePixels();
  blur_image.graphics.endDraw();
}

void draw_fore_ground() {
  fore_ground.graphics.beginDraw();
  fore_ground.graphics.loadPixels();

  for (int x = 0; x < w; x++) {
    for (int y = 590; y < h; y++) {

      int index = x + y * w;
      color col = color(255);
      fore_ground.graphics.pixels[index] = col;
    }
  }

  fore_ground.graphics.updatePixels();
  fore_ground.graphics.endDraw();
}

void draw_back_ground() {
  back_ground.graphics.beginDraw();
  back_ground.graphics.loadPixels();
  
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {

      int index = x + y * w;
      color col = unicorn_rainbow.pixels[index];
      if (((col >> 24) & 0xFF) > 250) {            // Only seems to work if non-transparent pixels are copied
        back_ground.graphics.pixels[index] = col;
      }
    }
  }

  for (int x = 0; x < w; x++) {
    for (int y = 540; y < h; y++) {

      int index = x + y * w;
      color col = color(255, 100, 100);
      back_ground.graphics.pixels[index] = col;
    }
  }

  back_ground.graphics.updatePixels();
  back_ground.graphics.endDraw();
}

void draw() {

  background(255);

  draw_back_ground();
  draw_rainbow_unicorn();
  draw_fore_ground();


  image(back_ground.get_image(), 0, 0);
  image(blur_image.get_image(), 0, 0);
  image(unicorn, 0, 0);
  image(fore_ground.get_image(), 0, 0);


  blur_image.blur();
  fore_ground.blur();
  back_ground.blur();

  loops++;
}
