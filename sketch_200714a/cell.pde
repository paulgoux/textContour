class cell {
  float x, y, h, res, w, ry, rows_, cols_,avmax,ahmax,cutoff,mean,variance,theta1,theta2,theta3,mag,colmax,fGradient,bGradient;
  int id, xpos, ypos, walls, counter, cols, rows,minr,maxr,pixelThresh = 20000,pixelThresh1,Mode,
      minwr,maxwr,ucount,dcount,lcount,rcount,bcount,fcount,myMax,vmax,myMax1,avmax1,hmax,edgeD = -1,counted,edgeId = -1,wallType;
  boolean visited, wall, link, edge, border, v1, v2, v3, v4,complete,update,max;
  ArrayList <cell> cells;
  ArrayList <cell> cellso;
  ArrayList< ArrayList<cell>> cells2D = new ArrayList<ArrayList<cell>>();
  ArrayList <cell> neighbours = new ArrayList<cell>();
  ArrayList <cell> neighbours2 = new ArrayList<cell>();
  ArrayList <cell> contours = new ArrayList<cell>();
  ArrayList <cell> contours2 = new ArrayList<cell>();
  ArrayList <cell> contoursB = new ArrayList<cell>();
  
  ArrayList <ArrayList <cell>> edges = new ArrayList<ArrayList<cell>>();
  ArrayList <cell> unsortedEdges = new ArrayList<cell>();
  ArrayList <cell> sortedEdges = new ArrayList<cell>();
  ArrayList<ArrayList<cell>> superPixels = new ArrayList<ArrayList<cell>>();
  color col = color(random(255), random(255), random(255));
  cell parent;
  PImage img,backup,canny,cannyE;
  PImage pImage;
  
  cell(){
    
  };

  cell(int a, int b) {
    //this.img = img; 
    cols = a;
    rows = b;
    rows_ = float(b);
    cells = new ArrayList<cell>();
    w = img.width;
    h = img.height;
    res = img.width/cols;
    ry = img.height/100.0;
    counter = rows * cols -1;
    backup = new PImage(cols,rows,RGB);
    float n = map(cutoff, 0, 100, 0, 255);
    
    backup.loadPixels();
    for (int i=0; i<cols; i++) {
      for (int j=0; j<rows; j++) {
        int p = j + i * cols;
        float h = floor(random(100));
        cell c = new cell(p, res*i, ry*j, i, j, h, this);
        if (h<cutoff)c.wall = true;
        else c.wall = false;
        cells.add(c);
        //backup[p] = color(
      }
    }
    backup.updatePixels();
  };
  
  cell(PImage img) {
    this.img = img; 
    cols = img.width;
    rows = img.height;
    //cols = img.width;
    //rows = img.height;
    rows_ = float(rows);
    cols_ = float(cols);
    cells = new ArrayList<cell>();
    w = width;
    h = height;
    res = img.width/cols;
    //res = 1;
    ry = img.height/rows;
    //ry = 1;
    counter = rows * cols -1;
    backup = new PImage(cols,rows,RGB);
    float n = map(cutoff, 0, 100, 0, 255);
    
    backup.loadPixels();
    for (int j=0; j<rows; j++) {
      for (int i=0; i<cols; i++) {
        int p = int(i + j * img.width);
          if (p<img.pixels.length) {
            float r = red(img.pixels[p]);
            float g = green(img.pixels[p]);
            float bb = blue(img.pixels[p]);
            float br = brightness(img.pixels[p]);
            float h = (red(img.pixels[p]) + green(img.pixels[p]) + blue(img.pixels[p]) + brightness(img.pixels[p]))/4;
            //println(r);
            cell c = new cell(i+j*cols, img.width/cols*i, img.height/rows*j, i, j, h, this);
            if (g<cutoff){
              c.col = color(0);
              c.wall = true;
              contours.add(c);
            }
            else {
              c.col = color(255);
              c.wall = false;
              
            }
            cells.add(c);
            backup.pixels[p] = color(h);
        }
      }
    }
    
  };
  
  cell(String loc) {
    
    this.img = loadImage(loc);
    //this.backup = loadImage(loc);
    if(img!=null){
      canny = new PImage(img.width,img.height,ARGB);
      cols = img.width;
      rows = img.height;
      //cols = img.width;
      //rows = img.height;
      rows_ = float(rows);
      cols_ = float(cols);
      cells = new ArrayList<cell>();
      w = width;
      h = height;
      res = img.width/cols;
      //res = 1;
      ry = img.height/rows;
      //ry = 1;
      counter = rows * cols -1;
      backup = new PImage(cols,rows,RGB);
      float n = map(cutoff, 0, 100, 0, 255);
      
      backup.loadPixels();
      canny.loadPixels();
      for (int j=0; j<rows; j++) {
        for (int i=0; i<cols; i++) {
          int p = int(i + j * img.width);
            if (p<img.pixels.length) {
              float max = 0;
              float r = red(img.pixels[p]);
              float g = green(img.pixels[p]);
              float bb = blue(img.pixels[p]);
              float br = brightness(img.pixels[p]);
              float h = (red(img.pixels[p]) + green(img.pixels[p]) + blue(img.pixels[p]) + brightness(img.pixels[p]))/4;
              float h1 = (r+g+bb)/3;
              if(max<r)max = r;
              if(max<g)max = g;
              if(max<bb)max = bb;
              //println(r);
              cell c = new cell(i+j*cols, img.width/cols*i, img.height/rows*j, i, j, h, this);
              //if(g<cutoff||r<cutoff||bb<cutoff){
              //if(g>cutoff||r>cutoff||bb>cutoff||br>cutoff){
              //if((abs(r-g)<cutoff||abs(r-bb)<cutoff||abs(g-bb)<cutoff)){
              if((abs(r-g)>cutoff||abs(r-bb)>cutoff||abs(g-bb)>cutoff)){
              //if(br>cutoff){
              //if (r<cutoff){
              //if(h1<cutoff){
              //if (r<max&&r>min){
              //if (h1<max&&h1>min){
                c.col = color(0);
                c.wall = true;
                c.parent = this;
                contours.add(c);
                contoursB.add(c);
                //backup.pixels[p] = color(0);
              }
              else {
                c.col = color(255);
                c.wall = false;
                backup.pixels[p] = color(255);
              }
              //c.col = color(255);
              //println(c.wall);
              cells.add(c);
              //img.pixels[p] = color(0,1);
              //backup.pixels[p] = color(h);
              canny.pixels[p] = color(255);
          }
        }
      }
      backup.updatePixels();
      canny.updatePixels();
    }else{
      println("check location");
    }
    
    
  };


  cell(int id, float x, float y, int xpos, int ypos, float h, cell c) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.h = h;
    this.xpos = xpos;
    this.ypos = ypos;
    res = c.res;
    ry = c.ry;
    cols = c.cols;
    rows = c.rows;
    //for(int i=0;i<4;i++){
    //  wallFlags.add(true);
    //}
    //vertices[0] = null;
    //vertices[1] = new PVector(x,y+ry/2,x+res/2,y+ry);
    //vertices[2] = new PVector(x+res/2,y,x+res/2,y);
    //vertices[3] = new PVector(x,y+ry/2,x+res,y+ry/2);
    //vertices[4] = new PVector(x+res/2,y,x+res/2,y+ry/2);
    //vertices[5] = new PVector(x,y+ry/2,x+res/2,y);
    //vertices[6] = new PVector(x+res/2,y,x+res/2,y+ry);
    //vertices[7] = new PVector(x,y+ry/2,x+res/2,y);
    //vertices[8] = new PVector(x,y+ry/2,x+res/2,y);
    //vertices[9] = new PVector(x+res/2,y,x+res/2,y+ry);
    //vertices[10] = new PVector(x+res/2,y+ry/2,x+res/2,y);
    //vertices[11] = new PVector(x+res/2,y,x+res,y+ry/2);
    //vertices[12] = new PVector(x,y+ry/2,x+res,y+ry/2);
    //vertices[13] = new PVector(x+res/2,y,x+res,y+ry/2);
    //vertices[14] = new PVector(x,y+ry/2,x+res/2,y+ry/2);
    //vertices[15] = null;
  };
  
  
  
  void getContour(){
    int kn = pixelThresh;
    boolean k1 = false;
    if(!update&&canny!=null){
      canny.loadPixels();
      println("yes");
    for(int i=0;i<contours.size();i++){
      cell c1 = contours.get(i);
      
        for(int j=(int)c1.x+1;j<(int)c1.x+10000;j++){
          
          if(j+c1.y*img.width>0&&j+c1.y*img.width<img.pixels.length){
            cell c2 = cells.get(int(j+c1.y*img.width));
            //println(abs(red(img.pixels[c2.id])-red(img.pixels[c1.id])),red(img.pixels[c1.id]),red(img.pixels[c2.id]));
            if(!c2.wall||abs(red(img.pixels[c2.id])-red(img.pixels[c1.id]))>kn
                ||abs(green(img.pixels[c2.id])-green(img.pixels[c1.id]))>kn
                ||abs(blue(img.pixels[c2.id])-blue(img.pixels[c1.id]))>kn)break;
            c1.rcount ++;
          }else break;
        }
        
        for(int j=(int)c1.x-1;j>(int)c1.x-10000;j--){
          if(j+c1.y*img.width>0&&j+c1.y*img.width<img.pixels.length){
            cell c2 = cells.get(int(j+c1.y*img.width));
            
            if(!c2.wall||abs(red(img.pixels[c2.id])-red(img.pixels[c1.id]))>kn
                ||abs(green(img.pixels[c2.id])-green(img.pixels[c1.id]))>kn
                ||abs(blue(img.pixels[c2.id])-blue(img.pixels[c1.id]))>kn)break;
            c1.lcount ++;
          }else break;
        }
        
        for(int j=(int)c1.y+1;j<(int)c1.y+10000;j++){
          if(c1.x+j*img.width>0&&c1.x+j*img.width<img.pixels.length){
            cell c2 = cells.get(int(c1.x+j*img.width));
            
            if(!c2.wall||abs(red(img.pixels[c2.id])-red(img.pixels[c1.id]))>kn
                ||abs(green(img.pixels[c2.id])-green(img.pixels[c1.id]))>kn
                ||abs(blue(img.pixels[c2.id])-blue(img.pixels[c1.id]))>kn)break;
            c1.ucount ++;
          }else break;
        }
        
        for(int j=(int)c1.y-1;j>(int)c1.y-10000;j--){
          if(c1.x+j*img.width>0&&c1.x+j*img.width<img.pixels.length){
            cell c2 = cells.get(int(c1.x+j*img.width));
            
            if(!c2.wall||abs(red(img.pixels[c2.id])-red(img.pixels[c1.id]))>kn
                ||abs(green(img.pixels[c2.id])-green(img.pixels[c1.id]))>kn
                ||abs(blue(img.pixels[c2.id])-blue(img.pixels[c1.id]))>kn)break;
            c1.dcount ++;
        }else break;
      }
      c1.myMax = (c1.ucount+c1.lcount+c1.dcount+c1.rcount);
      c1.vmax = abs(c1.ucount-c1.dcount);
      c1.hmax = abs(c1.lcount-c1.rcount);
      c1.avmax = abs(c1.ucount+c1.dcount)/2;
      c1.ahmax = abs(c1.lcount+c1.rcount)/2;
      //println("m",Mode);
      c1.Mode = Mode;
      c1.getNeighbours2(canny,cells);
    }
    
    color col = color(0);
    
    if(Mode!=4)
    for(int j=0;j<contours.size();j++){
        
        cell c1 = contours.get(j);
        int count = 0;
        
        for(int i=0;i<c1.neighbours2.size();i++){
          
          cell c = c1.neighbours2.get(i);
          
          if(c!=c1&&c!=null&&canny.pixels[c.id] == col)count++;
        }
        if(count==0){
          canny.pixels[c1.id] = color(255);
      }
    }
    canny.updatePixels();
    
      update = true;
    }
  };
  
  void imgUpdate(PImage loc) {
    println("Image Mode",Mode);
    this.img = (loc);
    //this.backup = loadImage(loc);
    if(img!=null){
      canny = new PImage(img.width,img.height,ARGB);
      cols = img.width;
      rows = img.height;
      //cols = img.width;
      //rows = img.height;
      rows_ = float(rows);
      cols_ = float(cols);
      cells = new ArrayList<cell>();
      w = width;
      h = height;
      res = img.width/cols;
      //res = 1;
      ry = img.height/rows;
      //ry = 1;
      counter = rows * cols -1;
      backup = new PImage(cols,rows,RGB);
      float n = map(cutoff, 0, 100, 0, 255);
      
      backup.loadPixels();
      canny.loadPixels();
      for (int j=0; j<rows; j++) {
        for (int i=0; i<cols; i++) {
          int p = int(i + j * img.width);
            if (p<img.pixels.length) {
              float max = 0;
              float r = red(img.pixels[p]);
              float g = green(img.pixels[p]);
              float b = blue(img.pixels[p]);
              float a = brightness(img.pixels[p]);
              float h = (red(img.pixels[p]) + green(img.pixels[p]) + blue(img.pixels[p]) + brightness(img.pixels[p]))/4;
              float h1 = (r+g+b)/3;
              if(max<r)max = r;
              if(max<g)max = g;
              if(max<b)max = b;
              //println(r,g,b);
              //println(r);
              cell c = new cell(i+j*cols, img.width/cols*i, img.height/rows*j, i, j, h, this);
              //if(g<cutoff||r<cutoff||bb<cutoff){
              //if(g>cutoff||r>cutoff||bb>cutoff||br>cutoff){
              //if((abs(r-g)>cutoff||abs(r-bb)>cutoff||abs(g-bb)>cutoff)){
              //if((abs(r-g)>cutoff||abs(r-bb)>cutoff||abs(g-bb)>cutoff)||h1<pixelThresh1||(r<pixelThresh1&&g<pixelThresh1&&bb<pixelThresh1)){
              //if((abs(r-g)<cutoff||abs(r-bb)<cutoff||abs(g-bb)<cutoff)){
              if(b<cutoff){
              //if(r<cutoff||g<cutoff||bb<cutoff){
              //if(br>cutoff){
              //if(r>cutoff||g>cutoff||bb>cutoff){
              //if(h1>30&&h1<150){
              //if(r<max&&r>min){
              //if(h1<max&&h1>min){
                c.col = color(0);
                c.wallType = 0;
                c.parent = this;
                contours.add(c);
                contoursB.add(c);
                //backup.pixels[p] = color(0);
              }else if(b>cutoff&&b<cutoff+pixelThresh1){
                c.col = color(255,0,0);
                c.wallType = 1;
                c.parent = this;
                contours2.add(c);
                contoursB.add(c);
                //backup.pixels[p] = color(0);
              }else {
                c.wallType = 2;
                c.col = color(255);
                c.wall = false;
                backup.pixels[p] = color(255);
              }
              //println(c.wallType);
              
              //c.col = color(255);
              //println(c.wall);
              cells.add(c);
              //img.pixels[p] = color(0,1);
              //backup.pixels[p] = color(h);
              canny.pixels[p] = color(255);
          }
        }
      }
      backup.updatePixels();
      canny.updatePixels();
    }else{
      println("check location");
    }
    println("Contours",contours.size());
  };
  
  void imgUpdate(PImage loc,color c1) {
    println("color");
    println("m",Mode);
    this.img = (loc);
    //this.backup = loadImage(loc);
    //if(img!=null){
      canny = new PImage(img.width,img.height,ARGB);
      cols = img.width;
      rows = img.height;
      //cols = img.width;
      //rows = img.height;
      rows_ = float(rows);
      cols_ = float(cols);
      cells = new ArrayList<cell>();
      contours = new ArrayList<cell>();
      w = width;
      h = height;
      res = img.width/cols;
      //res = 1;
      ry = img.height/rows;
      //ry = 1;
      counter = rows * cols -1;
      backup = new PImage(cols,rows,RGB);
      float n = map(cutoff, 0, 100, 0, 255);
      
      backup.loadPixels();
      canny.loadPixels();
      for (int j=0; j<rows; j++) {
        for (int i=0; i<cols; i++) {
          int p = int(i + j * img.width);
            if (p<img.pixels.length) {
              float max = 0;
              float r = red(img.pixels[p]);
              float g = green(img.pixels[p]);
              float b = blue(img.pixels[p]);
              float a = brightness(img.pixels[p]);
              float h = (red(img.pixels[p]) + green(img.pixels[p]) + blue(img.pixels[p]) + brightness(img.pixels[p]))/4;
              float h1 = (r+g+a)/3;
              if(max<r)max = r;
              if(max<g)max = g;
              if(max<a)max = a;
              //println(r);
              cell c = new cell(i+j*cols, img.width/cols*i, img.height/rows*j, i, j, h, this);
              
              float dr = abs(r - red(c1));
              float dg = abs(g - green(c1));
              float db = abs(b - blue(c1));
              float da = abs(a - brightness(c1));
              
              if(dr<cutoff&&dg<cutoff&&db<cutoff&&da<cutoff){
                //println(dr,dg,db,da);
                c.col = color(0);
                c.wall = true;
                c.parent = this;
                contours.add(c);
                contoursB.add(c);
                //backup.pixels[p] = color(0);
              }
              else {
                c.col = color(255);
                c.wall = false;
                backup.pixels[p] = color(255);
              }
              //c.col = color(255);
              //println(c.wall);
              cells.add(c);
              //img.pixels[p] = color(0,1);
              //backup.pixels[p] = color(h);
              canny.pixels[p] = color(255);
          }
        }
      }
      backup.updatePixels();
      canny.updatePixels();
    //}else{
    //  println("check location");
    //}
    println("Contours",contours.size());
  };
  
  
  
  void getNeighbours() {

    for (int k=0; k<cells.size(); k++) {
      cell c = cells.get(k);
      for (int i=c.xpos-1; i<=c.xpos+1; i++) {
        for (int j=c.ypos-1; j<=c.ypos+1; j++) {
          int p = i+j * cols;
          if (j>=0&&j<rows&&i>=0&&i<cols&&p<cells.size()) {
            cell c2 = cells.get(p);
            if (c2!=c) {

              if ((c.xpos==c2.xpos||c.ypos==c2.ypos)) {
                if (!c.neighbours.contains(c2))c.neighbours.add(c2);
              }
              if (!c.neighbours2.contains(c2))c.neighbours2.add(c2);
            }
          } else {
            c.neighbours2.add(null);
            if ((c.xpos==i||c.ypos==j))c.neighbours.add(null);
          }
        }
      }
    }
  };
  
  void getNeighbours2(PImage canny,ArrayList<cell> cells) {
    boolean k = false;
    boolean k1 = false;
    boolean k2 = false;
    boolean k3 = false;
    boolean k4 = false;
    boolean k5 = false;
    //println(0);
    int n = 10;
    
      for (int i=xpos-1; i<=xpos+1; i++) {
        for (int j=ypos-1; j<=ypos+1; j++) {
          int p = i+j * cols;
          if (j>=0&&j<rows&&i>=0&&i<cols&&p<cells.size()) {
            cell c = cells.get(p);
            if (c!=this) {
              if(Mode ==0){
                if(ypos==j){
                  if(c.ahmax==ahmax)k = true;
                  }
                if(xpos==i){
                  if(c.avmax==avmax)k1 = true;
                }
              }
              if(Mode==1){
                if(ypos==j){
                   if(c.hmax==hmax)k1 = true;
                  }
                if(xpos==i){
                  if(c.vmax==vmax)k1 = true;
                }
                
              }
              
              if(Mode ==2){
                if(ypos==j){
                  if(c.lcount<lcount)k2 = true;
                  if(c.rcount>rcount)k3 = true;
                  }
                if(xpos==i){
                  if(c.ucount<ucount)k4 = true;
                  if(c.dcount<dcount)k5 = true;
                }
              }
              if(Mode ==3){
                if(ypos==j){
                  if(c.lcount<lcount)k2 = true;
                  if(c.rcount>rcount)k3 = true;
                  }
                if(xpos==i){
                  if(c.ucount>ucount)k4 = true;
                  if(c.dcount<dcount)k5 = true;
                }
              }
              if(Mode ==4){
                if(ypos==j){
                  if(c.lcount<lcount)k2 = true;
                  if(c.rcount<rcount)k3 = true;
                  }
                if(xpos==i){
                  if(c.ucount<ucount)k4 = true;
                  if(c.dcount<dcount)k5 = true;
                }
              }
              
              if(Mode==5){
                if(ypos==j){
                   if(c.lcount<rcount)k1 = true;
                   if(c.hmax!=hmax)k2 = true;
                  }
                if(xpos==i){
                  if(c.dcount<ucount)k3 = true;
                  if(c.vmax!=vmax)k4 = true;
                }
              }
              
              if(Mode==6){
                if(ypos==j){
                   if(c.lcount<rcount)k1 = true;
                   if(c.ahmax==ahmax)k2 = true;
                  }
                if(xpos==i){
                  if(c.dcount<ucount)k3 = true;
                  if(c.avmax==avmax)k4 = true;
                }
              }
              if ((xpos==c.xpos||ypos==c.ypos)) {
                if (!neighbours.contains(c)){
                  neighbours.add(c);
                }
              }
              if (!update&&!neighbours2.contains(c))neighbours2.add(c);
            }
          } else {
            neighbours2.add(null);
            if ((xpos==i||ypos==j))neighbours.add(null);
          }
        }
      }
      
      if(Mode==0&&(!k||!k1)){
        canny.pixels[id] = color(0);
        parent.unsortedEdges.add(this);
      }
      if(Mode==1&&((k1))){
        canny.pixels[id] = color(0);
        parent.unsortedEdges.add(this);
      }
      if(Mode==2&&((!k2||!k3)||(!k4||!k5))){
        canny.pixels[id] = color(0);
        parent.unsortedEdges.add(this);
      }
      if(Mode==3&&((!k2||!k3)||(!k4||!k5))){
        canny.pixels[id] = color(0);
        parent.unsortedEdges.add(this);
      }
      if(Mode==4&&((!k2||!k3)||(!k4||!k5))){
        canny.pixels[id] = color(0);
        parent.unsortedEdges.add(this);
      }
      if(Mode==5&&((!k1||!k2)||((!k3||!k4)))){
        canny.pixels[id] = color(0);
        parent.unsortedEdges.add(this);
      }
      if(Mode==6&&((!k1&&k2)||(!k3&&k4))){
        canny.pixels[id] = color(0);
        parent.unsortedEdges.add(this);
      }
  };
  
  

  boolean pos(){
    return mouseX>x&&mouseX<x+res&&mouseY>y&&mouseY<y+ry;
  };

  void debug() {
    noStroke();
    
    fill(0);
    //text(neighbours.size(),x,y+ry/2);
    
    if (mouseX>=x&&mouseX<x+2&&mouseY>=y&&mouseY<y+2) {
      fill(0,0,255);
      rect(x,y,res,ry);
      for (int i=0; i<neighbours2.size(); i++) {
        cell c = neighbours2.get(i);
        fill(255, 0, 0, 100);
        if (c!=null) {
          fill(255, 0, 0);
          rect(c.x, c.y, res, ry);
        }
      }
    }
  };
  
  void set(PImage img){
    
  };
  
  void reset(){
    
  };
  
  
  
};
