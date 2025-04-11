import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:start_invest/models/startup_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  static const String _dbName = 'startups.db';
  static const String _tableName = 'startups';
  static const int _dbVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);

    // Check if the database exists
    bool dbExists = await databaseExists(path);

    Database db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );

    // Populate with initial data only if the DB was just created
    if (!dbExists) {
      await _populateInitialData(db);
    }

    return db;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        tagline TEXT,
        description TEXT,
        sector TEXT,
        funding TEXT,
        location TEXT,
        date TEXT,
        website TEXT,
        fundingGoal INTEGER,
        founders TEXT -- Storing JSON string
      )
      ''');
  }

  Future<void> _populateInitialData(Database db) async {
    final String response = await rootBundle.loadString(
      'assets/startup_data.json',
    );
    final List<dynamic> data = json.decode(response);

    Batch batch = db.batch();
    for (var startupJson in data) {
      Startup startup = Startup.fromJson(
        startupJson,
      ); // Use fromJson to parse asset data
      // Convert Startup object to map for database insertion (excluding id)
      Map<String, dynamic> startupMap = startup.toMap();
      startupMap.remove('id'); // Remove id as it's autoincremented
      batch.insert(
        _tableName,
        startupMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // Method to get all startups
  Future<List<Startup>> getAllStartups() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    // Convert the List<Map<String, dynamic>> into a List<Startup>.
    return List.generate(maps.length, (i) {
      return Startup.fromMap(maps[i]); // Use fromMap for database data
    });
  }

  // Add other CRUD methods here if needed (e.g., insert, update, delete)
}
