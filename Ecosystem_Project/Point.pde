/**
 *Contains the information for a simple x,y point.
 */
public class Point {
  private float x;
  private float y;

  /**
   *Initialize a new point.
   *@param x The x value of the point.
   *@param y The y value of the point.
   */
  public Point(float x_, float y_) {
    x = x_;
    y = y_;
  }

  /**
   *Constructor for copying an existing point.
   *@param Point to be copied.
   */
  public Point(Point p) {
    x = p.x;
    y = p.y;
  }

  /**
   *Method for returning a copy of the point.
   *@return Copy of this point.
   */
  public Point copy() {
    Point p = new Point(this);
    return p;
  }  

  /**
   *Returns the point as a coordinate.
   *@return Coordinate in form (x,y)_.
   */
  public String toString() {
    String s = ("("+x+", "+y+") ");
    return s;
  }

  /**
   *Return x value of point.
   *@return Point's x value.
   */
  public float getX() {
    return x;
  }

  /**
   *Return the y value of a point.
   *@param Point's y value.
   */
  public float getY() {
    return y;
  }
}
