
import '../model/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class CatImageHelper {
//  ************************** Create table **************************
  static Database? _db;
  static const String ID = 'id';
  static const String IDPRO = 'idPro';
  static const String IDTIME = 'idTime';
  static const String PATH = 'imagePath';
  static const String TABLE = 'imagesTable';
  static const String DB_NAME = 'images.db';

  Future<Database> get db async {
    if (null != _db) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY AUTOINCREMENT,$IDPRO INTEGER,$IDTIME INTEGER, $PATH TEXT)");
  }

//  ************************** Create table **************************


//  ************************** Insert **************************
  Future<ImageModel> save(ImageModel employee) async {
    var dbClient = await db;
    employee.id = await dbClient.insert(TABLE, employee.toMap());
    return employee;
  }

//  ************************** Insert **************************

//  ************************** Query **************************

  Future<List<ImageModel>> getAllPhotos() async {
    var dbClient = await db;
    List<Map<String, Object?>> maps = await dbClient.query(TABLE, columns: ImageFields.values);
    List<ImageModel> employees = [];

    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        
        employees.add(ImageModel.fromMap(maps[i]));
      }
    }
    return employees;
  }

    Future<List<ImageModel>> getCatTimePhotos(int idTime) async {
    var dbClient = await db;
    List<Map<String, Object?>> maps = await dbClient.query(TABLE, columns: ImageFields.values,where: 'idTime = ?',whereArgs : [idTime]);
    List<ImageModel> employees = [];

    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        
        employees.add(ImageModel.fromMap(maps[i]));
      }
    }
    return employees;
  }

  
    Future<ImageModel> getImageWithPath(String path) async {
    var dbClient = await db;

    final queryResult = await dbClient.query(
      '$TABLE',
      columns: ImageFields.values,
      where: 'imagePath = ?',
      whereArgs: [path],
    );
    
    if (queryResult.isNotEmpty) {
      return ImageModel.fromJson(queryResult.first);
    } else {
      throw Exception('Path $path not found');
    }
  }

//  ************************** Query **************************

//  ************************** Update **************************

  Future<int> updateImage(ImageModel image) async {
    var dbClient = await db;
    return await dbClient.update(
      TABLE,
      image.toMap(),
      where: 'id = ?',
      whereArgs: [image.id],
    );
  }

//  ************************** Update **************************

//  ************************** Delete **************************
   Future<int> delete(ImageModel employee) async {
    var dbClient = await db;
    int result = await dbClient.delete('$TABLE',where: "id = ?", whereArgs: [employee.id]);
    return result;
  }

     Future<int> deleteWithIDPro(int idPro) async {
    var dbClient = await db;
    int result = await dbClient.delete('$TABLE',where: "idPro = ?", whereArgs: [idPro]);
    return result;
  }
     Future<int> deleteWithIDTime(int idTime) async {
    var dbClient = await db;
    int result = await dbClient.delete('$TABLE',where: "idTime = ?", whereArgs: [idTime]);
    return result;
  }


//  ************************** Delete **************************

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}