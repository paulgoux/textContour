import java.lang.reflect.*;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
int rows = 568/4,cols = 600/4,counter = cols*rows-1;
int minr = 1,minwr = 1,maxr = 1000000,maxwr = 1000000,W = 1200,H = 600,edgeLength;
String []functions ;
PImage pimg;
Img img;
boolean update,updateC,updateContours;
color pixel; 
String []wf = {"cannyTarget(4,255.0,1)"};
String imPath;
String shaderPath;
cell cell;
String loc ;
Button button;
void settings(){
  size(W,H,P2D);
}
void setup(){
  //String imPath = dataPath("images")+"\\";
  String imAndroidPath = dataPath("images").replace("/data/","")+"/";
  String shaderPath = dataPath("shaders").replace("/data/","")+"/";
  loc = imAndroidPath+"car.jpg";
  //img = new Img(loc);
  img = new Img("The cat sat on the wall!",1000,100,30,70,50);
  button = new Button(width - 100,10,90,20,"Reset");
};
int x =0,y =0;
int count = 0;
void draw(){
  background(50);
  logic();
  //if(count==0)img.canny(0,100.0,100,10);
  //count++;
  imgReset();
  if(!updateC&&img.img!=null)
  image(img.img,0,0);
  fill(0);
  if(!button.pos()&&mousePressed&&!updateC){
    println("getPixel");
    img.targetPixel = get(mouseX,mouseY);
    updateC=true;
    //String s = "cannyTarget(
  }
  
  if(updateC){
    //img.displayWF(wf);
    img.displayWFText(wf);
    //img.displayText();
    //img.cannyTarget(4,255.0,1);
    if(count ==0)println("workflow");
    updateContours = true;
    //if(mousePressed)println("red", red(img.targetPixel),"green",green(img.targetPixel),"blue", blue(img.targetPixel));
  }
  //img.displayWF(wf);
  //if(mousePressed&&
  if(updateC)count ++;
  if(updateContours){
    img.cell.drawEdges2();
  }
  button.draw();
};

void logic(){
  if(img.img!=null){
    if(pmouseX!=mouseX||pmouseY!=mouseY){
      if(img.img.width>width&&mouseX>0)
      x = (int)map(mouseX,0,img.img.width,0,width);
      if(img.img.height>height&&mouseY>0)
      y = (int)map(mouseY,0,height,0,img.img.height);
    }
    float a = 0,b=0;
    if(mouseX>0) a = map(mouseX,0,width,0,1);
    if(mouseY>0) b = map(mouseY,0,height,0,1);
    if(mouseX>0) edgeLength = (int)map(mouseX,0,width,0,10);
    img.s_mult = a;
    if(pmouseX!=mouseX||pmouseY!=mouseY)update = true;
    else update = false;
  }
};

void imgReset(){
  if(button.click()){
    //img = new Img(loc);
    img.reset(loc);
    updateC = false;
    println("reset");
    count = 0;
  }
};
