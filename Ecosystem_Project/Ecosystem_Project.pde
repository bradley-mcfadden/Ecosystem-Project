//Frogs are attracted to mosquite
//Frogs mosquites are attracted to fruit
//Mosquites are repelled by frogs

//Collision between fruit and mosquitoes destroys fruit, makes new mosquito
//Collision between mosquite and frog destroys mosquite
import java.util.Random;

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

void setup(){
 int armySize = 2;
 int scourgeSize = 200;
 int forestSize = 55;
 frameRate(30);
 size(1200,800);
 
 //col = new ArrayList<Point>();
 //col.add(new Point(msE,armySize));
 nature = new Random();
 armyPop = new LineGraph(800,0,400,266);
 mosqPop = new LineGraph(800,266,400,266);
 fruitPop = new LineGraph(800,532,400,266);
 
 army = new ArrayList<Frog>(armySize);
 for (int i = 0; i < armySize; i++)
   army.add(new Frog(random(simW),random(simH),random(255),random(255),random(255),randomGaussian()+3,randomGaussian()+10,constrain((float)randomGaussian()+1,0.1,1),constrain(randomGaussian()*1000,200,1500)));
   
 scourge = new ArrayList<Mosquite>(scourgeSize);
 for (int i = 0; i < scourgeSize; i++)
   scourge.add(new Mosquite(random(simW),random(simH),random(2.5),constrain(randomGaussian()*800,400,1600),random(1)+0.4));
   
 forest = new ArrayList<Tree>(forestSize);
 for (int i = 0; i < forestSize; i++)
   forest.add(new Tree(random(simW)-50,random(simH),random(0.5)+1,random(1)+0.3));
 sort(forest);
 
 armyPop.addPoint(new Point(0,army.size()));
 mosqPop.addPoint(new Point(0,scourge.size()));
 fruitPop.addPoint(new Point(0,numFruit(forest)));
}

void draw(){
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
     army.add(new Frog(army.get(i).location.x,army.get(i).location.y,army.get(i).r+random(-20,20),army.get(i).g+random(-20,20),army.get(i).b+random(-20,20),randomGaussian()+1*army.get(i).mass,army.get(i).j*(random(1.7)+0.4),army.get(i).jFreq*random(1)+0.4,army.get(i).energy*random(1)+0.4));
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
       scourge.add(new Mosquite(forest.get(h).bunch.get(y).location.x,forest.get(h).bunch.get(y).location.y,scourge.get(i).mass * random(1)+0.6,scourge.get(i).energy*random(1)+0.6,scourge.get(i).buzz*random(1)+0.4));
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

void sort(ArrayList<Tree> t){
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

float maxY(ArrayList<Point> p){
 float max = p.get(0).y; 
 for (int i = 0; i < p.size(); i++){
  if (p.get(i).y > max)
    max = p.get(i).y;
 }
 return max;
}

int numFruit(ArrayList<Tree> t){
 int size=0;
 for (int i = 0; i < t.size(); i++){
   size+=t.get(i).bunch.size();
 }
 return size;
}

void drawTitle(int sec){
  PFont f = createFont("Console",16,true);
  textFont(f,20);
  textAlign(CENTER);
  fill(0,255);
  text("Frogs " +sec+"s",simW+200,256);
  text("Mosquitoes "+sec+"s",simW+200,522);
  text("Fruit " +sec+"s",simW+200,790);
}
