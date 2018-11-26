/**
 *Contains methods for drawing a line graph, one line with median lines and titles for both the graph and axis.
 */
public class LineGraph {
  private ArrayList<Point> co;
  private float x;
  private float y;
  private float xsize;
  private float ysize;
  private String title;
  private String xTitle;
  private String yTitle;
  private int rL, gL, bL;
  private int rBG, gBG, bBG;


  /**
   *Create a new line graph at x,y of size width * height.
   *@param x Xpos of graph.
   *@param y Ypos of graph.
   *@param width Width of graph.
   *@param height Height of graph.
   */
  public LineGraph(float x_, float y_, float wdth_, float hght_) {
    co = new ArrayList<Point>();
    x = x_;
    y = y_;
    xsize = wdth_;
    ysize = hght_;
    title = " ";
    xTitle = " ";
    yTitle = " ";
    rL = 255;
    gL = 0;
    bL = 0;
    rBG = 255;
    gBG = 200;
    bBG = 200;
  }

  /**
   *Create a new line graph with graph and axis titles.
   *@param x Xpos of graph.
   *@param y Ypos of graph.
   *@param width Width of graph.
   *@param height Height of graph.
   *@param t Graph title.
   *@param tx X axis title.
   *@param ty Y axis title.
   */
  public LineGraph(float x_, float y_, float wdth_, float hght_, String t, String tx, String ty) {
    co = new ArrayList<Point>();
    x = x_;
    y = y_;
    xsize = wdth_;
    ysize = hght_;
    title = t;
    xTitle = tx;
    yTitle = ty;
    rL = 255;
    gL = 0;
    bL = 0;
    rBG = 255;
    gBG = 200;
    bBG = 200;
  }

  /**
   *Create a copy of the line graph.
   *@param Line graph to be copied.
   */
  public LineGraph(LineGraph l) {
    co = new ArrayList<Point>(co.size());
    
    for (int i = 0; i < l.co.size(); i++)  
      co.add(new Point(l.co.get(i)));
      
    x = l.x;
    y = l.y;
    xsize = l.xsize;
    ysize = l.ysize;
    title = l.title;
    xTitle = l.xTitle;
    yTitle = l.yTitle;
    rL = l.rL;
    gL = l.gL;
    bL = l.bL;
    rBG = l.rBG;
    gBG = l.gBG;
    bBG = l.bBG;
  }

  /**
   *Return a copy of this instance of line graph.
   *@return Copy of this graph.
   */
  public LineGraph copy() {
    LineGraph l = new LineGraph(this);
    return l;
  }

  /**
   *Return any important data of this class as a string.
   *@param List of important parameters, including every existing point.
   */
  public String toString() {
    String s = ("Position : (" + x + ", " + y + ") Size: (" + xsize + ", " + ysize +") Points: ");
    for (int i = 0; i < co.size(); i++)
      s.concat(co.get(i).toString());
    return s;
  }

  /**
   *Shift the graph along the canvas.
   *@param cX Change in x position.
   *@param cY Change in y position.
   */
  public void translate(float cX, float cY) {
    this.x += cX;
    this.y += cY;
  }

  /**
   *Scale the graph's size.
   *@param cX Multiplier for x axis.
   *@param cY Mulitplier for y axis.
   */
  public void scale(float cX, float cY) {
    this.xsize *= cX;
    this.ysize *= cY;
  }

  /**
   *Change the labels of the graph.
   *@param t Graph title.
   *@param tx X-axis title.
   *@param ty Y-axis title.
   */
  public void rename(String t, String tx, String ty) {
    title = t;
    xTitle = tx;
    yTitle = ty;
  }

  /**
   *Change the color of the line and the background.
   *@param lR The red value of the line.
   *@param lG The green value of the line.
   *@param lB The blue value of the line.
   *@param bgR The red vlaue fo the background.
   *@param bgG The green value of the background.
   *@param bgB The blue value of the background.
   */
  public void setColor(int lR, int lG, int lB, int bgR, int bgG, int bgB) {
    rL = lR;
    gL = lG;
    bL = lB;
    rBG = bgR;
    gBG = bgG;
    bBG = bgB;
  }

  /**
   *Draw the graph and any axis titles.
   */
  public void sketch(int size, float max) {
    pushMatrix();
    popMatrix();
    float domain = (float)xsize / size;
    fill(rL, gL, bL);
    stroke(0);
    rectMode(CORNER);
    rect(x, y, xsize, ysize);
    for (int i = 0; i < size - 1; i++) {
      strokeWeight(3);
      stroke(rBG, gBG, bBG);
      if (i == size-2)
        line(x+(i*domain), (y+ysize)-(ysize*(co.get(i).getY()/max)), x+xsize, (y+ysize)-(ysize*(co.get(i+1).getY()/max)));
      else
        line(x+(i*domain), (y+ysize)-(ysize*(co.get(i).getY()/max)), x+(i+1)*domain, (y+ysize)-(ysize*(co.get(i+1).getY()/max)));
    }
    PFont f = createFont("Console", 16, true);
    textFont(f, 12);
    textAlign(LEFT);
    fill(0, 255);
    text(max/2, x, (y+ysize)-(ysize*(max/2)/max)); //1/2 of yscale line
    text((max/4), x, (y+ysize)-(ysize*(max/4)/max)); //1/4 of yscale line
    text(3*(max/4), x, ((y+ysize)-(ysize*(3*max/4)/max))); //3/4 of yscale line

    
    textFont(f, 16);
    textAlign(CENTER);
    text(title, x + xsize / 2, y+20);
    text(xTitle, x + xsize / 2, y + ysize-10);
    
    /*
    pushMatrix();
    translate(x + xsize / 2, y + 20);
    rotate(-HALF_PI);
    text("Some vertical text",0,0);
    popMatrix();
    //text("Some not vertical text",20,20);
    */
  }

  /**
   *Add a new point to the end of the graph.
   */
  public void addPoint(Point p) {
    co.add(p);
  }
}
