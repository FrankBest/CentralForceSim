float constantG;
float constantT;
float energyAmount;
boolean growing = false;
int growth;
int growspeed;
int mouseStartX,mouseStartY,mouseEndX,mouseEndY;
ArrayList <Planet> planets = new ArrayList <Planet>();

void setup(){
  size(800,600);
  constantG = 0.2;
  constantT = 0.0005;
  growing = false;
  growth = 1;
  growspeed = 10;
  //for (int i = 0; i < 3; i++){
  //  planets.add(new Planet(random(100,400),random(width),random(height),random(1),random(1)));
  //  planets.add(new Planet(random(100,900),random(width),random(height),random(-1,1),random(-1,1)));
  //}
}

void draw(){
  background(225);
  if(mousePressed)line(mouseStartX,mouseStartY,mouseEndX,mouseEndY);
  if(growing) growth += growspeed;
  for(int k = 0; k < 500; k++){
    for (int i = 0; i < planets.size(); i++){
      for (int j = i+1; j < planets.size(); j++){
        planets.get(i).attract(planets.get(j),constantT);
      }
    }
    
    for (int i = 0; i< planets.size(); i++){
      planets.get(i).move(constantT);
    }
    
    for (int i = 0; i < planets.size(); i++){
      for (int j = i+1; j < planets.size(); j++){
        if (planets.get(i).distance2(planets.get(j)) < sq(planets.get(i).radius - planets.get(j).radius)){
          merge(planets.get(i),planets.get(j));
          planets.remove(j);
          planets.remove(i);
        }
      }
    }
    
  }
  
  for (int i = 0; i< planets.size(); i++){
    if ((planets.get(i).xpos < -width)||(planets.get(i).xpos > 2*width)
     ||(planets.get(i).ypos < -height)||(planets.get(i).ypos > 2*height))
     planets.remove(i);
  }
  
  for (int i = 0; i< planets.size(); i++){
    planets.get(i).show();
  }
  
  //energyAmount = 0;
  //for (int i = 0; i< planets.size(); i++){
  //  energyAmount += planets.get(i).energy();
  //}
  
  fill(0);
  text("FRAMERATE: " + frameRate,30,30);
  text("planet(s): " + planets.size(),30,45);
  text("growspeed: " + growspeed,30,60);
  text("growth: " + growth,30,75);
  //text(energyAmount,30,60);
}


class Planet{
  float mass;
  float xpos;
  float ypos;
  float xspeed;
  float yspeed;
  float radius;
  int R;
  int G;
  int B;
  color col;
  
  Planet(float _mass, float _xpos, float _ypos, float _xspeed, float _yspeed){
    mass = _mass;
    xpos = _xpos;
    ypos = _ypos;
    xspeed = _xspeed;
    yspeed = _yspeed;
    radius = pow(mass,1.0/3);
    R = (int)random(256);
    G = (int)random(256);
    B = (int)random(256);
    col = color(R,G,B);
  }
  
  Planet(float _mass, float _xpos, float _ypos, float _xspeed, float _yspeed, int _R, int _G, int _B){
    mass = _mass;
    xpos = _xpos;
    ypos = _ypos;
    xspeed = _xspeed;
    yspeed = _yspeed;
    radius = pow(mass,1.0/3);
    R = _R;
    G = _G;
    B = _B;
    col = color(R,G,B);
  }
  
  
  public float distance2(Planet P){
    return (sq(xpos - P.xpos)+sq(ypos - P.ypos));
  }
  
  public void attract(Planet P,float time){
    float F = constantG * mass * P.mass / distance2(P);
    float angle = atan2(ypos - P.ypos, xpos - P.xpos);
    xspeed -= F*cos(angle)*time/mass;
    yspeed -= F*sin(angle)*time/mass;
    P.xspeed += F*cos(angle)*time/P.mass;
    P.yspeed += F*sin(angle)*time/P.mass;
  }
  
  public float energy(){
    return (mass*(xspeed*xspeed + yspeed*yspeed));
  }
  
  void move(float time){
    xpos += xspeed * time;
    ypos += yspeed * time;
  }
  
  void show(){
    fill(col);
    ellipse(xpos,ypos,radius,radius);
  }
}

void mousePressed() {
  // set the starting corner
  mouseStartX = mouseX; mouseStartY = mouseY;
  growing = true;
}

void merge(Planet A, Planet B){
  float newmass = A.mass + B.mass;
  float newx = (A.xpos*A.mass + B.xpos*B.mass)/newmass;
  float newy = (A.ypos*A.mass + B.ypos*B.mass)/newmass;
  float newxspeed = (A.xspeed*A.mass + B.xspeed*B.mass)/newmass;
  float newyspeed = (A.yspeed*A.mass + B.yspeed*B.mass)/newmass;
  int newR = (int)((A.R*A.mass + B.R*B.mass)/newmass);
  int newG = (int)((A.G*A.mass + B.G*B.mass)/newmass);
  int newB = (int)((A.B*A.mass + B.B*B.mass)/newmass);
  planets.add(new Planet(newmass, newx, newy, newxspeed, newyspeed, newR, newG, newB));
}

void mouseDragged() {
  mouseEndX = mouseX; mouseEndY = mouseY;
}

void mouseReleased() {
  mouseEndX = mouseX; mouseEndY = mouseY;
  planets.add(new Planet(growth,mouseStartX,mouseStartY,(mouseEndX-mouseStartX)/25,(mouseEndY-mouseStartY)/25));
  growing = false;
  growth = 1;
  //mouseStartX = mouseX; mouseStartY = mouseEndY;
}

void keyPressed(){
  if (key == 'a') 
    for (int i = 0; i < planets.size(); i++){
      planets.get(i).xpos -= 10;
    }
  else if (key == 'd')
    for (int i = 0; i < planets.size(); i++){
      planets.get(i).xpos += 10;
    }
  else if (key == 'w')
    for (int i = 0; i < planets.size(); i++){
      planets.get(i).ypos -= 10;
    }
  else if (key == 's')
    for (int i = 0; i < planets.size(); i++){
      planets.get(i).ypos += 10;
    }
  else if (key == 'z') growspeed ++;
  else if ((key == 'x')&&(growspeed > 5)) growspeed --;
}
