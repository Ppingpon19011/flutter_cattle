import '../model/catPro.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class CatProHelper {
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
    String path = join(documentDirectory.path, 'catPro.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE catpro (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,gender TEXT NOT NULL, species TEXT NOT NULL)",
    );
  }

//  ************************** Create table **************************

//  ************************** Insert **************************

  Future<CatProModel> insert(CatProModel catProModel) async {
    var dbClient = await db;
    await dbClient!.insert('catpro', catProModel.toMap());
    return catProModel;
  }

//  ************************** Insert **************************

//  ************************** Query **************************

  Future<List<CatProModel>> getCatProList() async {
    var dbClient = await db;

    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('catpro');
    return queryResult.map((e) => CatProModel.fromMap(e)).toList();
  }

  Future getCatPro(int id) async {
    var dbClient = await db;

    final queryResult = await dbClient!.query('catpro',
        columns: ['id', 'name', 'gender', 'species'],
        where: "id = ?",
        whereArgs: [id],
        orderBy: "name DESC");
    return queryResult;
  }

  Future<CatProModel> getCatProWithID(int id) async {
    var dbClient = await db;

    final queryResult = await dbClient!.query(
      'catpro',
      columns: CatProFields.values,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (queryResult.isNotEmpty) {
      return CatProModel.fromJson(queryResult.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

//  ************************** Query **************************

//  ************************** Update **************************

  Future<int> updateCatPro(CatProModel catProModel) async {
    var dbClient = await db;
    return await dbClient!.update(
      'catpro',
      catProModel.toMap(),
      where: 'id = ?',
      whereArgs: [catProModel.id],
    );
  }

//  ************************** Update **************************

//  ************************** Delete **************************

  Future deleteTableContent() async {
    var dbClient = await db;
    return await dbClient!.delete(
      'catpro',
    );
  }

  Future<int> deleteCatPro(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'catpro',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

//  ************************** Delete **************************

  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }
}
