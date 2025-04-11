import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:start_invest/models/startup_model.dart';
import 'package:start_invest/models/investor_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  static const String _dbName = 'app_data.db';
  static const String _startupTableName = 'startups';
  static const String _investorTableName = 'investors';
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
      CREATE TABLE $_startupTableName (
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

    await db.execute('''
       CREATE TABLE $_investorTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT,
        location TEXT,
        tagline TEXT,
        minInvestment INTEGER,
        maxInvestment INTEGER,
        bio TEXT,
        investmentFocus TEXT, -- Storing JSON string
        pastInvestments TEXT, -- Storing JSON string
        activeSince TEXT
       )
      ''');
  }

  Future<void> _populateInitialData(Database db) async {
    await _populateStartupData(db);
    await _populateInvestorData(db);
  }

  Future<void> _populateStartupData(Database db) async {
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
        _startupTableName,
        startupMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> _populateInvestorData(Database db) async {
    final String response = await rootBundle.loadString(
      'assets/investor_data.json',
    );
    final List<dynamic> data = json.decode(response);

    Batch batch = db.batch();
    for (var investorJson in data) {
      InvestorModel investor = InvestorModel.fromJson(investorJson);
      Map<String, dynamic> investorMap = investor.toMap();
      investorMap.remove('id');
      batch.insert(
        _investorTableName,
        investorMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // Method to get all startups
  Future<List<Startup>> getAllStartups() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_startupTableName);

    // Convert the List<Map<String, dynamic>> into a List<Startup>.
    return List.generate(maps.length, (i) {
      return Startup.fromMap(maps[i]); // Use fromMap for database data
    });
  }

  // Method to get all investors
  Future<List<InvestorModel>> getAllInvestors() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_investorTableName);
    if (maps.isEmpty) return [];
    return List.generate(maps.length, (i) {
      return InvestorModel.fromMap(maps[i]);
    });
  }

  // Method to get the first investor (for profile demo)
  Future<InvestorModel?> getFirstInvestor() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _investorTableName,
      limit: 1, // Get only the first record
    );

    if (maps.isNotEmpty) {
      return InvestorModel.fromMap(maps.first);
    } else {
      return null; // Return null if no investors found
    }
  }

  // Add other CRUD methods here if needed (e.g., insert, update, delete)
}
