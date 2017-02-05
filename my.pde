float G = 0.2 ;//Gravity Constant
double dt= 0.00005;//A tiny period of time
float  power = 2; //Gravity power
boolean run = false;
Planet planet  = new Planet(400, 200,  250,  0, 1);
Planet star    = new Planet(400, 300,    0,  0, 2);

class Planet{
  float xpos;
  float ypos;
  double xspd;
  double yspd;
  float mass;
  float radius = 2;
  int   col = 1;
  //int   dcol = 1;
  
  float distance(Planet B){
     float dx = (float)(B.xpos - xpos);
     float dy = (float)(B.ypos - ypos);
     return sqrt( dx * dx + dy * dy );
  }
  
  void attract(Planet A, Planet B){
     float dx = (float)(B.xpos - A.xpos);
     float dy = (float)(B.ypos - A.ypos);
     float distance = sqrt( dx * dx + dy * dy );
     double F  = G * A.mass * B.mass * pow( distance , power);
     A.xspd += F * dt * dx / distance / A.mass;
     A.yspd += F * dt * dy / distance / A.mass;
     //B.xspd -= F * dt * dx / distance / B.mass;
     //B.yspd -= F * dt * dy / distance / B.mass;
  }
     
  void attracted(Planet B){
     float dx = (float)(B.xpos - xpos);
     float dy = (float)(B.ypos - ypos);
     float distance = sqrt( dx * dx + dy * dy );
     double F  = G * mass * B.mass * pow( distance , power);
     xspd += F * dt * dx / distance / mass;
     yspd += F * dt * dy / distance / mass;
   }
     
   void show(){
     //if(col >= 255) dcol = -dcol;
     //else if(col <= 0) dcol = -dcol;
     //col += dcol;
     fill(col);
     ellipse(xpos,ypos,radius,radius);
   }
     
   Planet(float _xpos, float _ypos, double _xspd, double _yspd, float _mass){
     xpos = _xpos;
     ypos = _ypos;
     xspd = _xspd;
     yspd = _yspd;
     mass = _mass;
   }
  
  void move(){
    xpos += dt * xspd;
    ypos += dt * yspd;
  }
  
  float energy(Planet B){
         if(power == -1)return 0.5 * mass * (float)(xspd * xspd + yspd * yspd) + G * mass * B.mass * log(distance(B));
    //else if(- power >  1)return 0.5 * mass * (float)(xspd * xspd + yspd * yspd) - G * mass * B.mass * pow(distance(B),1+ power) / (- power-1);
    //else if(- power <  1)return 0.5 * mass * (float)(xspd * xspd + yspd * yspd) + G * mass * B.mass * pow(distance(B),1+ power) / (1+ power);
      else return 0.5 * mass * (float)(xspd * xspd + yspd * yspd) + G * mass * B.mass * pow(distance(B),1+power) / (power+1);
  }
}

void setup(){
  size(800,600);
  background(200);
  //background(200,200,0);
  noStroke();
  textSize(18);
}

void draw(){
  //if (!run){
  //  noLoop();
  //  run = !run;}
  for(int i=0; i<100; i++){
  planet.attracted(star);
  planet.move();
  }
  fill(200);
  rect(0,0,250,100);
  fill(0);
  //text("E:" + (float)planet.energy(star),0,24);
  text("power:" + power,0,24);
  text("Xspd:" + (float)planet.xspd,0,48);
  text("Yspd:" + (float)planet.yspd,0,72);
  //text(frameRate,0,25);
  planet.show();
  star.show();
}

void keyPressed(){
  //frameRate(100000); 
  if (key == ' ') frameRate(100000);
  else   noLoop();
}

void keyReleased(){
  frameRate(60);
  loop();
}
