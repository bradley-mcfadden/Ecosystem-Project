class Fruit{
  PVector location;
  float red = random(255);
  float green = random(255);
  float yums;
  Fruit(float x_, float y_){
   location = new PVector(x_,y_);
   yums = 2 * (float)Math.sqrt(red + green);
 }
 void display(){
   noStroke();
   fill(red, green,19);
   ellipse(location.x,location.y,16,16);
 }
 
 PVector attract(Mosquite m){
  PVector force = PVector.sub(location,m.location);
  float distance = force.mag();
  if (distance > 100)
    return force.mult(0);
  distance = constrain(distance,5,50);
  force.normalize();
  float strength = (yums * 4 * m.mass) / (distance * distance);
  force.mult(strength);
  //force.div(distance);  
  return force;
 
 }
}
