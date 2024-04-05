class CattleDB {
  late String cattleNumber;
  late String cattleName;
  late String gender;
  late String specise;
  late double heartGirth;
  late double bodyLenght;
  late double weight;
  late String img;

  CattleDB(this.cattleNumber,this.cattleName,this.gender,this.specise,this.img,this.heartGirth,this.bodyLenght,this.weight);

  void cattleSetter(
      String cattleNumber,
      String cattleName,
      String gender,
      String specise,
      String img,
      double heartGirth,
      double bodyLenght,
      double weight) {
    this.cattleNumber = cattleNumber;
    this.cattleName = cattleName;
    this.gender = gender;
    this.specise = specise;
    this.heartGirth = heartGirth;
    this.bodyLenght = bodyLenght;
    this.weight = weight;
    this.img = img;
  }

  // Getter
  String getCattleNumber() {
    return this.cattleNumber;
  }

  String getCattleName() {
    return this.cattleName;
  }

  String getGender() {
    return this.gender;
  }

  String getSpecise() {
    return this.specise;
  }

  String getImg() {
    return this.img;
  }

  double getHeartGirth() {
    return this.heartGirth;
  }

  double getBodyLenght() {
    return this.bodyLenght;
  }

  double getWeight() {
    return this.weight;
  }

  // Setter
  void setCattlenumber(String cattleNumber) {
    this.cattleNumber = cattleNumber;
  }

  void setCattleName(String cattleName) {
    this.cattleName = cattleName;
  }

  void setGender(String gender) {
    this.gender = gender;
  }

  void setSpecies(String species) {
    this.specise = species;
  }

  void setHeartGirth(double heartgirth) {
    this.heartGirth = heartgirth;
  }

  void setBodyLenght(double bodyLenght) {
    this.bodyLenght = bodyLenght;
  }

  void setWeight(double weight) {
    this.weight = weight;
  }

  void setImg(String img) {
    this.img = img;
  }

  void showdata() {
    print("CattleDB");
    print("Cattle number : $cattleNumber");
    print("Cattle name : $cattleName");
    print("Gender : $gender");
    print("Specise : $specise");
    print("Heart girth : $heartGirth");
    print("Body Lenght : $bodyLenght");
    print("Weight : $weight");
    print("Image : $img");
  }
}
