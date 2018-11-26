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
 void display(){
  noStroke();
  fill(150,75,0);
  rectMode(CENTER);
  rect(location.x,location.y+(20),15,20*size);
  noStroke();
  fill(15*greenScale + 100,235*greenScale,0,150);
  ellipse(location.x,location.y,size*20,size*20);
 }
 Tree copy(){
  Tree copy = new Tree(location.x,location.y,size,greenScale);
  return copy;
 }
 void update(){
  if(bunch.size() < 5 && random(1) < 0.01)
    bunch.add(new Fruit(location.x + map(random(1),0,1,-size*8,size*8),location.y + map(random(1),0,1,-size*8,size*8)));
  for (int i = 0; i < bunch.size(); i++)
    bunch.get(i).display();
 }
}
