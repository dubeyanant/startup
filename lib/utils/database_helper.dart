import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart' show rootBundle;

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
    print("Creating database tables...");
    await db.execute('''
      CREATE TABLE $_startupTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        name TEXT NOT NULL,
        tagline TEXT,
        description TEXT,
        sector TEXT,
        funding TEXT,
        location TEXT,
        date TEXT,
        website TEXT,
        fundingGoal INTEGER,
        founders TEXT -- Storing JSON string of all founders
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
    print("Database tables created.");
  }

  Future<void> _populateInitialData(Database db) async {
    await _populateInvestorData(db);
    print("Initial investor data populated.");
    await _populateStartupData(db);
    print("Initial startup data populated.");
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
      investorMap['password_hash'] = hashPassword('defaultPassword123!');
      if (!investorMap.containsKey('email')) {
        investorMap['email'] =
            'placeholder_${DateTime.now().millisecondsSinceEpoch}@example.com';
        print(
          "Warning: Added placeholder email for investor: ${investorMap['name']}",
        );
      }

      batch.insert(
        _investorTableName,
        investorMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
    print("Investor data population attempt complete.");
  }

  // Added function to populate startup data from JSON
  Future<void> _populateStartupData(Database db) async {
    final String response = await rootBundle.loadString(
      'assets/startup_data.json',
    );
    final List<dynamic> data = json.decode(response);

    Batch batch = db.batch();
    for (var startupJson in data) {
      Startup startup = Startup.fromJson(startupJson);
      Map<String, dynamic> startupMap = startup.toMap();
      startupMap.remove('id'); // Remove ID for auto-increment

      // Add default password hash and primary email (from first founder)
      startupMap['password_hash'] = hashPassword('defaultPassword123!');
      if (startup.founders.isNotEmpty &&
          startup.founders.first.email.isNotEmpty) {
        startupMap['email'] = startup.founders.first.email;
      } else {
        // Assign a placeholder if no valid founder email exists, although the model requires one
        startupMap['email'] =
            'placeholder_startup_${DateTime.now().millisecondsSinceEpoch}@example.com';
        print(
          "Warning: Added placeholder email for startup: ${startupMap['name']}",
        );
      }

      // Ensure founders list is stored as JSON string
      if (startupMap['founders'] is List) {
        startupMap['founders'] = jsonEncode(startupMap['founders']);
      }

      batch.insert(
        _startupTableName,
        startupMap,
        conflictAlgorithm:
            ConflictAlgorithm.replace, // Use replace for initial population
      );
    }
    await batch.commit(noResult: true);
    print("Startup data population attempt complete.");
  }

  // Method to get all startups
  Future<List<Startup>> getAllStartups() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_startupTableName);
    return List.generate(maps.length, (i) {
      return Startup.fromMap(maps[i]);
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
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return InvestorModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Basic password hashing
  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Insert a newly signed-up investor
  Future<int> insertNewInvestor(Map<String, dynamic> row) async {
    Database db = await database;
    if (row.containsKey('password') && row['password'] != null) {
      row['password_hash'] = hashPassword(row['password'] as String);
      row.remove('password');
    } else {
      throw ArgumentError('Password is required for inserting a new investor.');
    }
    if (!row.containsKey('email') || row['email'] == null) {
      throw ArgumentError('Email is required for inserting a new investor.');
    }

    if (row['investmentFocus'] is List) {
      row['investmentFocus'] = jsonEncode(row['investmentFocus']);
    }
    if (row['pastInvestments'] is List) {
      row['pastInvestments'] = jsonEncode(row['pastInvestments']);
    }

    try {
      return await db.insert(
        _investorTableName,
        row,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } catch (e) {
      print("Error inserting new investor: $e");
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw Exception('Email already exists.');
      }
      rethrow;
    }
  }

  // Insert a newly signed-up startup
  Future<int> insertNewStartup(Startup startup, String password) async {
    Database db = await database;
    Map<String, dynamic> row = startup.toMap();

    String email;
    if (startup.founders.isNotEmpty &&
        startup.founders.first.email.isNotEmpty) {
      email = startup.founders.first.email;
    } else {
      throw ArgumentError(
        'Startup must have at least one founder with a valid email for signup.',
      );
    }

    row['email'] = email;
    row['password_hash'] = hashPassword(password);
    row.remove('id');

    try {
      print(
        "Attempting to insert startup: ${row['name']} with email ${row['email']}",
      );
      int id = await db.insert(
        _startupTableName,
        row,
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
      print("Startup insertion successful, ID: $id");
      return id;
    } catch (e) {
      print("Error inserting new startup: $e");
      if (e.toString().contains('UNIQUE constraint failed')) {
        throw Exception('Email already exists.');
      }
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

  // Fetch a startup by their primary login email
  Future<Startup?> fetchStartupByEmail(String email) async {
    Database db = await database;
    print("Fetching startup by email: $email");
    final List<Map<String, dynamic>> maps = await db.query(
      _startupTableName,
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      print("Startup found for email: $email");
      return Startup.fromMap(maps.first);
    } else {
      print("Startup not found for email: $email");
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
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      final userMap = maps.first;
      final storedHash = userMap['password_hash'] as String?;
      final providedPasswordHash = hashPassword(password);
      if (storedHash != null && storedHash == providedPasswordHash) {
        return InvestorModel.fromMap(userMap);
      }
    }
    return null;
  }

  // Verify startup login credentials
  Future<Startup?> verifyStartupLogin(String email, String password) async {
    Database db = await database;
    print("Verifying startup login for email: $email");
    final List<Map<String, dynamic>> maps = await db.query(
      _startupTableName,
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final startupMap = maps.first;
      if (startupMap.containsKey('password_hash') &&
          startupMap['password_hash'] != null) {
        final storedHash = startupMap['password_hash'] as String;
        final providedPasswordHash = hashPassword(password);

        if (storedHash == providedPasswordHash) {
          print("Startup login successful for email: $email");
          return Startup.fromMap(startupMap);
        } else {
          print("Startup password mismatch for email: $email");
        }
      } else {
        print("Password hash not found or is null for startup email: $email");
      }
    } else {
      print("Startup email not found: $email");
    }
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

  // Delete a startup by their primary login email
  Future<int> deleteStartupByEmail(String email) async {
    Database db = await database;
    print("Deleting startup by email: $email");
    try {
      int deletedRows = await db.delete(
        _startupTableName,
        where: 'email = ?',
        whereArgs: [email],
      );
      print("Deleted $deletedRows startup rows for email: $email");
      return deletedRows;
    } catch (e) {
      print("Error deleting startup: $e");
      rethrow;
    }
  }
}
