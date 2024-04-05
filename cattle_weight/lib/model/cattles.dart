
class CattleTime {
  final int? id;
  final int CPid;
  final double bodyLenght;
  final double heartGirth;
  final double hearLenghtSide;
  final double hearLenghtRear;
  final double hearLenghtTop;
  final double PixelReference;
  final double DistanceReference;
  DateTime date;

  CattleTime(
      {this.id,
      required this.CPid,
      required this.bodyLenght,
      required this.heartGirth,
      required this.hearLenghtSide,
      required this.hearLenghtRear,
      required this.hearLenghtTop,
      required this.PixelReference,
      required this.DistanceReference,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': (id == 0) ? null : id,
      'CPid': CPid,
      'bodyLenght': bodyLenght,
      'heartGirth': heartGirth,
      'hearLenghtSide': hearLenghtSide,
      'hearLenghtRear': hearLenghtRear,
      'hearLenghtTop': hearLenghtTop,
      'PixelReference': PixelReference,
      'DistanceReference': DistanceReference,
      'date': date,
    };
  }
}
