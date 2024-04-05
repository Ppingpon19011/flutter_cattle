class CatTimeFields {
  static final List<String> values = [
    /// Add all fields
    id,
    idPro,
    weight,
    bodyLenght,
    heartGirth,
    hearLenghtSide,
    hearLenghtRear,
    hearLenghtTop,
    pixelReference,
    distanceReference,
    imageSide,
    imageRear,
    imageTop,
    date,
    note,
  ];
  static final String id = 'id';
  static final String idPro = 'idPro';
  static final String weight = 'weight';
  static final String bodyLenght = 'bodyLenght';
  static final String heartGirth = 'heartGirth';
  static final String hearLenghtSide = 'hearLenghtSide';
  static final String hearLenghtRear = 'hearLenghtRear';
  static final String hearLenghtTop = 'hearLenghtTop';
  static final String pixelReference = 'pixelReference';
  static final String distanceReference = 'distanceReference';
  static final String imageSide = 'imageSide';
  static final String imageRear = 'imageRear';
  static final String imageTop = 'imageTop';
  static final String date = 'date';
  static final String note = 'note';
}

class CatTimeModel {
  final int? id;
  final int idPro;
  final double weight;
  final double bodyLenght;
  final double heartGirth;
  final double hearLenghtSide;
  final double hearLenghtRear;
  final double hearLenghtTop;
  final double pixelReference;
  final double distanceReference;
  final String imageSide;
  final String imageRear;
  final String imageTop;
  final String date;
  final String note;

  CatTimeModel({
    this.id,
    required this.idPro,
    required this.weight,
    required this.bodyLenght,
    required this.heartGirth,
    required this.hearLenghtSide,
    required this.hearLenghtRear,
    required this.hearLenghtTop,
    required this.pixelReference,
    required this.distanceReference,
    required this.imageSide,
    required this.imageRear,
    required this.imageTop,
    required this.date,
    required this.note,
  });

  CatTimeModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        idPro = res["idPro"],
        weight = res["weight"],
        bodyLenght = res["bodyLenght"],
        heartGirth = res["heartGirth"],
        hearLenghtSide = res["hearLenghtSide"],
        hearLenghtRear = res["hearLenghtRear"],
        hearLenghtTop = res["hearLenghtTop"],
        pixelReference = res["pixelReference"],
        distanceReference = res["distanceReference"],
        imageSide = res["imageSide"],
        imageRear = res["imageRear"],
        imageTop = res["imageTop"],
        date = res["date"],
        note = res["note"];

  static CatTimeModel fromJson(Map<String, Object?> json) => CatTimeModel(
        id: json[CatTimeFields.id] as int?,
        idPro: json[CatTimeFields.idPro] as int,
        weight: json[CatTimeFields.weight] as double,
        bodyLenght: json[CatTimeFields.bodyLenght] as double,
        heartGirth: json[CatTimeFields.heartGirth] as double,
        hearLenghtSide: json[CatTimeFields.hearLenghtSide] as double,
        hearLenghtRear: json[CatTimeFields.hearLenghtRear] as double,
        hearLenghtTop: json[CatTimeFields.hearLenghtTop] as double,
        pixelReference: json[CatTimeFields.pixelReference] as double,
        distanceReference: json[CatTimeFields.distanceReference] as double,
        imageSide: json[CatTimeFields.imageSide] as String,
        imageRear: json[CatTimeFields.imageRear] as String,
        imageTop: json[CatTimeFields.imageTop] as String,
        date: json[CatTimeFields.date] as String,
        note: json[CatTimeFields.note] as String,
      );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'idPro': idPro,
      'weight': weight,
      'bodyLenght': bodyLenght,
      'heartGirth': heartGirth,
      'hearLenghtSide': hearLenghtSide,
      'hearLenghtRear': hearLenghtRear,
      'hearLenghtTop': hearLenghtTop,
      'pixelReference': pixelReference,
      'distanceReference': distanceReference,
      'imageSide': imageSide,
      'imageRear': imageRear,
      'imageTop': imageTop,
      'date': date,
      'note': note,
    };
  }
}
