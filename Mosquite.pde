class Mosquite{
  float tx, ty;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float buzz; //impact of perlin noise
  float yums = 1;
  float energy;
  
  Mosquite(float x, float y, float m_, float NRG, float bz){
    location = new PVector(x,y); 
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    energy = NRG;
    tx = random(10000);
    ty = random(100);
    mass = m_;
    buzz = bz;
    
  }
  void display(){
    noStroke();
    fill(200);
    ellipse(location.x+(mass)*2,location.y-(mass)*2,mass * 4,mass * 4);
    ellipse(location.x-(mass)*2,location.y-(mass)*2,mass * 4,mass * 4);
    noStroke();
    fill(0);
    ellipse(location.x,location.y,mass * 4,mass * 4);
  }
  void step(){
    acceleration.x += buzz * map(noise(tx),0,1,-2,2) /100;
    acceleration.y += buzz * map(noise(ty),0,1,-2,2) /100;
    if (location.x + velocity.x < simW && location.x + velocity.x > 0 && location.y + velocity.y < simH && location.y + velocity.y > 0)
      location.add(velocity);
    else 
      velocity.mult(-0.8);
    tx += 0.01;
    ty += 0.01;
    velocity.add(acceleration);
    velocity.limit(3);
    location.add(velocity);
    acceleration.mult(0);
    energy--;
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }
  
  PVector attract(Frog f){
   PVector force = PVector.sub(location,f.location);
   float distance = force.mag();
   if (distance > 150)
     return force.mult(0);
   distance = constrain(distance,5,50.0); //think about division by very small or very big numbers
     
   force.normalize();
   float strength = (yums * mass * f.mass) / (distance * distance);
   force.mult(strength);     
   return force;
  }
  
  //check if I am near enough to a tree to collide with a fruit
  //maybe change this to accept the whole tree array
  int isCloseToTree(ArrayList<Tree> t){
   for (int i = 0; i < t.size(); i++){
     PVector force = PVector.sub(location,t.get(i).location);
     float distance = force.mag();
     if(distance < (t.get(i).size*10 + 9))
       return i;
   }
   return -1;
  }
  //if I am, check the fruit array to see if I've collided with a fruit
  int suckFruit(ArrayList<Tree> t, int tr){
   for (int i = 0; i < t.get(tr).bunch.size(); i++){
     PVector force = PVector.sub(location,t.get(tr).bunch.get(i).location);
     float distance = force.mag();
     if(distance < mass * 10)
       return i;
   }
   return -1;
  }
  int closestFruit(Tree t){
   int posMin = 0;
   for (int i = 0; i < t.bunch.size(); i++){
     PVector force = PVector.sub(location,t.bunch.get(i).location);
     float distance = force.mag();
     if (distance < PVector.sub(location,t.bunch.get(posMin).location).mag())
       posMin = i;
   }
   return posMin;
  }
  int closestTree(ArrayList<Tree> t){
    if (t.size() == 0)
      return -1;
    int posMin = 0;
   for (int i = 0; i < t.size(); i++){
     PVector force = PVector.sub(location,t.get(i).location);
     float distance = force.mag();
     if (t.get(i).bunch.size() > 0 && distance < PVector.sub(location,t.get(posMin).location).mag())
       posMin = i;
   }
   return posMin;
  }
}
