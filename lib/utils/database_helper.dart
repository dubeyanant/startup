import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
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

    Database db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );

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
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        name TEXT NOT NULL,
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

    // Populate initial data right after creating tables
    await _populateInitialData(db);
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
      // Add default password hash for initial investors from JSON
      // Ensure email is also present in the map if it's NOT NULL in schema (it seems to be based on error)
      investorMap['password_hash'] = hashPassword('defaultPassword123!');

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

  // Basic password hashing (consider a stronger algorithm like bcrypt/argon2)
  String hashPassword(String password) {
    final bytes = utf8.encode(password); // data being hashed
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Insert a newly signed-up investor
  Future<int> insertNewInvestor(Map<String, dynamic> row) async {
    Database db = await database;

    // Hash the password before inserting
    if (row.containsKey('password') && row['password'] != null) {
      row['password_hash'] = hashPassword(row['password'] as String);
      row.remove('password'); // Don't store the plain password
    } else {
      // Handle error: password is required for new investor
      throw ArgumentError('Password is required for inserting a new investor.');
    }

    // Ensure lists are stored as JSON strings
    if (row['investmentFocus'] is List) {
      row['investmentFocus'] = jsonEncode(row['investmentFocus']);
    }
    if (row['pastInvestments'] is List) {
      row['pastInvestments'] = jsonEncode(row['pastInvestments']);
    }

    // Remove fields not in the schema if they exist in the map by mistake
    // (e.g., if the map was created directly from a model with extra fields)
    // Although in our current flow from InvestorDetailsScreen, this shouldn't be an issue.

    // Perform the insertion
    try {
      return await db.insert(
        _investorTableName,
        row,
        conflictAlgorithm:
            ConflictAlgorithm.fail, // Fail if email is not unique
      );
    } catch (e) {
      print("Error inserting new investor: $e");
      // Rethrow or handle specific errors (like UNIQUE constraint failure)
      rethrow;
    }
  }

  // Fetch an investor by their email
  Future<InvestorModel?> fetchInvestorByEmail(String email) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _investorTableName,
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return InvestorModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Verify investor login credentials
  Future<InvestorModel?> verifyInvestorLogin(
    String email,
    String password,
  ) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _investorTableName,
      columns: [
        'id',
        'email',
        'password_hash',
        'name',
        'location',
        'tagline',
        'minInvestment',
        'maxInvestment',
        'bio',
        'investmentFocus',
        'pastInvestments',
        'activeSince',
      ], // Explicitly list columns
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final userMap = maps.first;
      final storedHash = userMap['password_hash'] as String?;
      final providedPasswordHash = hashPassword(password);

      if (storedHash != null && storedHash == providedPasswordHash) {
        // Passwords match, return the investor model
        return InvestorModel.fromMap(userMap);
      }
    }
    // Email not found or password doesn't match
    return null;
  }

  // Delete an investor by email
  Future<int> deleteInvestorByEmail(String email) async {
    Database db = await database;
    try {
      return await db.delete(
        _investorTableName,
        where: 'email = ?',
        whereArgs: [email],
      );
    } catch (e) {
      print("Error deleting investor: $e");
      rethrow;
    }
  }

  // Add other CRUD methods here if needed (e.g., insert, update, delete)
}
