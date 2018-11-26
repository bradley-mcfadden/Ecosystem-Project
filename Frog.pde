class Frog{
 PVector location;
 PVector velocity;
 PVector acceleration;
 float yums = -10;
 float mass;
 float j; //jump power
 float jFreq;
 float energy;
 float r,g,b;
 float repNRG;
 
 Frog(float x, float y, float red, float green, float blue, float m_, float j_, float jFreq_,float NRG){
   location = new PVector(x, y);
   velocity = new PVector(0,0);
   acceleration = new PVector(0,0);
   mass = m_;
   j = j_;
   jFreq = jFreq_;
   energy = NRG;
   r = red;
   g = green;
   b = blue;
   repNRG = mass * 300;
 }
 
 void update(){   
   velocity.add(acceleration);
   if (random(1) < jFreq){
   if (location.x + j * velocity.x < simW && location.x + j * velocity.x > 0 && location.y + j * velocity.y < simH && location.y + j * velocity.y > 0)
      location.add(PVector.mult(velocity,10));
    else 
      velocity.mult(-0.8);
   }
   velocity.limit(5);
   acceleration.mult(0);
   energy--;
 }
 void display(){
   float size = mass * 4.5;
   fill(r,g,b);
   stroke(r+10,g+10,b+10);
   strokeWeight(3);
   ellipse(location.x,location.y+0.375*size,0.75*size,0.75*size);
   ellipse(location.x,location.y,size,size);
   ellipse(location.x,location.y-0.5*size,0.75*size,size);
 }
 
 void applyForce(PVector force){
   PVector f = PVector.div(force,mass);
   acceleration.add(f);
 }
 
 PVector repel(Mosquite m){
  PVector force = PVector.sub(location,m.location);
  float distance = force.mag();
  if (distance > 50)
    return force.mult(0);
  distance = constrain(distance,5,50);
  force.normalize();
  float strength = (-mass * 4 * m.mass) / (distance * distance);
  force.mult(strength);
  return force;
 }
 
 //check if I hit a mosquito in an array of mosqutioes, if so, pop that mosquito
  int eatMosquite(ArrayList<Mosquite> m){
   for (int i = 0; i < m.size(); i++){
     PVector force = PVector.sub(location,m.get(i).location);
     float distance = force.mag();
     if(distance < mass*3)
       return i;
   }
   return -1;
  }
}
