class ImageFields {
  static final List<String> values = [
    /// Add all fields
    id, idPro, idTime, imagePath
  ];

  static final String id = 'id';
  static final String idPro = 'idPro';
  static final String idTime = 'idTime';
  static final String imagePath = 'imagePath';
}

class ImageModel {
  int? id;
  int idPro;
  int idTime;
  String imagePath;

  ImageModel({
    this.id,
    required this.idPro,
    required this.idTime,
    required this.imagePath,
  });

  ImageModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        idPro = res["idPro"],
        idTime = res["idTime"],
        imagePath = res["imagePath"];

  static ImageModel fromJson(Map<String, Object?> json) => ImageModel(
        id: json[ImageFields.id] as int?,
        idPro: json[ImageFields.idPro] as int,
        idTime: json[ImageFields.idTime] as int,
        imagePath: json[ImageFields.imagePath] as String,
      );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'idPro': idPro,
      'idTime': idTime,
      'imagePath': imagePath,
    };
  }
}
