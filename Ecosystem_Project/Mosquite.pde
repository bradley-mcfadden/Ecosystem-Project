public class Mosquite {
  private float tx, ty;
  private PVector loc;
  private PVector vel;
  private PVector acc;
  private float mass;
  private float buzz; //impact of perlin noise
  private float yums;
  private float size;
  private int energy;

  /**
   *Constructor for creating initial mosquitoes.
   *@param x X location.
   *@param y Y location.
   *@param m_ Mass of mosquito.
   *@param NRG Energy of mosquito.
   *@param bz Impact of perlin noise on mosquito.
   */
  public Mosquite(float x, float y, float m_, int NRG, float bz) {
    loc = new PVector(x, y); 
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    energy = NRG;
    tx = random(10000);
    ty = random(100);
    mass = m_;
    buzz = bz;
    size = mass * 4;
    yums = size * 5;
  }

  /**
   *Constructor for returning a copy of an existing mosquito.
   *@param m Mosquito to be copied.
   */
  public Mosquite(Mosquite m) {
    loc = m.loc.copy();
    vel = m.vel.copy();
    acc = m.acc.copy();
    energy = m.energy;
    tx = random(10000);
    ty = random(100);
    mass = m.mass;
    buzz = m.buzz;
    size = m.size;
    yums = size * 5;
  }

  /**
   *Return a copy of this instance of a mosquite.
   *@return Copy of this mosquite.
   */
  public Mosquite copy() {
    Mosquite m = new Mosquite(this);
    return m;
  }

  /**
   *Create a slightly mutated new mosquito from this instance and another parent.
   *@param m2 Parent 2.
   *@return New and slightly mutated mosquito.
   */
  public Mosquite breed(Mosquite m2) {
    Mosquite m1C = this.copy();
    Mosquite m2C = m2.copy();
    int m3Energy = (int)(((m1C.energy + m2C.energy) /2) * random(0.9, 1.1));
    float m3Mass = ((m1C.mass + m2C.mass) /2) * random(0.9, 1.1);
    float m3Buzz = ((m1C.buzz + m2C.buzz) /2) * random(0.9, 1.1);

    Mosquite m3 = new Mosquite(m1C.loc.x, m1C.loc.y, m3Mass, m3Energy, m3Buzz);
    return m3;
  }

  /**
   *Create a slightly mutated new mosquito from this instance.
   *@return New and slightly mutated mosquito.
   */
  public Mosquite breed() {
    Mosquite m1C = this.copy();

    int m2Energy = (int)(m1C.energy * random(0.9, 1.1));
    float m2Mass = m1C.mass * random(0.9, 1.1);
    float m2Buzz = m1C.buzz * random(0.9, 1.1);

    Mosquite m2 = new Mosquite(m1C.loc.x, m1C.loc.y, m2Mass, m2Energy, m2Buzz);
    return m2;
  }

  /**
   *For debugging use, returns a string representation of important mosquito variables.
   *@return Important Mosquite variables.
   */
  public String toString() {
    String s = ("Location: (" +loc.x+ ", " +loc.y+ ") Mass: " +mass+ " Perlin Accleration: " +buzz+ " Energy: " +energy);
    return s;
  }

  /**
   *Location of mosquite.
   *@return Location of mosquite as a copy of its location PVector.
   */
  public PVector getLocation() {
    PVector l = loc.copy();
    return l;
  }

  /**
   *Get mosquite's energy.
   *@return mosquite's energy.
   */
  public int getEnergy() {
    return energy;
  }
  
  /**
    *Set mosquite's energy.
    *@param newEnergry New value.
  */
  public void setEnergy(int nE){
     energy = nE; 
  }

  /**
   *Size is a measure of mosquite dimensions. Width of mosquite is approx 2 size, Height of mosquite is approx 1.5 size.
   *@return Size.
   */
  public float getSize() {
    return size;
  }

  /**
   *Determines if mosquite can eat with fruit base off of fruit location.
   *@param Fruit to be checked.
   *@return Can the mosquito ear?
   */
  public boolean canEat(Fruit f) {
    PVector fLoc = f.getLocation();

    PVector dist = PVector.sub(loc, fLoc);
    float distance = dist.mag();

    if (distance > 8 + Math.sqrt(Math.pow(0.75 * size, 2) + Math.pow(size, 2)))
      return false;

    return true;
  }

  /**
   *Checks a tree for potential eating between mosquite and fruit.
   *@param t Tree to check.
   *@return Index of possible eaten fruit.
   */
  public int canEat(Tree t) {
    ArrayList<Fruit> f = t.getBunch();
    for (int i = 0; i < f.size(); i++) {
      if (this.canEat(f.get(i)))
        return i;
    }
    return -1;
  }

  /**
   *Returns the index of a tree and a fruit that can be consumed
   *@param Array list of Tree to check.
   *@return Index of tree and of fruit of that tree to consume
   */
  public int[] canEat(ArrayList<Tree> t) {
    ArrayList<Tree> tC = new ArrayList<Tree>(t.size());
    for (int i = 0; i < t.size(); i++)
      tC.add(new Tree(t.get(i))); 

    int[] index = {-1, -1};
    for (int i = 0; i < tC.size(); i++) {
      if (this.canEat(tC.get(i)) >= 0) {
        index[0] = i;
        index[1] = canEat(tC.get(i));
      }
    }
    return index;
  }

  /**
   *Applies an acceleration force to the mosquite.
   *@param The acceleration force to be applied.
   */
  public void applyForce(PVector force) {
    PVector f = force.copy();
    acc.add(f);
  }

  /**
   *Attract a frog to this mosquito's location.
   *@param f Frog to be attracted.
   */
  public PVector attract(Frog f) {
    PVector fLoc = f.getLocation();
    PVector force = PVector.sub(loc, fLoc);
    float distance = force.mag();
    if (distance > 150)
      return force.mult(0);

    distance = constrain(distance, 5, 50.0); //think about division by very small or very big numbers
    force.normalize();
    float strength = (yums * mass * f.getSize()) / (distance * distance);
    force.mult(strength);     
    return force;
  }

  /**
   *Return the position of the closest fruit.
   *@param Tree to check.
   *@return Index of closest fruit.
   */
  public int closestFruit(Tree t) {
    ArrayList<Fruit> f = t.getBunch();
    int posMin = 0;
    for (int i = 0; i < f.size(); i++) {
      PVector force = PVector.sub(loc, f.get(i).getLocation());
      float distance = force.mag();
      if (distance < PVector.sub(loc, f.get(posMin).getLocation()).mag())
        posMin = i;
    }
    return posMin;
  }

  /**
   *Take an array of trees and return the closest fruit as an int array. {Tree,Fruit}
   *@param t The list of trees to be searched.
   *@return i The index of the closest tree.
   */
  public int[] closestFruit(ArrayList<Tree> t) {
    int t1 = this.closestTree(t);
    int f1 = this.closestFruit(t.get(t1));
    int[] i = {-1, -1};

    if (t1 >= 0 && f1 >= 0) {
      i[0] = t1;
      i[1] = f1;
    }
    return i;
  }

  /**
   *Return the position of the closest tree.
   *@param t Array list of trees to check.
   *@return Closest tree.
   */
  public int closestTree(ArrayList<Tree> t) {
    if (t.size() == 0)
      return -1;
    int posMin = 0;
    for (int i = 0; i < t.size(); i++) {
      PVector force = PVector.sub(loc, t.get(i).getLocation());
      float distance = force.mag();
      if (t.get(i).getBunch().size() > 0 && distance < PVector.sub(loc, t.get(posMin).getLocation()).mag())
        posMin = i;
    }
    return posMin;
  }

  /**
   *Display the mosquite.
   */
  public void display() {
    noStroke();
    fill(200);
    ellipse(loc.x+(mass)*2, loc.y-(size)/2, size, size);
    ellipse(loc.x-(mass)*2, loc.y-(size)/2, size, size);
    noStroke();
    fill(0);
    ellipse(loc.x, loc.y, size, size);
  }

  /**
   *Bounds checking and update location.
   */
  public void update() {
    acc.x += buzz * map(noise(tx), 0, 1, -2, 2) /100;
    acc.y += buzz * map(noise(ty), 0, 1, -2, 2) /100;
    if (loc.x + vel.x < simW && loc.x + vel.x > 0 && loc.y + vel.y < simH && loc.y + vel.y > 0)
      loc.add(vel);
    else 
    vel.mult(-0.8);
    tx += 0.01;
    ty += 0.01;
    vel.add(acc);
    vel.limit(3);
    loc.add(vel);
    acc.mult(0);
    energy--;
  }
}
