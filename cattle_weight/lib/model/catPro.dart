class CatProFields {
  static final List<String> values = [
    /// Add all fields
    id, name, gender, species
  ];

  static final String id = 'id';
  static final String name = 'name';
  static final String gender = 'gender';
  static final String species = 'species';
}

class CatProModel {
  final int? id;
  final String name;
  final String gender;
  final String species;

  CatProModel({
    this.id,
    required this.name,
    required this.gender,
    required this.species,
  });

  CatProModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        gender = res["gender"],
        species = res["species"];

  static CatProModel fromJson(Map<String, Object?> json) => CatProModel(
        id: json[CatProFields.id] as int?,
        name: json[CatProFields.name] as String,
        gender: json[CatProFields.gender] as String,
        species: json[CatProFields.species] as String,
      );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'species': species,
    };
  }
}
