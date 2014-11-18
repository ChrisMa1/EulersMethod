//your variable declarations here
PImage ship;
PImage bolt;
PImage bg; 
SpaceShip one;
ArrayList<Bolt> bolts=new ArrayList<Bolt>();
public void setup(){
  size(1200,800);
  one=new SpaceShip();
  bg=loadImage("bg.jpg");
  ship=loadImage("ship.png");
  bolt=loadImage("bolt.png");
}
public void draw(){
  imageMode(CENTER);
  image(bg,width/2,height/2,width, height);
  for(int i=0; i<bolts.size(); i++){
    (bolts.get(i)).show();  
    (bolts.get(i)).move();  
    //if((bolts.get(i)).getX()
  }
  one.show();
  one.move();
  //println(one.getPointDirection());
  //your code here
}
class SpaceShip extends Floater{ 
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
    public void show(){
      pushMatrix();
        translate(getX(), getY());
        rotate((float)(radDir));
        image(ship,0,0,75,50);
      popMatrix();  
    }
    public void move(){
      if(turningR){
        strafe(1);
        //radDir+=0.2;  
      }
      if(turningL){
        strafe(-1);
        //radDir-=0.2;  
      }
      if(accel=="FWD"){
        accelerate(1);  
      }
      if(accel=="BK"){
        accelerate(-1);  
      }
      if(braking){
        myDirectionX*=.9;
        myDirectionY*=.9;
      }
      radDir=Math.asin((mouseX-myCenterX)/(dist((float)myCenterX,(float)myCenterY,mouseX,mouseY)))-Math.PI/2;
      if(myCenterY-mouseY<0)radDir*=-1;
      myPointDirection=radDir*180/(Math.PI);
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
    setDirectionX(Math.cos(radDir)*100);
    setDirectionY(Math.sin(radDir)*100);
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

