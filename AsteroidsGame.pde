//your variable declarations here
PImage ship;
PImage bolt;
PImage bg; 
interface anAst{
 void move();
 void show();
 int getX();
 int getY();
 void takeHealth();
 int getHealth();
 int getHitRad();
 void die();
}
SpaceShip one;
Asteroid other;
ArrayList<Bolt> bolts=new ArrayList<Bolt>();
ArrayList<anAst> asteroids=new ArrayList<anAst>();
public void setup(){
  cursor(CROSS);
  size(1200,800);
  one=new SpaceShip();
  bg=loadImage("bg.jpg");
  ship=loadImage("ship.png");
  bolt=loadImage("bolt.png");
}

public void draw(){
  imageMode(CENTER);
  image(bg,width/2,height/2,width, height); //background image
  if(asteroids.size()<8){
    asteroids.add(new Asteroid());  //spawn new asteroids
  }
  if(bolts.size()>0){
    for(int i=0; i<bolts.size(); i++){
      (bolts.get(i)).show();  
      (bolts.get(i)).move();   
      if(dist(bolts.get(i).getX(), bolts.get(i).getY(), width/2, height/2)>800){
        bolts.remove(i);
      }  
    }
  }
  for(int i=0; i<bolts.size();i++){
    for(int j=0; j<asteroids.size();j++){
      if(asteroids.get(i)!=null && dist(bolts.get(i).getX(), bolts.get(i).getY(), asteroids.get(j).getX(), asteroids.get(j).getY())<asteroids.get(j).getHitRad()){
        bolts.remove(i);
        asteroids.get(j).takeHealth();
        break;
      } 
    }
  }
  for(int i=0; i<asteroids.size(); i++){
    asteroids.get(i).move();
    asteroids.get(i).show();
    if(dist(asteroids.get(i).getX(), asteroids.get(i).getY(), one.getX(), one.getY())<50+asteroids.get(i).getHitRad()){
      one.takeHealth(asteroids.get(i).getHealth());  
    }
    if(asteroids.get(i).getHealth()<=0||dist(asteroids.get(i).getX(), asteroids.get(i).getY(), width/2, height/2)>800){
      asteroids.get(i).die();
      asteroids.remove(i);
    }
  }
  for(int i=0; i<asteroids.size(); i++){
    if(dist(asteroids.get(i).getX(), asteroids.get(i).getY(), one.getX(), one.getY())<50+asteroids.get(i).getHitRad()){
      one.takeHealth(asteroids.get(i).getHealth());  
      asteroids.remove(i);
    }
  }
  one.show();
  one.move();
}
class SpaceShip extends Floater{ 
    private boolean alive=true;
    private int health=50;
    private double radDir =-Math.PI/2;  
    private boolean turningR=false;
    private boolean turningL=false;
    private boolean braking=false;
    private String accel="NONE";
    public SpaceShip(){
      myPointDirection=-90; 
      setX(width/2);
      setY(height/2);
    }
    public float getRadDir(){return (float)radDir;}
    public void setX(int x){myCenterX=x;}
    public int getX(){return (int)myCenterX;}
    public void setY(int y){myCenterY=y;}
    public int getY(){return (int)myCenterY;}
    public void setDirectionX(double x){myDirectionX=x;}
    public double getDirectionX(){return (double)myDirectionX;}
    public void setDirectionY(double y){myDirectionY=y;}
    public double getDirectionY(){return (double)myDirectionY;}
    public void setPointDirection(int degrees){myPointDirection=degrees;}
    public double getPointDirection(){return (double)myPointDirection;}
    public boolean isAlive(){return alive;}
    public void takeHealth(int num){health-=num;};
    //public void 
    public void show(){
      pushMatrix();
        translate(getX(), getY());
        rotate((float)(radDir));
        image(ship,0,0,100,80);
      popMatrix();  
      //System.out.println(health);
    }
    public void move(){
      if(turningR){
        strafe(0.5);
        //radDir+=0.2;  
      }
      if(turningL){
        strafe(-0.5);
        //radDir-=0.2;  
      }
      if(accel=="FWD"){
        accelerate(0.5);  
      }
      if(accel=="BK"){
        accelerate(-0.5);  
      }
      if(braking){
        myDirectionX*=.9;
        myDirectionY*=.9;
      }
      radDir=Math.asin((mouseX-myCenterX)/(dist((float)myCenterX,(float)myCenterY,mouseX,mouseY)))-Math.PI/2;
      if(myCenterY-mouseY<0)radDir*=-1;
      myPointDirection=radDir*180/(Math.PI);
      if(myDirectionX>20)myDirectionX=20;
      if(myDirectionY>20){myDirectionY=20;}
      myCenterX += myDirectionX;    
      myCenterY += myDirectionY;     
      //wrap around screen    
      if(myCenterX >width){     
        myCenterX = 0;    
      }else if (myCenterX<0){myCenterX = width;}    
      if(myCenterY >height){    
        myCenterY = 0;    
      }else if (myCenterY < 0){     
        myCenterY = height;    
      } 
    }
    public void strafe (double dAmount){          
    //convert the current direction the floater is pointing to radians    
    double dRadians =myPointDirection*(Math.PI/180);     
    //change coordinates of direction of travel    
    myDirectionX += ((dAmount) * Math.cos(dRadians+Math.PI/2));    
    myDirectionY += ((dAmount) * Math.sin(dRadians+Math.PI/2));       
  }   
}///////////////////////////////////////////////////////////////////////////////////
class Bolt extends Floater{
  private float radDir;
  Bolt(){
    radDir=one.getRadDir();
    setDirectionX(Math.cos(radDir)*50);
    setDirectionY(Math.sin(radDir)*50);
    setX(one.getX());
    setY(one.getY());
  }
  public void setX(int x){myCenterX=x;}
  public int getX(){return (int)myCenterX;}
  public void setY(int y){myCenterY=y;}
  public int getY(){return (int)myCenterY;}
  public void setDirectionX(double x){myDirectionX=x;}
  public double getDirectionX(){return (double)myDirectionX;}
  public void setDirectionY(double y){myDirectionY=y;}
  public double getDirectionY(){return (double)myDirectionY;}
  public void setPointDirection(int degrees){myPointDirection=degrees;}
  public double getPointDirection(){return (double)myPointDirection;}
  public void show(){
  pushMatrix();
    translate((float)myCenterX, (float)myCenterY);
    rotate(radDir);
    image(bolt,0, 0, 30, 20);
  popMatrix();
  }
  public void move (){      
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;     
  }
}/////////////////////////////////////////////////////////////////////////////////////
class Asteroid extends Floater  implements anAst{
  protected int health;
  protected float heading;
  protected float rotateBy;
  protected PImage img;
  protected float theSize;
  protected int posDeg;
  private int targX;
  private int targY;
  Asteroid(){
    health=2;
    posDeg=(int)(Math.random()*360);
    targX= (int)(Math.random()*(height-200)+100);
    targY= (int)(Math.random()*(width-200)+100);
    myCenterX=Math.cos(Math.PI*posDeg/180)*725+width/2;
    myCenterY=Math.sin(Math.PI*posDeg/180)*725+height/2;
    myDirectionX= (targX-myCenterX)/200;
    myDirectionY= (targY-myCenterY)/200;
    heading=0;
    rotateBy=(float)(Math.random()*0.04-0.2);
    theSize=(float)(Math.random()*30 +60);
    double num=Math.random();
    if(num>0.25){
      img=loadImage("asteroid.png");
    }else if(num<0.5){
      img=loadImage("asteroid1.png");
    }else if(num<0.75){
      img=loadImage("asteroid2.png");
    }else{
      img=loadImage("asteroid3.png");
    }
  }
  public void setX(int x){myCenterX=x;}
  public int getX(){return (int)myCenterX;}
  public void setY(int y){myCenterY=y;}
  public int getY(){return (int)myCenterY;}
  public void setDirectionX(double x){myDirectionX=x;}
  public double getDirectionX(){return (double)myDirectionX;}
  public void setDirectionY(double y){myDirectionY=y;}
  public double getDirectionY(){return (double)myDirectionY;}
  public void setPointDirection(int degrees){myPointDirection=degrees;}
  public double getPointDirection(){return (double)myPointDirection;}
  public int getHealth(){return health;}
  public void takeHealth(){health-=1;}
  public int getHitRad(){return (int)theSize/2+10;}
  void move(){
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;
  }
  void show(){
    pushMatrix();
    translate((float)myCenterX,(float)myCenterY);
    heading+=rotateBy;
    rotate(heading);
    image(img,0,0,theSize,theSize);   
    popMatrix();
  }
  void die(){
    for(int i=0; i<((int)(Math.random()*2+3)); i++){
      asteroids.add(new SmallAsteroid((int)myCenterX,(int)myCenterY)); 
    } 
  }
}//////////////////////////////////////////////////////////////////////////////////////
class SmallAsteroid extends Asteroid{
  SmallAsteroid(int x,int y){
    health=1;
    myCenterX=x;
    myCenterY=y;
    myDirectionX=(Math.random()*16-8);
    myDirectionY=(Math.random()*16-8);
    heading=0;
    rotateBy=(float)(Math.random()*0.04-0.2);
    theSize=(float)(Math.random()*10 +30);
    double num=Math.random();
    if(num>0.25){
      img=loadImage("asteroid.png");
    }else if(num<0.5){
      img=loadImage("asteroid1.png");
    }else if(num<0.75){
      img=loadImage("asteroid2.png");
    }else{
      img=loadImage("asteroid3.png");
    }
  }
  void die(){
    
  }  
}/////////////////////////////////////////////////////////////////////////////////////////////////////////

void mousePressed(){
  bolts.add(new Bolt());
}
void keyPressed(){
  if( key=='w'){
    one.accel="FWD";
  }
  if(key=='s'){
    one.accel="BK";
  }  
  if(key=='a'){
    one.turningL=true;
  }
  if(key=='d'){
    one.turningR=true;    
  }
  if(key==' '){
    one.braking=true;  
  }
}
void keyReleased(){
  if( key=='w'){
    one.accel="NONE";
  }
  if(key=='s'){
    one.accel="NONE";
  }  
  if(key=='a'){
    one.turningL=false;
  }  
  if(key=='d'){
    one.turningR=false;    
  }
  if(key==' '){
    one.braking=false;  
  }
}
 // // ////////////////////////////////////////////////////////////////////////////////////////////////
// // ////////////////////////////////////////////////////////////////////////////////////////////////
abstract class Floater //Do NOT modify the Floater class! Make changes in the SpaceShip class 
{   
  protected int corners;  //the number of corners, a triangular floater has 3   
  protected int[] xCorners;   
  protected int[] yCorners;   
  protected int myColor;   
  protected double myCenterX, myCenterY; //holds center coordinates   
  protected double myDirectionX, myDirectionY; //holds x and y coordinates of the vector for direction of travel   
  protected double myPointDirection; //holds current direction the ship is pointing in degrees    
  abstract public void setX(int x);  
  abstract public int getX();   
  abstract public void setY(int y);   
  abstract public int getY();   
  abstract public void setDirectionX(double x);   
  abstract public double getDirectionX();   
  abstract public void setDirectionY(double y);   
  abstract public double getDirectionY();   
  abstract public void setPointDirection(int degrees);   
  abstract public double getPointDirection(); 

  //Accelerates the floater in the direction it is pointing (myPointDirection)   
  public void accelerate (double dAmount)   
  {          
    //convert the current direction the floater is pointing to radians    
    double dRadians =myPointDirection*(Math.PI/180);     
    //change coordinates of direction of travel    
    myDirectionX += ((dAmount) * Math.cos(dRadians));    
    myDirectionY += ((dAmount) * Math.sin(dRadians));       
  }   
  public void rotateShip (int nDegreesOfRotation)   
  {     
    //rotates the floater by a given number of degrees    
    myPointDirection+=nDegreesOfRotation;   
  }   
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myDirectionX and myDirectionY       
    myCenterX += myDirectionX;    
    myCenterY += myDirectionY;     

    //wrap around screen    
    if(myCenterX >width)
    {     
      myCenterX = 0;    
    }    
    else if (myCenterX<0)
    {     
      myCenterX = width;    
    }    
    if(myCenterY >height)
    {    
      myCenterY = 0;    
    }   
    else if (myCenterY < 0)
    {     
      myCenterY = height;    
    }   
  }   
  public void show ()  //Draws the floater at the current position  
  {             
    fill(myColor);   
    stroke(myColor);    
    //convert degrees to radians for sin and cos         
    double dRadians = myPointDirection*(Math.PI/180);                 
    int xRotatedTranslated, yRotatedTranslated;    
    beginShape();         
    for(int nI = 0; nI < corners; nI++)    
    {     
      //rotate and translate the coordinates of the floater using current direction 
      xRotatedTranslated = (int)((xCorners[nI]* Math.cos(dRadians)) - (yCorners[nI] * Math.sin(dRadians))+myCenterX);     
      yRotatedTranslated = (int)((xCorners[nI]* Math.sin(dRadians)) + (yCorners[nI] * Math.cos(dRadians))+myCenterY);      
      vertex(xRotatedTranslated,yRotatedTranslated);    
    }   
    endShape(CLOSE);  
  }   
} 

