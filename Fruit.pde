/**
 *Class is used normally within a tree class to create objects known as fruit that apply an
 *attraction force against mosquito objects.
 */
public class Fruit {
  private PVector loc;
  private float red = random(255);
  private float green = random(255);
  private float yums;

  /**
   *Constructor used to create a fruit.
   *@param x X location.
   *@param y Y location.
   */
  public Fruit(float x_, float y_) {
    loc = new PVector(x_, y_);
    yums = 2 * (float)Math.sqrt(red + green);
  }

  /**
    *Constructor used to copy a fruit.
    *@param f Fruit to be copied.
  */
  public Fruit(Fruit f){
   loc = f.loc.copy();
   yums = f.yums;
  }
  
  /**
    *Return a copy of this fruit.
    *@return Fruit copy.
  */
  public Fruit copy(){
   Fruit f = new Fruit(this); 
   return f;
  }
  
  /**
   *Return a string representation of notable data held within Fruit.
   *@return String.
   */
  public String toString() {
    String s = ("Location: (" + loc.x + ", " + loc.y + ") Yums: + " +yums);
    return s;
  }
  /**
   *Used to get the location of the fruit.
   *@return Location as a PVector.
   */
  public PVector getLocation() {
    PVector l = loc.copy();  
    return l;
  }

  /**
   *Return the yums, or attraction force of the fruit.
   *@return Attraction force.
   */
  public float getYums() {
    return yums;
  }

  /**
   *Draw the fruit.
   */
  public void display() {
    noStroke();
    fill(red, green, 19);
    ellipse(loc.x, loc.y, 16, 16);
  }

  /**
   *Calculate the attraction force that the fruit applies on the mosquito.
   *@param m Mosquito to be attracted.
   *@return Acceleration force that should be applied to mosquito.
   */
  public PVector attract(Mosquite m) {
    PVector force = PVector.sub(loc, m.getLocation());
    float distance = force.mag();

    if (distance > 100)
      return force.mult(0);

    distance = constrain(distance, 5, 50);
    force.normalize();
    float strength = (yums * 4 * m.getSize()) / (distance * distance);
    force.mult(strength);
    return force;
  }
}
