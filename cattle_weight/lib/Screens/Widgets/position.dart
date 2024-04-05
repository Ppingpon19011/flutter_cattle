class Positions{
   double _x1 = 0;
  //  int x2=0;
   double _y1 = 0;
  //  int y2=0;
  late double _pixelDistance;
  
  void setX1(double x){
   this._x1=x;
  }

  void setY1(double y){
   this._y1=y;
  }

  double getX1(){
    return this._x1;
  }

  double getY1(){
    return this._y1;
  }

  void setPixelDistance(double pixelDistance){
   this._pixelDistance = pixelDistance;
  }

  double getPixelDistance(){
    return this._pixelDistance;
  }
}