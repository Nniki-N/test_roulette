import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_roulette/domain/entity/user_model.dart';

class SqfliteDatabaseRepository {
  static final StreamController<UserModel> _sqfliteStreamController = StreamController<UserModel>();
  static final Stream<UserModel> _sqfliteStream = _sqfliteStreamController.stream.asBroadcastStream();

  static StreamController<UserModel> get sqfliteStreamController => _sqfliteStreamController;
  static Stream<UserModel> get sqfliteStream => _sqfliteStream;

  Future<Database> _initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, 'database.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE Users(user_id TEXT PRIMARY KEY, user_name TEXT NOT NULL, number_of_chips INTEGER NOT NULL, number_of_victories INTEGER NOT NULL, number_of_games INTEGER NOT NULL, win_rate REAL NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<void> saveUserModel({required UserModel userModel}) async {
    final Database db = await _initializeDB();
    await db.insert(
      'Users',
      userModel.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    SqfliteDatabaseRepository._sqfliteStreamController.add(userModel);
  }

  Future<UserModel?> getUserModel({required String userId}) async {
    final Database db = await _initializeDB();

    final result = await db.query(
      'Users',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return result.isEmpty ? null : UserModel.fromJson(result[0]);
  }
}