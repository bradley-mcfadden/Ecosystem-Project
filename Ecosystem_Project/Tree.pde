/**
 *The tree class exists to hold an array of fruit that grows randomly, up to a capacity of 5.
 *The class contains methods for interacting with this array of fruit.
 */
public class Tree {
  private PVector loc;
  private float size;
  private float greenScale;
  private ArrayList<Fruit> bunch;

  /**
   *Create an initial tree.
   *@param x_ X position.
   *@param y_ Y position.
   *@param size_ The radius of the tree is size * 10.
   *@param greenscale_ The color of the tree.
   */
  public Tree(float x_, float y_, float size_, float greenscale_) {
    loc = new PVector(x_, y_);
    size = (1 + size_);
    greenScale = greenscale_;
    bunch = new ArrayList<Fruit>(5);
    bunch.add(new Fruit(loc.x + map(random(1), 0, 1, -size * 8, size * 8), loc.y + map(random(1), 0, 1, -size * 8, size * 8)));
  }

  /**
   *Copy an existing tree's parameters.
   *@param t Tree to be copied.
   */
  public Tree(Tree t) {
    loc = t.loc.copy();
    size = t.size;

    if (t.bunch.size() > 0) {
      for (int i = 0; i < t.bunch.size(); i++)
        bunch.add(new Fruit(t.bunch.get(i)));
    }
  }

  /**
   *Copy this instance of a Tree.
   *@return A copy of this tree.
   */
  public Tree copy() {
    Tree copy = new Tree(loc.x, loc.y, size, greenScale);
    for (int i = 0; i < bunch.size(); i++)
      copy.bunch.add(new Fruit(bunch.get(i)));
    return copy;
  }

  /**
   
   */
  public String toString() {
    String s = ("Location: (" +loc.x+ ", " +loc.y+" ) Size: " +size+ " Number of Fruit: " +bunch.size());
    return s;
  }

  public PVector getLocation() {
    PVector l = loc.copy();
    return l;
  }

  public ArrayList<Fruit> getBunch() {
    ArrayList<Fruit> f = new ArrayList<Fruit>();
    if (bunch.size() > 0) {
      for (int i = 0; i < bunch.size(); i++)
        f.add(new Fruit(bunch.get(i)));
    }
    return f;
  }

  public void removeFruit(int i) {
    bunch.remove(i);
  }

  public void display() {
    noStroke();
    fill(150, 75, 0);
    rectMode(CENTER);
    rect(loc.x, loc.y+(20), 15, 20*size);
    noStroke();
    fill(15*greenScale + 100, 235*greenScale, 0, 150);
    ellipse(loc.x, loc.y, size*20, size*20);
  }

  public void update() {
    if (bunch.size() < 5 && random(1) < 0.01)
      bunch.add(new Fruit(loc.x + map(random(1), 0, 1, -size * 8, size * 8), loc.y + map(random(1), 0, 1, -size * 8, size * 8)));
    for (int i = 0; i < bunch.size(); i++)
      bunch.get(i).display();
  }
}
