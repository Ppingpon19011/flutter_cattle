
import 'package:csv/csv.dart';

import '../model/catTime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:moor2csv/moor2csv.dart';

class CatTimeHelper {
//  ************************** Create table **************************
  static Database? _db;
  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'catTime.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE cattime(id INTEGER PRIMARY KEY, idPro INTEGER,weight REAL,bodyLenght REAL,heartGirth REAL,hearLenghtSide REAL,hearLenghtRear REAL,hearLenghtTop REAL,pixelReference REAL,distanceReference REAL,imageSide TEXT, imageRear TEXT, imageTop TEXT,date TEXT,note TEXT)",
    );
  }

//  ************************** Create table **************************

//  ************************** Insert **************************

  Future<CatTimeModel> insert(CatTimeModel catTimeModel) async {
    var dbClient = await db;
    await dbClient!.insert('cattime', catTimeModel.toMap());
    return catTimeModel;
  }

//  ************************** Insert **************************

//  ************************** Query **************************

  Future<List<CatTimeModel>> getAllCatTimeList() async {
    var dbClient = await db;

    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('cattime', orderBy: "date DESC");
    return queryResult.map((e) => CatTimeModel.fromMap(e)).toList();
  }

  Future<List<CatTimeModel>> getCatTimeListWithCatProID(int idPro) async {
    var dbClient = await db;

    final List<Map<String, Object?>> queryResult = await dbClient!.query(
        'cattime',
        columns: CatTimeFields.values,
        where: 'idPro = ?',
        whereArgs: [idPro],
        orderBy: "date DESC");
    return queryResult.map((e) => CatTimeModel.fromMap(e)).toList();
  }

  Future<CatTimeModel> getCatTimeWithCatTimeID(int idTime) async {
    var dbClient = await db;

    final queryResult = await dbClient!.query(
      'cattime',
      columns: CatTimeFields.values,
      where: 'id = ?',
      whereArgs: [idTime],
    );

    if (queryResult.isNotEmpty) {
      return CatTimeModel.fromJson(queryResult.first);
    } else {
      throw Exception('ID $idTime not found');
    }
  }

  Future<CatTimeModel> getCatTimeWithCatPro(int idPro) async {
    var dbClient = await db;

    final queryResult = await dbClient!.query('cattime',
        columns: CatTimeFields.values,
        where: 'idPro = ?',
        whereArgs: [idPro],
        orderBy: "date DESC");

    if (queryResult.isNotEmpty) {
      return CatTimeModel.fromJson(queryResult.first);
    } else {
      throw Exception('ID $idPro not found');
    }
  }

//  ************************** Query **************************

//  ************************** Update **************************

  Future<int> updateCatTime(CatTimeModel catTimeModel) async {
    var dbClient = await db;
    return await dbClient!.update(
      'cattime',
      catTimeModel.toMap(),
      where: 'id = ?',
      whereArgs: [catTimeModel.id],
    );
  }

//  ************************** Update **************************

//  ************************** Delete **************************

  Future deleteTableContent() async {
    var dbClient = await db;
    return await dbClient!.delete(
      'cattime',
    );
  }

  Future<int> deleteCatTime(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'cattime',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCatTimeWithIdPro(int idPro) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'cattime',
      where: 'idPro = ?',
      whereArgs: [idPro],
    );
  }

//  ************************** Delete **************************
  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }
}
