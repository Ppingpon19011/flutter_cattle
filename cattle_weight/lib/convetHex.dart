class ConvertHex{

   int hexColor(String hexCode) {
    String newColor = '0xff' + hexCode;
    newColor = newColor.replaceAll('#', '');
    int colorCode = int.parse(newColor);
    return colorCode;
  }
  
  int Blue(){
    int colorCode = int.parse('0xff47B5BE');
    return colorCode;
  }

}