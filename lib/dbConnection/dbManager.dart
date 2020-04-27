import 'dart:io' as io;
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {
  static final DBManager _instance = new DBManager.internal();
  factory DBManager() => _instance;
  DBManager.internal();

  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await openDB();
    }
    return _database;
  }

  Future<Database> openDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "Word_Master3000_Dictionary.db");
    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data =
          await rootBundle.load("assets/Word_Master3000_Dictionary.db");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    var db = await openDatabase(path);
    print("data base is connected");
    return db;
    //await db.close();
  }

  Future<List<Map>> getWords(String item) async {
    final Database db = await this.database;

    print("fetching word $item");
    List<Map> maps =
        await db.rawQuery("SELECT * FROM word WHERE word = '$item'");

    return maps;
  }

  Future<List<String>> getListOfAllWords() async {
    List<String> list = new List();
    final Database db = await this.database;
    List<Map> maps = await db.rawQuery("SELECT * FROM word");

    for (Map map in maps) list.add(map['word']);

    return list;
  }

  Future<List<Map>> getMeaning(int id) async {
    final Database db = await this.database;
    List<Map> maps = await db.rawQuery("SELECT * FROM Meaning WHERE id = $id");
    return maps;
  }

  Future<List<Map>> getExample(int meaningid) async {
    final Database db = await this.database;
    List<Map> maps = await db
        .rawQuery("SELECT * FROM Example WHERE meaning_id = $meaningid");
    return maps;
  }

  Future<List<Map>> getSynonyms(int id) async {
    final Database db = await this.database;
    List<Map> maps = await db.rawQuery("SELECT * FROM Synonyms WHERE id = $id");
    return maps;
  }

  Future<List<Map>> getMoreExample(int id) async {
    final Database db = await this.database;
    List<Map> maps =
        await db.rawQuery("SELECT * FROM MoreExample WHERE id = $id");
    return maps;
  }

  Future<List<Map>> getidioms(String item) async {
    final Database db = await this.database;
    List<Map> maps =
        await db.rawQuery("SELECT * FROM idioms WHERE word = '$item'");
    return maps;
  }

  Future<List<Map>> getphrases(String item) async {
    final Database db = await this.database;
    List<Map> maps =
        await db.rawQuery("SELECT * FROM phrases WHERE word = '$item'");
    return maps;
  }
}
