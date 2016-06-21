void setup(){
  size(800,800);
  background(255, 255, 255);
  drawGrid();
  drawFunc();
}
void drawFunc(){
    float x;
    float y;
    ArrayList<Float> xpoints = new ArrayList<Float>(width);
    ArrayList<Float> ypoints = new ArrayList<Float>(height);
    for(int i=-width/2; i<=width/2;i+=1){
        x=i;
        // EQUATION LINE////////////////////////////
        
        y=x*x;
        
        ////////////////////////////////////////////
        y/=25;
        x+=width/2;
        y= -1*y + height/2;
        xpoints.add(x);
        ypoints.add(y);
        strokeWeight(2);
        if(xpoints.size()>=2){
            line(xpoints.get(i+width/2),ypoints.get(i+width/2),xpoints.get(i+width/2-1),ypoints.get(i+width/2-1));
        }
    } 
};
void drawGrid(){
    stroke(0);
    strokeWeight(6);
    line(width/2,0,width/2,height);
    line(0,height/2,width,height/2);
    stroke(115, 115, 255);
    strokeWeight(1);
    for(int i=0; i<=width;i+=25){
        line(i,0,i,height);
        line(0,i,width,i);
    }
};
void draw(){
  drawGrid();
  drawFunc();
}
};