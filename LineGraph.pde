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
 
 void sketch(int size, float max){
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
 void addPoint(Point p){
  co.add(p); 
 }
}
