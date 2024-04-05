import 'dart:math';

class CattleCalculation {
  double InToCm = 0.39370;
  double LbToKg = 0.45359;
  double weightErr = 0.2556965733;
  double hg_Err = 0.1137;
  double bl_Err = 0.2197;

  double pixelDistance(double x1, double y1, double x2, double y2) {
    return sqrt(((x2 - x1) * (x2 - x1)) + ((y2 - y1) * (y2 - y1)));
  }

  double distance(
      double pixelReference, double distanceReference, double pixel) {
    return (pixel * distanceReference) / pixelReference;
  }

  double calWeight(double bodyLenght, double heartGirth) {
    double calcucate = ((((heartGirth * InToCm) *
                (heartGirth * InToCm) *
                ((bodyLenght + (bodyLenght * bl_Err)) * InToCm))) /
            300) *
        LbToKg;
    return calcucate + (calcucate * weightErr);
  }

  double calHeartGirth(double horizontal, double vertical) {
    double calcucate = (pi * (horizontal + vertical)) / 2;
    return calcucate + (calcucate * hg_Err);
  }
}
