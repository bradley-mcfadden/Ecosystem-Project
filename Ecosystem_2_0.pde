ArrayList<Frog> army;
ArrayList<Mosquite> scourge;
ArrayList<Tree> forest;
float simW = 800;
float simH = 800;
int armySize = 6;
int scourgeSize = 20;
int forestSize = 45;
int msE = 0;
int sec = 0;
Tree t;

LineGraph armyPop;
LineGraph mosqPop;
LineGraph fruitPop;

void setup() {
  frameRate(30);
  size(1200, 800);

  army = new ArrayList<Frog>(armySize);
  scourge = new ArrayList<Mosquite>(scourgeSize);
  forest = new ArrayList<Tree>(forestSize);

  armyPop = new LineGraph(800, 0, 400, 266, "Frog Population Over Time", "Time(s)", "Population");
  mosqPop = new LineGraph(800, 266, 400, 266, "Mosquite Population Over Time", "Time(s)", "Population");
  fruitPop = new LineGraph(800, 532, 400, 266, "Fruit Population Over Time", "Time(s)", "Population");

  //t = new Tree(random(55, simW-55), random(55, simH-55), random(0.5)+1, random(1)+0.3);
  for (int i = 0; i < armySize; i++) {
    Frog f = new Frog(random(simW-1)+1, random(simH-1)+1, random(255), random(255), random(255), random(1,4), randomGaussian()+10, constrain((float)randomGaussian()+1, 0.1, 1), (int)constrain(randomGaussian()*1000, 200, 1500));
    army.add(f);
  }
  for (int i = 0; i < scourgeSize; i++) {
    Mosquite m = new Mosquite(random(simW-1)+1, random(simH-1)+1, random(2.5), (int)constrain(randomGaussian()*800, 400, 1600), random(1)+0.4);
    scourge.add(m);
  }
  for (int i = 0; i < forestSize; i++) {
    Tree t = new Tree(random(55, simW-55), random(55, simH-55), random(0.5)+1, random(1)+0.3);
    forest.add(t);
  }
  sort(forest);
  
  armyPop.addPoint(new Point(0, army.size()));
  mosqPop.addPoint(new Point(0, scourge.size()));
  fruitPop.addPoint(new Point(0, numFruit(forest)));
}

void draw() {
  fill(120,255,120);
  rect(0,0,simW,simH);
  msE++;
  
  for (int i = 0; i < army.size(); i++) {
    //println(army.get(i).toString());
    //PVector rand = new PVector(random(-0.02,0.02),random(-0.02,0.02));
    if (army.get(i).getEnergy() <= 0){
      army.remove(i);
      continue;
    } else {
      for (int j = 0; j < army.size(); j++){
        if (j == i)
          continue;
        else {
         if (army.get(i).canBreed(army.get(j))){
           //print("&&&&&");
           army.get(i).setEnergy(army.get(i).getRepNRG()/6);
           army.get(j).setEnergy(army.get(j).getRepNRG()/6);
           Frog f = new Frog(army.get(i).breed(army.get(j)));
           army.add(f);
         }
        }
      }
    }
    for (int j = 0; j < scourge.size(); j++) {
      army.get(i).applyForce(scourge.get(j).attract(army.get(i)));
      if (army.get(i).canEat(scourge.get(j))) {
        //println("@@@@@@");
        army.get(i).setEnergy((int)army.get(i).getEnergy() + (int)scourge.get(j).getSize() * 5);
        scourge.remove(j);
      }
    }
    //army.get(i).applyForce(rand);
    army.get(i).update();
    army.get(i).display();
  }

  for (int i = 0; i < scourge.size(); i++) {
    //PVector rand = new PVector(random(-0.02,0.02),random(-0.02,0.02));
    if (scourge.get(i).getEnergy() <= 0){
      scourge.remove(i);
      continue;
    }
    for (int j = 0; j < army.size(); j++)
      scourge.get(i).applyForce(army.get(j).repel(scourge.get(i)));
    //army.get(i).applyForce(rand);
    
    for (int j = 0; j < forest.size(); j++) {
      t = forest.get(j);
      if (scourge.get(i).closestFruit(t) >= 0 && t.getBunch().size() > 0) {
        scourge.get(i).applyForce(t.getBunch().get(scourge.get(i).closestFruit(t)).attract(scourge.get(i)));
        //print(scourge.get(i).closestFruit(t));
        if (scourge.get(i).canEat(t) >= 0) {
          //println(",================== "+scourge.get(i).canEat(t));
          t.removeFruit(scourge.get(i).canEat(t));
          scourge.add(scourge.get(i).breed());
          scourge.get(i).setEnergy((int)scourge.get(i).getSize()*100);
        } //else 
        //println();
      }
    }
    scourge.get(i).update();
    scourge.get(i).display();
  }
 
  for (int i = 0; i < forest.size(); i++) {
    forest.get(i).update();
    forest.get(i).display();
  }
  
  fill(255);
  noStroke();
  rectMode(CORNER);
  rect(simW,0,simW+400,height);

  if (msE % (int)frameRate == 0) {
    sec++;
    armyPop.addPoint(new Point(sec, army.size()));
    mosqPop.addPoint(new Point(sec, scourge.size()));
    fruitPop.addPoint(new Point(sec, numFruit(forest)));
  }
    armyPop.sketch(armyPop.co.size(), maxY(armyPop.co));
    mosqPop.sketch(mosqPop.co.size(), maxY(mosqPop.co));
    fruitPop.sketch(fruitPop.co.size(), maxY(fruitPop.co));
  
}

void sort(ArrayList<Tree> t) {
  int gaps[] = new int[]{701, 301, 132, 57, 23, 10, 4, 1};
  int n = t.size();
  for (int g = 0; g < gaps.length; g++) {

    for (int i = gaps[g]; i < n; i++) {
      Tree temp = t.get(i).copy(); 
      int j;

      for (j = i; j >= gaps[g] && t.get(j - gaps[g]).getLocation().y > temp.getLocation().y; j -= gaps[g])
        t.set(j, t.get(j-gaps[g]));       
      t.set(j, temp);
    }
  }
}

float maxY(ArrayList<Point> p) {
  float max = p.get(0).getY(); 
  for (int i = 0; i < p.size(); i++) {
    if (p.get(i).getY() > max)
      max = p.get(i).getY();
  }
  return max;
}

int numFruit(ArrayList<Tree> t) {
  int size=0;
  for (int i = 0; i < t.size(); i++) {
    size += t.get(i).getBunch().size();
  }
  return size;
}
