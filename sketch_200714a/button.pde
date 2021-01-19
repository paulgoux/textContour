class Button{
  
  float x,y,w,h;
  String label;
  boolean mdown, m2down,click;
  
  Button(float x,float y,float w,float h,String label){
    
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  };
  
  void draw(){
    fill(255);
    rect(x,y,w,h);
    fill(255);
    if(pos())fill(0,100);
    rect(x,y,w,h);
    fill(0);
    
    text(label,x + 10,y+15);
    
  };
  
  boolean click(){
    boolean k = false;
      if (pos()&&mousePressed&&!click){
        click = true;
        k = false;
        mdown = true;
      }else if(click&&!mousePressed){
        k = true;
        click = false;
        mdown = false;
      }
      
      if(!mousePressed)mdown=false;
      
      return k;
  };
  
  boolean pos(){
    return mouseX>x&&mouseX<x+w&&mouseY>y&&mouseY<y+h;
  };
  
};
