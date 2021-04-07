import 'package:goals_app/database/model/data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const String TABLE_DATA = "data";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'dataDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating data table");

        await database.execute(
          "CREATE TABLE $TABLE_DATA ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_NAME TEXT"

          ")",
        );
      },
    );
  }

  Future<List<Data>> getDatas() async {
    final db = await database;

    var datas = await db
        .query(TABLE_DATA, columns: [COLUMN_ID, COLUMN_NAME]);

    List<Data> dataList = List<Data>();

    datas.forEach((currentData) {
      Data data = Data.fromMap(currentData);

      dataList.add(data);
    });

    return dataList;
  }

  Future<Data> insert(Data data) async {
    final db = await database;
    data.id = await db.insert(TABLE_DATA, data.toMap());
    return data;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_DATA,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Data data) async {
    final db = await database;

    return await db.update(
      TABLE_DATA,
      data.toMap(),
      where: "id = ?",
      whereArgs: [data.id],
    );
  }

}
