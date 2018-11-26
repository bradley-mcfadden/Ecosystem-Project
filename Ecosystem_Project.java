import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Random; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Ecosystem_Project extends PApplet {

//Frogs are attracted to mosquite
//Frogs mosquites are attracted to fruit
//Mosquites are repelled by frogs

//Collision between fruit and mosquitoes destroys fruit, makes new mosquito
//Collision between mosquite and frog destroys mosquite


int simW = 800;
int simH = 800;
int period = 60;
int msE = 0;
int sec = 0;
ArrayList<Frog> army;
ArrayList<Mosquite> scourge;
ArrayList<Tree> forest;
Random nature;
LineGraph armyPop;
LineGraph mosqPop;
LineGraph fruitPop;

public void setup(){
 int armySize = 2;
 int scourgeSize = 200;
 int forestSize = 55;
 frameRate(30);
 
 
 //col = new ArrayList<Point>();
 //col.add(new Point(msE,armySize));
 nature = new Random();
 armyPop = new LineGraph(800,0,400,266);
 mosqPop = new LineGraph(800,266,400,266);
 fruitPop = new LineGraph(800,532,400,266);
 
 army = new ArrayList<Frog>(armySize);
 for (int i = 0; i < armySize; i++)
   army.add(new Frog(random(simW),random(simH),random(255),random(255),random(255),randomGaussian()+3,randomGaussian()+10,constrain((float)randomGaussian()+1,0.1f,1),constrain(randomGaussian()*1000,200,1500)));
   
 scourge = new ArrayList<Mosquite>(scourgeSize);
 for (int i = 0; i < scourgeSize; i++)
   scourge.add(new Mosquite(random(simW),random(simH),random(2.5f),constrain(randomGaussian()*800,400,1600),random(1)+0.4f));
   
 forest = new ArrayList<Tree>(forestSize);
 for (int i = 0; i < forestSize; i++)
   forest.add(new Tree(random(simW)-50,random(simH),random(0.5f)+1,random(1)+0.3f));
 sort(forest);
 
 armyPop.addPoint(new Point(0,army.size()));
 mosqPop.addPoint(new Point(0,scourge.size()));
 fruitPop.addPoint(new Point(0,numFruit(forest)));
}

public void draw(){
 msE++;
 fill(85,157,47);
 rect(0,0,800,800);
 for (int i = 0; i < army.size(); i++){
   army.get(i).update();
   army.get(i).display();
   for (int j = 0; j < scourge.size(); j++)
     scourge.get(j).applyForce(army.get(i).repel(scourge.get(j)));
   int x = army.get(i).eatMosquite(scourge);
   if (x >= 0){
     army.get(i).energy+=300;
     scourge.remove(x);
   }
   if (army.get(i).energy <= 0){
     army.remove(i);
   } else if (army.get(i).energy > army.get(i).repNRG){
     army.add(new Frog(army.get(i).location.x,army.get(i).location.y,army.get(i).r+random(-20,20),army.get(i).g+random(-20,20),army.get(i).b+random(-20,20),randomGaussian()+1*army.get(i).mass,army.get(i).j*(random(1.7f)+0.4f),army.get(i).jFreq*random(1)+0.4f,army.get(i).energy*random(1)+0.4f));
     army.get(i).energy = army.get(i).repNRG / 3;
   }  
 }
 for (int i = 0; i < scourge.size(); i++){
   int cTree = scourge.get(i).closestTree(forest);
   if (cTree >= 0 && forest.get(cTree).bunch.size() > 0){
     int cFrui = scourge.get(i).closestFruit(forest.get(cTree));
     scourge.get(i).applyForce(forest.get(cTree).bunch.get(cFrui).attract(scourge.get(i)));
   }
   for (int h = 0; h < forest.size();h++){
     int y = scourge.get(i).suckFruit(forest,h);
     if (y >= 0){
       scourge.add(new Mosquite(forest.get(h).bunch.get(y).location.x,forest.get(h).bunch.get(y).location.y,scourge.get(i).mass * random(1)+0.6f,scourge.get(i).energy*random(1)+0.6f,scourge.get(i).buzz*random(1)+0.4f));
       scourge.get(i).energy += forest.get(h).bunch.get(y).yums * 40;
       forest.get(h).bunch.remove(y);
     }
   }
   for (int j = 0; j < army.size(); j++)
     army.get(j).applyForce(scourge.get(i).attract(army.get(j)));
   scourge.get(i).step();
   scourge.get(i).display();
   if (scourge.get(i).energy <= 0){
    scourge.remove(i);
   }
 }
 for (int i = 0; i < forest.size(); i++){
   forest.get(i).display();
   forest.get(i).update();
 }
 
 fill(255);
 noStroke();
 rectMode(CORNER);
 //rect(simW,0,simW+400,height);
 
 if (msE % (int)frameRate == 0){
   sec++;
   armyPop.addPoint(new Point(sec,army.size()));
   mosqPop.addPoint(new Point(sec,scourge.size()));
   fruitPop.addPoint(new Point(sec,numFruit(forest)));
   
   armyPop.sketch(armyPop.co.size(),maxY(armyPop.co));
   mosqPop.sketch(mosqPop.co.size(),maxY(mosqPop.co));
   fruitPop.sketch(fruitPop.co.size(),maxY(fruitPop.co));
 
   drawTitle(sec);
 }
}

public void sort(ArrayList<Tree> t){
  int gaps[] = new int[]{701,301,132,57,23,10,4,1};
  int n = t.size();
  for (int g = 0; g < gaps.length; g++){
    
    for (int i = gaps[g]; i < n; i++){
     Tree temp = t.get(i).copy(); 
     int j;
     
     for (j = i; j >= gaps[g] && t.get(j - gaps[g]).location.y > temp.location.y; j -= gaps[g])
       t.set(j,t.get(j-gaps[g]));       
     t.set(j,temp);
    }
  }
}

public float maxY(ArrayList<Point> p){
 float max = p.get(0).y; 
 for (int i = 0; i < p.size(); i++){
  if (p.get(i).y > max)
    max = p.get(i).y;
 }
 return max;
}

public int numFruit(ArrayList<Tree> t){
 int size=0;
 for (int i = 0; i < t.size(); i++){
   size+=t.get(i).bunch.size();
 }
 return size;
}

public void drawTitle(int sec){
  PFont f = createFont("Console",16,true);
  textFont(f,20);
  textAlign(CENTER);
  fill(0,255);
  text("Frogs " +sec+"s",simW+200,256);
  text("Mosquitoes "+sec+"s",simW+200,522);
  text("Fruit " +sec+"s",simW+200,790);
}
class Frog{
 PVector location;
 PVector velocity;
 PVector acceleration;
 float yums = -10;
 float mass;
 float j; //jump power
 float jFreq;
 float energy;
 float r,g,b;
 float repNRG;
 
 Frog(float x, float y, float red, float green, float blue, float m_, float j_, float jFreq_,float NRG){
   location = new PVector(x, y);
   velocity = new PVector(0,0);
   acceleration = new PVector(0,0);
   mass = m_;
   j = j_;
   jFreq = jFreq_;
   energy = NRG;
   r = red;
   g = green;
   b = blue;
   repNRG = mass * 300;
 }
 
 public void update(){   
   velocity.add(acceleration);
   if (random(1) < jFreq){
   if (location.x + j * velocity.x < simW && location.x + j * velocity.x > 0 && location.y + j * velocity.y < simH && location.y + j * velocity.y > 0)
      location.add(PVector.mult(velocity,10));
    else 
      velocity.mult(-0.8f);
   }
   velocity.limit(5);
   acceleration.mult(0);
   energy--;
 }
 public void display(){
   float size = mass * 4.5f;
   fill(r,g,b);
   stroke(r+10,g+10,b+10);
   strokeWeight(3);
   ellipse(location.x,location.y+0.375f*size,0.75f*size,0.75f*size);
   ellipse(location.x,location.y,size,size);
   ellipse(location.x,location.y-0.5f*size,0.75f*size,size);
 }
 
 public void applyForce(PVector force){
   PVector f = PVector.div(force,mass);
   acceleration.add(f);
 }
 
 public PVector repel(Mosquite m){
  PVector force = PVector.sub(location,m.location);
  float distance = force.mag();
  if (distance > 50)
    return force.mult(0);
  distance = constrain(distance,5,50);
  force.normalize();
  float strength = (-mass * 4 * m.mass) / (distance * distance);
  force.mult(strength);
  return force;
 }
 
 //check if I hit a mosquito in an array of mosqutioes, if so, pop that mosquito
  public int eatMosquite(ArrayList<Mosquite> m){
   for (int i = 0; i < m.size(); i++){
     PVector force = PVector.sub(location,m.get(i).location);
     float distance = force.mag();
     if(distance < mass*3)
       return i;
   }
   return -1;
  }
}
class Fruit{
  PVector location;
  float red = random(255);
  float green = random(255);
  float yums;
  Fruit(float x_, float y_){
   location = new PVector(x_,y_);
   yums = 2 * (float)Math.sqrt(red + green);
 }
 public void display(){
   noStroke();
   fill(red, green,19);
   ellipse(location.x,location.y,16,16);
 }
 
 public PVector attract(Mosquite m){
  PVector force = PVector.sub(location,m.location);
  float distance = force.mag();
  if (distance > 100)
    return force.mult(0);
  distance = constrain(distance,5,50);
  force.normalize();
  float strength = (yums * 4 * m.mass) / (distance * distance);
  force.mult(strength);
  //force.div(distance);  
  return force;
 
 }
}
class LineGraph{
 ArrayList<Point> co;
 float x;
 float y;
 float xsize;
 float ysize;
 
 public LineGraph(float x_, float y_, float wdth_, float hght_){
   co = new ArrayList<Point>();
   x = x_;
   y = y_;
   xsize = wdth_;
   ysize = hght_;
 }
 
 public void sketch(int size, float max){
  float domain = (float)xsize / size;
  fill(255,200,200);
  stroke(0);
  rectMode(CORNER);
  rect(x,y,xsize,ysize);
  for (int i = 0; i < size - 1; i++){
    strokeWeight(3);
    stroke(255,0,0);
    if (i == size-2)
      line(x+(i*domain),(y+ysize)-(ysize*(co.get(i).y/max)),x+xsize,(y+ysize)-(ysize*(co.get(i+1).y/max)));
    else
      line(x+(i*domain),(y+ysize)-(ysize*(co.get(i).y/max)),x+(i+1)*domain,(y+ysize)-(ysize*(co.get(i+1).y/max)));
  }
  PFont f = createFont("Console",16,true);
  textFont(f,12);
  textAlign(LEFT);
  fill(0,255);
  text(max/2,x,(y+ysize)-(ysize*(max/2)/max)); //(y+ysize)-(ysize*(max/2))
  text((max/4),x,(y+ysize)-(ysize*(max/4)/max)); //(y+ysize)-(ysize*(max/4))
  text(3*(max/4),x,((y+ysize)-(ysize*(3*max/4)/max)));
  //println(max);
 }
 public void addPoint(Point p){
  co.add(p); 
 }
}
class Mosquite{
  float tx, ty;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float buzz; //impact of perlin noise
  float yums = 1;
  float energy;
  
  Mosquite(float x, float y, float m_, float NRG, float bz){
    location = new PVector(x,y); 
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    energy = NRG;
    tx = random(10000);
    ty = random(100);
    mass = m_;
    buzz = bz;
    
  }
  public void display(){
    noStroke();
    fill(200);
    ellipse(location.x+(mass)*2,location.y-(mass)*2,mass * 4,mass * 4);
    ellipse(location.x-(mass)*2,location.y-(mass)*2,mass * 4,mass * 4);
    noStroke();
    fill(0);
    ellipse(location.x,location.y,mass * 4,mass * 4);
  }
  public void step(){
    acceleration.x += buzz * map(noise(tx),0,1,-2,2) /100;
    acceleration.y += buzz * map(noise(ty),0,1,-2,2) /100;
    if (location.x + velocity.x < simW && location.x + velocity.x > 0 && location.y + velocity.y < simH && location.y + velocity.y > 0)
      location.add(velocity);
    else 
      velocity.mult(-0.8f);
    tx += 0.01f;
    ty += 0.01f;
    velocity.add(acceleration);
    velocity.limit(3);
    location.add(velocity);
    acceleration.mult(0);
    energy--;
  }
  
  public void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }
  
  public PVector attract(Frog f){
   PVector force = PVector.sub(location,f.location);
   float distance = force.mag();
   if (distance > 150)
     return force.mult(0);
   distance = constrain(distance,5,50.0f); //think about division by very small or very big numbers
     
   force.normalize();
   float strength = (yums * mass * f.mass) / (distance * distance);
   force.mult(strength);     
   return force;
  }
  
  //check if I am near enough to a tree to collide with a fruit
  //maybe change this to accept the whole tree array
  public int isCloseToTree(ArrayList<Tree> t){
   for (int i = 0; i < t.size(); i++){
     PVector force = PVector.sub(location,t.get(i).location);
     float distance = force.mag();
     if(distance < (t.get(i).size*10 + 9))
       return i;
   }
   return -1;
  }
  //if I am, check the fruit array to see if I've collided with a fruit
  public int suckFruit(ArrayList<Tree> t, int tr){
   for (int i = 0; i < t.get(tr).bunch.size(); i++){
     PVector force = PVector.sub(location,t.get(tr).bunch.get(i).location);
     float distance = force.mag();
     if(distance < mass * 10)
       return i;
   }
   return -1;
  }
  public int closestFruit(Tree t){
   int posMin = 0;
   for (int i = 0; i < t.bunch.size(); i++){
     PVector force = PVector.sub(location,t.bunch.get(i).location);
     float distance = force.mag();
     if (distance < PVector.sub(location,t.bunch.get(posMin).location).mag())
       posMin = i;
   }
   return posMin;
  }
  public int closestTree(ArrayList<Tree> t){
    if (t.size() == 0)
      return -1;
    int posMin = 0;
   for (int i = 0; i < t.size(); i++){
     PVector force = PVector.sub(location,t.get(i).location);
     float distance = force.mag();
     if (t.get(i).bunch.size() > 0 && distance < PVector.sub(location,t.get(posMin).location).mag())
       posMin = i;
   }
   return posMin;
  }
}
class Point{
 float x;
 float y;
 public Point(float x_,float y_){
   x = x_;
   y = y_;
 }
}
class Tree{
 private PVector location;
 private float size;
 private float greenScale;
 ArrayList<Fruit> bunch;
 public Tree(float x_,float y_,float size_,float greenscale_){
  location = new PVector(x_,y_);
  size = (1 + size_);
  greenScale = greenscale_;
  bunch = new ArrayList<Fruit>(5);
 }
 public void display(){
  noStroke();
  fill(150,75,0);
  rectMode(CENTER);
  rect(location.x,location.y+(20),15,20*size);
  noStroke();
  fill(15*greenScale + 100,235*greenScale,0,150);
  ellipse(location.x,location.y,size*20,size*20);
 }
 public Tree copy(){
  Tree copy = new Tree(location.x,location.y,size,greenScale);
  return copy;
 }
 public void update(){
  if(bunch.size() < 5 && random(1) < 0.01f)
    bunch.add(new Fruit(location.x + map(random(1),0,1,-size*8,size*8),location.y + map(random(1),0,1,-size*8,size*8)));
  for (int i = 0; i < bunch.size(); i++)
    bunch.get(i).display();
 }
}
  public void settings() {  size(1200,800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "Ecosystem_Project" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
