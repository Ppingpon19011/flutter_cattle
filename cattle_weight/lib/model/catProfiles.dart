
class CattlePro{
  final int? id;
  final String name;
  final bool gender;
  final String species;

  CattlePro({this.id,required this.name,required this.gender,required this.species});

  Map<String,dynamic> toMap(){
    return {'id':(id == 0)? null:id,
    'name':name, 
    'gender':gender, 
    'species':species,
    };
  }
}