import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/catProfiles.dart';
import '../model/cattles.dart';
import 'dart:io' as io;

class DbHelper {
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) {
        database.execute(
            'CREATE TABLE catPro(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, gender BOOLEAN,species TEXT)');
        database.execute(
            'CREATE TABLE catTime(id INTEGER PRIMARY KEY AUTOINCREMENT, CPid INTEGER,bodyLenght DOUBLE,heartGirth DOUBLE,hearLenghtSide DOUBLE,hearLenghtRear DOUBLE,hearLenghtTop DOUBLE,PixelReference DOUBLE,DistanceReference DOUBLE,date DATETIME)' +
                'FOREIGN KEY(CPid) REFERENCES catPro(id))');
      },
    );
    return db;
  }

  Future<CattlePro> insertCatPro(CattlePro catPro) async {
    var dbClient = await db;
    dbClient!.insert(
      'catPro',
      catPro.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return catPro;
  }

  Future<CattleTime> insertCatTime(CattleTime catTime) async {
    var dbClient = await db;
    dbClient!.insert(
      'catTime',
      catTime.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return catTime;
  }

  Future<List<CattlePro>> getListCattlePro() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> queryResult =
        await dbClient!.query('catPro');
    return List.generate(queryResult.length, (index) {
      return CattlePro(
        id: queryResult[index]['id'],
        name: queryResult[index]['name'],
        gender: queryResult[index]['gender'],
        species: queryResult[index]['species'],
      );
    });
  }

  Future<List<CattleTime>> getListCattleTime() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> queryResult =
        await dbClient!.query('catTime');
    return List.generate(queryResult.length, (index) {
      return CattleTime(
          id: queryResult[index]['id'],
          CPid: queryResult[index]['CPid'],
          bodyLenght: queryResult[index]['bodyLenght'],
          heartGirth: queryResult[index]['heartGirth'],
          hearLenghtSide: queryResult[index]['hearLenghtSide'],
          hearLenghtRear: queryResult[index]['hearLenghtRear'],
          hearLenghtTop: queryResult[index]['hearLenghtTop'],
          PixelReference: queryResult[index]['PixelReference'],
          DistanceReference: queryResult[index]['DistanceReference'],
          date: queryResult[index]['date']);
    });
  }
}
