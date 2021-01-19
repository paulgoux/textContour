class Img {
  float Mean = 0,Variance,VarianceR,VarianceG,VarianceB,VarianceBR,s_mult,x,y,size,px,py;
  public PImage img,img2,backup,mean,mean_,meanGx,meanGy,blurX,blurY, threshold, variance,varianceR,varianceG,varianceB,varianceBR,Gaussian,
         kMeans, kNearest,sobel, sobelx, sobely,sobel2, sobel2x, sobel2y, sobelMax,sobelMin,sobelG,gradientB, blur,combined,canny,cannyT,cannyT1,contour;
  public String currentParameter,currentS;
  public float currentF;
  boolean update = true,mdown,m2down,updateImg;
  ArrayList<String>workFlowLabels = new ArrayList<String>(); ;
  String imPath = dataPath("images");
  String shaderPath = dataPath("shaders")+"\\";
  String text;
  ArrayList<PImage> images = new ArrayList<PImage>();
  ArrayList<PImage> imagesWF = new ArrayList<PImage>();
  color targetPixel,fill,bg;
  int counter,bands;
  PGraphics c1,c2,pass1,pass2,pass3,pass4;
  PImage temp;
  //currentField;
  String [] instructions;
  cell cell;
  
  color [][]neighbours;
  float [][]gradient;
  float []gx,gy;
  
  Img(String s) {
    img = loadImage(s);
    //img = loadImage(s);
    img2 = loadImage(s);
    neighbours = new color[img.width][img.height];
    gradient = new float[img.width][img.height];
    c1 = createGraphics(img.width,img.height,P2D);
    c2 = createGraphics(img.width,img.height,P2D);
    pass1 = createGraphics(img.width,img.height,P2D);
    pass2 = createGraphics(img.width,img.height,P2D);
    
    c1.beginDraw();
    c1.image(img, 0, 0);
    c1.endDraw();
    pass1.beginDraw();
    pass1.image(img, 0, 0);
    pass1.endDraw();
    pass2.beginDraw();
    pass2.image(img, 0, 0);
    pass2.endDraw();
    cell = new cell();
    cell.pImage = this.img;
  };
  
  Img(String s,int w,int h,int px,int py){
    PGraphics canvas = createGraphics(w,h,P2D);
    img = new PImage(w,h,ARGB);
    img2 = new PImage(w,h,ARGB);
    
    this.size = 12;
    this.fill = color(0);
    this.bg = color(255);
    this.text = s;
    this.px = px;
    this.py = py;
    
    canvas.beginDraw();
    canvas.background(255);
    canvas.fill(0);
    canvas.text(s,px,py);
    canvas.endDraw();
    img = canvas.get();
    img2 = canvas.get();
    //c1 = createGraphics(img.width,img.height,P2D);
    //c2 = createGraphics(img.width,img.height,P2D);
    init();
  };
  
  Img(String s,int w,int h,int px,int py,color bg,color fill,float size){
    PGraphics canvas = createGraphics(w,h,P2D);
    img = new PImage(w,h,ARGB);
    img2 = new PImage(w,h,ARGB);
    
    this.size = size;
    this.fill = fill;
    this.bg = bg;
    this.text = s;
    this.px = px;
    this.py = py;
    //c1 = createGraphics(w,h,P2D);
    //c2 = createGraphics(w,h,P2D);
    init();
  };
  
  Img(String s,int w,int h,int px,int py,float size){
    PGraphics canvas = createGraphics(w,h,P2D);
    img = new PImage(w,h,ARGB);
    img2 = new PImage(w,h,ARGB);
    
    this.size = size;
    this.fill = color(0);
    this.bg = color(255);
    this.text = s;
    this.px = px;
    this.py = py;
    
    //c1 = createGraphics(w,h,P2D);
    //c2 = createGraphics(w,h,P2D);
    init();
  };
  
  Img(){
    
  };
  void init(){
    neighbours = new color[img.width][img.height];
    gradient = new float[img.width][img.height];
    c1 = createGraphics(img.width,img.height,P2D);
    c2 = createGraphics(img.width,img.height,P2D);
    pass1 = createGraphics(img.width,img.height,P2D);
    pass2 = createGraphics(img.width,img.height,P2D);
    c1.beginDraw();
    c1.image(img, 0, 0);
    c1.endDraw();
    pass1.beginDraw();
    pass1.image(img, 0, 0);
    pass1.endDraw();
    pass2.beginDraw();
    pass2.image(img, 0, 0);
    pass2.endDraw();
    cell = new cell();
    cell.pImage = this.img;  
  };
  
  void displayText(){
    c1.beginDraw();
    c1.beginDraw();
    c1.background(bg);
    c1.fill(fill);
    c1.textSize(size);
    c1.text(text,px,py);
    c1.endDraw();
    img = c1.get();
    img2 = c1.get();
    if(!updateImg){
      imagesWF.add(img);
      workFlowLabels.add("img");
      updateImg = true;
      init();
    }
  };
  
  void reset(String s){
    imagesWF = new ArrayList<PImage>();
    
    //img = new PImage(img.width,img.height,ARGB);
    update = true;
    img = loadImage(s);
    img2 = loadImage(s);
    //img = img2;
    neighbours = new color[img.width][img.height];
    gradient = new float[img.width][img.height];
    //c1 = createGraphics(img.width,img.height,P2D);
    //c2 = createGraphics(img.width,img.height,P2D);
    //pass1 = createGraphics(img.width,img.height,P2D);
    //pass2 = createGraphics(img.width,img.height,P2D);
    //pass3 = createGraphics(img.width,img.height,P2D);
    //pass4 = createGraphics(img.width,img.height,P2D);
    c1.clear();
    ////c2.clear();
    pass1.clear();
    pass2.clear();
    //c1.beginDraw();
    //c1.image(img, 0, 0);
    //c1.endDraw();
    //pass1.beginDraw();
    //pass1.image(img, 0, 0);
    //pass1.endDraw();
    //pass2.beginDraw();
    //pass2.image(img, 0, 0);
    //pass2.endDraw();
    //pass3.beginDraw();
    //pass3.image(img, 0, 0);
    //pass3.endDraw();
    //pass4.beginDraw();
    //pass4.image(img, 0, 0);
    //pass4.endDraw();
    //cell = new cell();
    cell.pImage = this.img;
    Runtime.getRuntime().gc();
  };
  
  void workflow(String a){
    String[] s = splitTokens(a, "-");
    
    if(update){
      for(int i=0;i<s.length;i++){
        String s1 = s[i];
        
        //ArrayList<Integer> [] pIndex = strIndex(s1,"(",")");
        int [] pIndex = strIndex1(s1,"(",")");
        String function = s1.substring(0,pIndex[0]);
        
        //String[]parameters = new String [pIndex[0].size()];
        String[]parameters = splitTokens(s[i].substring(pIndex[0]+1,pIndex[1]),",");
        parameters[parameters.length-1] =  parameters[parameters.length-1].substring(0,parameters.length-1);
        
        boolean image = false;
        Method method = null;
        try {
          method = this.getClass().getMethod(function,float.class,float.class);
          //Img instance = new Img();
          float result = (float) method.invoke(this, 1, 3);
          println("result",result);
        } catch (SecurityException e) {
          println(function , "se");
        }catch (NoSuchMethodException e) {  
          println(function , "nsm");
        }
        catch (IllegalAccessException e) {  
          println(function , "nsm");
        }
        catch (InvocationTargetException e) {  
          println(function , "nsm");
        }
        for(int j=0;j<parameters.length;j++){
          
          float currentF = float(parameters[j]);
          
          if(currentF>-10000000&&currentF<10000000){
            println(function,"f " + currentF);
          }else println(function,"s " + parameters[j]);
          
        }
      }update = false;
    }
  };
  
    Object parseParameter(String parameter) {
    try {
        return Integer.parseInt(parameter);
      } catch(NumberFormatException e) {
          try {
              return Float.parseFloat(parameter);
          } catch(NumberFormatException e1) {
              try {
                  Field field = this.getClass().getField(parameter);
                  return field.get(this);
              } catch (NoSuchFieldException e2){return null;}
                catch(IllegalAccessException e2) {
                  throw new RuntimeException(e2);
                  //return null;
              }
          }
      }
  };

  Class<?> getParameterClass(String parameter) {
      try {
          Integer.parseInt(parameter);
          return int.class;
      } catch(NumberFormatException e) {
          try {
              Float.parseFloat(parameter);
              return float.class;
          } catch(NumberFormatException e1) {
              
              if(parameter!=null)return PImage.class;
              else return null;
          }
      }
  };
  
  void workflow(String[] a){
    if(update&&a!=null){
      String[] s = a;
      println("size",imagesWF.size());
      for(int i=0;i<s.length;i++){
        String s1 = s[i];
        if(s[i].length()>0){
          int [] pIndex = strIndex1(s1,"(",")");
          String function = s1.substring(0,pIndex[0]);
          
          String[]parameters = splitTokens(s[i].substring(pIndex[0]+1,pIndex[1]),",");
          print("p",function +"(");
          
          String s2 = "";
          Class<?>[] parameterClasses = new Class<?>[parameters.length];
          Object[] parsedParameters = new Object[parameters.length];
          for(int j=0;j<parameters.length;j++){
            //print(parameters[j]);
            
            parameterClasses[j] = getParameterClass(parameters[j]);
            parsedParameters[j] = parseParameter(parameters[j]);
            // s2+=parameterClasses[j]+" "+parameters[j];
            s2 += parameters[j];
            if(j<parameters.length-1)s2+=",";
          }
          println(s2+")");
          
          update = true;
          try {
              Method method = this.getClass().getMethod(function, parameterClasses);
              method.invoke(this, parsedParameters);
              img = imagesWF.get(imagesWF.size()-1);
              //workFlowLabels.add("sobel");
              workFlowLabels.add("contour");
            } catch (NoSuchMethodException e){println("nsm",function,"...Check Params?");}
              catch(IllegalAccessException e){println("ia") ;}
              catch( InvocationTargetException e){println("it","This function is missing an image...");e.printStackTrace();}
    }}
    update = false;
    println("labels ",workFlowLabels.size());
  }else if(a==null)update = false;
  
  if(keyPressed&&key =='r')update = true;
      
  };
  
  
  
  float mult(float a,float b){
    return a * b;
  };
  
  
  int [] strIndex1(String s,String a,String b){
    int[]index = new int [2];
    for(int i=0;i<s.length();i++){
      char c = s.charAt(i);
      if(c=='(')index[0] = i;
      if(c==')')index[1] = i;
    }
    return index;
  };
  
  ArrayList [] strIndex(String s,String a,String b){
    ArrayList[]index = new ArrayList [2];
    index[0] = new ArrayList<Integer>();
    index[1] = new ArrayList<Integer>();
    for(int i=0;i<s.length();i++){
      char c = s.charAt(i);
      if(c=='(')index[0].add(i);
      if(c==')')index[1].add(i);
    }
    return index;
  };
  
  int findNext(String s){
    int a = -1;
    
    return a;
  };
  
  void set(PImage p){
    img = p;
    c1 = createGraphics(img.width,img.height,P2D);
  };


  
  
  void displayWFText(String []s){
    logic();
    displayText();
    workflow(s);
    if(imagesWF.size()>0)
    image(imagesWF.get(counter),x,y);
    //if(counter<workFlowLabels.size())
    text(workFlowLabels.get(counter),10,10);
    //println(imagesWF.size());
  };
  
  void displayWF(String []s){
    logic();
    workflow(s);
    if(imagesWF.size()>0)
    image(imagesWF.get(counter),x,y);
    if(counter<workFlowLabels.size())text(workFlowLabels.get(counter),10,10);
    //println(imagesWF.size());
  };
  
  void displayWF2(String []s){
    logic2();
    workflow(s);
    
    //if(imagesWF.size()>0)
    image(imagesWF.get(counter),0,0);
    //if(pmouseX!=mouseX){
    //  cell.canny.loadPixels();
    //  for(int i=0;i<cell.edges.size();i++){
    //    //cell c0 = cell.edges.get(i).get(0);
    //    //fill(0);
    //    //text(i,c0.x+10,c0.y);
    //    if(cell.edges.get(i).size()>edgeLength){
    //      for(int j=0;j<cell.edges.get(i).size();j++){
    //      cell c = cell.edges.get(i).get(j);
    //      cell.canny.pixels[(int)c.x+(int)c.y*img.width] = color(0);
    //      }
    //    }else{
    //      for(int j=0;j<cell.edges.get(i).size();j++){
    //      cell c = cell.edges.get(i).get(j);
    //      cell.canny.pixels[(int)c.x+(int)c.y*img.width] = color(255);
    //      }
    //    }
    //  }
    //  cell.canny.updatePixels();
    //}
    //if(cell.update&&cell.edges.size()>0)
    //for(int j=0;j<cell.edges.get(counter).size();j++){
    //  cell c = cell.edges.get(counter).get(j);
    //  //pixels[(int)c.x+(int)c.y*img.width] = color(0);
    //  stroke(0);
    //  point(c.x,c.y);
    //}
    
    for(int j=0;j<cell.cells.size();j++){
      
    }
    
    cell c = cell.unsortedEdges.get(counter);
    stroke(0);
    //point(c.x,c.y);
    //c.debug();
    //for(int j=0;j<cell.neighbours.size();j++){
    //  cell c1 = cell.neighbours.get(i);
      
    //}
    //updatePixels();
  };
  
  void displayWF(){
    logic2();
      //for(int i=0;i<cell.edges.size();i++){
      //  if(cell.edges.get(i).size()>edgeLength){
      //    for(int j=0;j<cell.edges.get(i).size();j++){
      //      cell c = cell.edges.get(i).get(j);
      //      stroke(0);
      //      point(c.x,c.y);
      //    }
      //  }
      //}
    
    
    for(int j=0;j<cell.edges.get(counter).size();j++){
      cell c = cell.edges.get(counter).get(j);
      stroke(0);
      point(c.x,c.y);
    }
  };
  
  
  void logic(){
    int count = 0;
    if(!button.pos()&&mousePressed&&!mdown){
      mdown = true;
      counter++;
      
    }
    
    if(counter<imagesWF.size()){
      if(imagesWF.get(counter).width>width){
        if(mouseX>0&&mouseX<width)x = -(int)map(mouseX,0,width,0,imagesWF.get(counter).width-width);
      }
      if(imagesWF.get(counter).height>height){
        if(mouseY>0&&mouseY<height)y = -(int)map(mouseY,0,height,0,imagesWF.get(counter).height-height);
      }
    }
    
    if(!mousePressed){
      mdown = false;
      m2down = false; 
    }
    if(counter>imagesWF.size()-1)counter = 0;
    if(imagesWF.size()>0&&mdown&&!m2down){
      m2down = true;
      if(counter<workFlowLabels.size())println(workFlowLabels.get(counter),imagesWF.size());
      
    }
    
  };
  
  void logic2(){
    //if(mousePressed&&!mdown){
    //  mdown = true;
    //  counter++;
    //  println(counter);
    //}
    
    if(mouseX>0)counter = (int)map(mouseX,0,width,0,imagesWF.size());
    //if(mouseX>0)counter = (int)map(mouseX,0,width,0,cell.edges.size());
    
    if(!mousePressed)mdown = false;
    //if(counter>cell.edges.size()-1)counter = 0;
    fill(0);
    text("c "+counter,10,20);
  };
  
  void cannyTarget(int mode,float t1,int t2) {
    canny = new PImage(img.width, img.height, RGB);
    
    cell.Mode = mode;
    cell.pixelThresh = 20000;
    cell.pixelThresh1 = t2;
    println("cutoff",t1);
    cell.cutoff = t1;
    cell.imgUpdate(img,targetPixel);
    cell.getContour();
    imagesWF.add(cell.canny);
    //imagesWF.add(cell.backup);
    //imagesWF.add(cell.img);
  };
  
  void cannyTarget(int mode,int t1,int t2) {
    canny = new PImage(img.width, img.height, RGB);
    
    cell.Mode = mode;
    cell.pixelThresh = 20000;
    cell.pixelThresh1 = t2;
    println("cutoff",t1);
    cell.cutoff = t1;
    cell.imgUpdate(img,targetPixel);
    cell.getContour();
    imagesWF.add(cell.canny);
    //imagesWF.add(cell.backup);
    //imagesWF.add(cell.img);
  };
  
  
  
  void contour(int t){
    contour = new PImage(img.width,img.height,ARGB);
    contour.loadPixels();
    for(int i=0;i<img.width;i++){
      for(int j=0;j<img.height;j++){
        int p = i + j * img.width;
        if(neighbours(i,j,t)){
          contour.pixels[p] = color(brightness(img.pixels[p]));
        }else{
          contour.pixels[p] = color(255);
        }
    }}
    contour.updatePixels();
    imagesWF.add(contour);
  };
  
  boolean neighbours(int x,int y,int t){
    boolean k = false;
    
    int p = x + y * img.width;
    float r = red(img.pixels[p]);
    float g = green(img.pixels[p]);
    float b = blue(img.pixels[p]);
    float a = brightness(img.pixels[p]);
    for(int i=x-1;i<=x+1;i++){
      for(int j=y-1;j<=y+1;j++){
        
        int p1 = i + j * img.width;
        if(p1>0&&p1<img.pixels.length&&p!=p1){
          float r1 = red(img.pixels[p1]);
          float g1 = green(img.pixels[p1]);
          float b1 = blue(img.pixels[p1]);
          float a1 = brightness(img.pixels[p1]);
          
          float d1 = abs(r-r1);
          float d2 = abs(g-g1);
          float d3 = abs(b-b1);
          float d4 = abs(a-a1);
          //println(d1,d2,d3);
          if(d1>t||d2>t||d3>t||d4>t){
            k = true;
            
          }
          //float vx += 
        }
    }}
    return k;
  };
  
  boolean neighbours2(int x,int y,int t){
    boolean k = false;
    
    int p = x + y * img.width;
    float r = red(img.pixels[p]);
    float g = green(img.pixels[p]);
    float b = blue(img.pixels[p]);
    float a = brightness(img.pixels[p]);
    float max = r;
    if(g>max)max = g;
    if(b>max)max = b;
    //if(a>max)max = a;
    for(int i=x-1;i<=x+1;i++){
      for(int j=y-1;j<=y+1;j++){
        
        int p1 = i + j * img.width;
        if(p1>0&&p1<img.pixels.length&&p!=p1){
          float r1 = red(img.pixels[p1]);
          float g1 = green(img.pixels[p1]);
          float b1 = blue(img.pixels[p1]);
          float a1 = brightness(img.pixels[p1]);
          
          float max1 = r1;
          if(g1>max1)max1 = g1;
          if(b1>max1)max1 = b1;
          //if(a1>max1)max1 = a1;
          
          float d1 = abs(max-max1);
          //println(d1,d2,d3);
          if(d1>t){
            k = true;
            break;
          }
        }
    }}
    return k;
  };
  
};
