/**
 *This class contains methods for using Frog objects.
 *Frogs are meant to move around the screen and collect energy through eating mosquitoes.
 *Frogs also repel mosquitoes.
 */
public class Frog {
  private PVector loc;
  private PVector vel;
  private PVector acc;
  //private float yums = -10;
  private float mass;
  private float j; //jump power
  private float jFreq;
  private int energy;
  private float r, g, b;
  private float size;
  private int repNRG;

  /**
   *Create the first instance of a frog in a program
   *@param x X position
   *@param y Y position
   *@param red Red value
   *@param green Green value
   *@param blue Blue value
   *@param m_ Mass
   *@param j_ Jump power
   *@param jFreq_ Jump frequency (chance to jump each frame)
   *@param NRG Starting energy
   */
  public Frog(float x, float y, float red, float green, float blue, float m_, float j_, float jFreq_, int NRG) {
    loc = new PVector(x, y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    mass = m_;
    j = j_ /4;
    jFreq = jFreq_;
    energy = NRG;
    r = red;
    g = green;
    b = blue;
    repNRG = (int) mass * 400;
    size = mass * 6.5;
  }

  /**
   *Create a copy of an existing frog.
   *@param Frog to be copied
   */
  public Frog(Frog f) {
    loc = f.loc.copy();
    vel = f.loc.copy();
    acc = f.loc.copy();
    mass = f.mass;
    j = f.j;
    jFreq = f.jFreq;
    energy = f.energy;
    r = f.r;
    g = f.g;
    b = f.b;
    repNRG = (int) mass * 400;
    size = mass * 4.5;
  }

  /**
   *Constructor for creating a new mutated frog from two parents.
   *@param f1 Parent 1.
   *@param f2 Parent 2.
   */
  public Frog(Frog f1, Frog f2) {
    Frog f1C = new Frog(f1);
    Frog f2C = new Frog(f2);

    loc = new PVector(f1.loc.x, f2.loc.y);
    mass = ((f1C.mass + f2C.mass) / 2) * random(0.9, 1.1);
    j = ((f1C.j + f2C.j) / 2) * random(0.9, 1.1);
    jFreq = ((f1C.jFreq + f2C.jFreq) / 2) * random(0.9, 1.1);
    energy = (int)(((f1C.energy + f2C.energy) / 2) * random(0.9, 1.1));
    r = ((f1C.r + f2C.r) / 2) * random(0.9, 1.1);
    g = ((f1C.g + f2C.g) / 2) * random(0.9, 1.1);
    b = ((f1C.b + f2C.b) / 2) * random(0.9, 1.1);
  }

  /**
   *Returns a copy of the frog.
   *@return Frog copy.
   */
  public Frog copy() {
    Frog f = new Frog(this);
    return f;
  }

  /**
   *Breed frog instance with other frog, creating a new, slightly mutated frog at same position.
   *@param f2 Parent two.
   *@return New frog.
   */
  public Frog breed(Frog f2) {
    Frog f1C = new Frog(this);
    Frog f2C = new Frog(f2);

    float f3Mass = ((f1C.mass + f2C.mass) / 2) * random(0.9, 1.1);
    float f3J= ((f1C.j + f2C.j) / 2) * random(0.9, 1.1);
    float f3JFreq = ((f1C.jFreq + f2C.jFreq) / 2) * random(0.9, 1.1);
    int f3Energy = (int)(((f1C.energy + f2C.energy) / 2) * random(0.9, 1.1));
    float f3R = ((f1C.r + f2C.r) / 2) * random(0.9, 1.1);
    float f3G = ((f1C.g + f2C.g) / 2) * random(0.9, 1.1);
    float f3B = ((f1C.b + f2C.b) / 2) * random(0.9, 1.1);

    return new Frog(f1C.loc.x, f1C.loc.y, f3R, f3G, f3B, f3Mass, f3J, f3JFreq, f3Energy);
  }

  /**
   *String representation of any usable information from instance.
   *@return String representation of usable info.
   */
  public String toString() {
    String s = ("Location: ("+(int)loc.x+", "+(int)loc.y+") Mass: " + mass + " Jump Constant: " + j + " JumpFreq: " + jFreq + " Energy: " + energy + " Rep Energy: " + repNRG);
    return s;
  }

  /**
   *Location of frog.
   *@return Location of frog as a copy of its location PVector.
   */
  public PVector getLocation() {
    PVector l = loc.copy();
    return l;
  }

  /**
   *Get frog's reproduction energy.
   *@return Frog's reproduction energy.
   */
  public int getRepNRG() {
    return repNRG;
  }

  /**
   *Get frog's energy.
   *@return Frog's energy.
   */
  public int getEnergy() {
    return energy;
  }

  /**
   *Set energy.
   *@param New energy.
   */
  public void setEnergy(int newEnergy) {
    energy = newEnergy;
  }

  /**
   *Size is a measure of frog dimensions. Width of frog is approx 1 size, Height of frog is approx 1.875 size.
   *@return Size.
   */
  public float getSize() {
    return size;
  }

  /**
   *Determines if frog can breed with other frog based off reproduction energy requirements and relative location.
   *@param Potential Parent 2.
   *@return Can the frogs breed?
   */
  public boolean canBreed(Frog f2) {
    PVector f2Loc = f2.getLocation();
    int f2Energy = f2.getEnergy();
    int f2repNRG = f2.getRepNRG();

    if (energy < repNRG && f2Energy < f2repNRG)
      return false;

    PVector dist = PVector.sub(loc, f2Loc);
    float distance = dist.mag();

    if (distance > Math.sqrt(Math.pow(0.5 * size + 0.5 * f2.getSize(), 2) + Math.pow(0.9375 * size + 0.9375 * f2.getSize(), 2) ) )
      return false;

    return true;
  }

  /**
   *Checks an array list of Frog objects, and returns the first possible parent frog.
   *@param f Array to be checked.
   *@return Index of frog first possible parent.
   */
  public int canBreed(ArrayList<Frog> f) {
    for (int i = 0; i < f.size(); i++) {
      PVector f2Loc = f.get(i).getLocation();
      int f2Energy = f.get(i).getEnergy();
      int f2repNRG = f.get(i).getRepNRG();

      PVector dist = PVector.sub(loc, f2Loc);
      float distance = dist.mag();

      if (energy >= repNRG && f2Energy >= f2repNRG && distance <= Math.sqrt(Math.pow(0.5 * size + 0.5 * f.get(i).getSize(), 2) + Math.pow(0.9375 * size + 0.9375 * f.get(i).getSize(), 2) ) )
        return i;
    }
    return -1;
  }

  /**
   *Update position and energy of frog.
   */
  public void update() {   
    if (random(1) < jFreq) {
      if (loc.x + vel.x < simW && loc.x + vel.x > 0 && loc.y + vel.y < simH && loc.y + vel.y > 0){
        vel.add(acc);
        loc.add(PVector.mult(vel, j));
      }else 
      vel.mult(-1);
    }
    vel.limit(3);
    acc.mult(0);
    energy--;
  }

  /**
   *Draw frog.
   */
  public void display() {
    fill(r, g, b);
    stroke(r+10, g+10, b+10);
    strokeWeight(3);
    ellipse(loc.x, loc.y+0.375*size, 0.75*size, 0.75*size);
    ellipse(loc.x, loc.y, size, size);
    ellipse(loc.x, loc.y-0.5*size, 0.75*size, size);
  }

  /**
   *Apply an acceleration force to frog.
   *@param force New force to be applied.
   */
  public void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }

  /**
   *Determine the strength of the repelling force acting on mosquito m.
   *@param m The mosquito to be repelled.
   *@return The acceleration vector that should be applied to m.
   */
  public PVector repel(Mosquite m) {
    PVector force = PVector.sub(loc, m.loc);
    float distance = force.mag();
    if (distance > 50)
      return force.mult(0);
    distance = constrain(distance, 5, 50);
    force.normalize();
    float strength = (-mass * 4 * m.mass) / (distance * distance);
    force.mult(strength);
    return force;
  }

  /**
   *Determine if frog is close enough to mosquite m.
   *@param Candidate for eating.
   *@return Can I eat this mosquite?
   */
  public boolean canEat(Mosquite m) {
    PVector mLoc = m.loc.copy(); 

    PVector dist = PVector.sub(loc, mLoc);
    float distance = dist.mag();

    if (distance > Math.sqrt(Math.pow(0.5 * size + m.getSize(), 2) + Math.pow(0.9375 * size + 0.75 * m.getSize(), 2) ) )
      return false;

    return true;
  }

  /**
   *Check for collision between frog and an array list of mosquitoes. Return the index of the first mosquito collided with.
   *@param m Array list of mosqutioes.
   *@return Index of first mosquito collided with.
   */
  public int canEat(ArrayList<Mosquite> m) {
    for (int i = 0; i < m.size(); i++) {
      if (this.canEat(m.get(i)))
        return i;
    }
    return -1;
  }
}
