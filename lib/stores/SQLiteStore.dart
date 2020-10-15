import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saber/domain/models/call_history_model.dart';
import 'package:sqflite/sqflite.dart';


class SQLiteStore with ChangeNotifier{
  static SQLiteStore INSTANCE;
  static String DB_PATH = "";
  static Database db;

  // Method for accessing Singleton SQLite Store
  // Initiates Hive one-time and generates global userBox
  init() async {
    var dir = await getApplicationDocumentsDirectory();
    DB_PATH = dir.path+"/saber_db";
    if (dir != null) {
      print("DIR path: $DB_PATH");
      db = await openDatabase('$DB_PATH');
      return this;
    }
    return INSTANCE;
  }
}