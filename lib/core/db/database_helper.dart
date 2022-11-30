import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:pr2flutter/data/model/status.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../common/database_request.dart';
import '../../data/model/age.dart';
import '../../data/model/gender.dart';
import '../../data/model/role.dart';
import '../../data/model/user.dart';
import '../../domain/entity/age.dart';
import '../../domain/entity/gender.dart';
import '../../domain/entity/role.dart';
import '../../domain/entity/status.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();

  factory DatabaseHelper() => instance;

  DatabaseHelper._instance();

  final int _version = 1;
  late final String _pathDB;
  late final Directory _appDocumentDirectory;
  late final Database database;

  Future<void> init() async {
    _appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    _pathDB = join(_appDocumentDirectory.path, 'VeloShopDB.db');

    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      database = await databaseFactoryFfi.openDatabase(_pathDB,
          options: OpenDatabaseOptions(
            version: _version,
            onCreate: (db, version) => onCreateTable(db),
            onUpgrade: (db, oldVersion, newVersion) => onUpdateTable(db),
          ));
    } else {
      database = await openDatabase(
        _pathDB,
        version: _version,
        onCreate: (db, version) => onCreateTable(db),
        onUpgrade: (db, oldVersion, newVersion) => onUpdateTable(db),
      );
    }
  }

  Future<void> onCreateTable(Database db) async {
    for (var tableCreateString in DatabaseRequest.tableCreateList) {
      await db.execute(tableCreateString);
    }
    await onInitTable(db);
  }

  Future<void> onInitTable(Database db) async {
    try {
      for (var element in RoleEnum.values) {
        db.insert(DatabaseRequest.tableRole, Role(role: element.name).toMap());
      }
      for (var element in GenderEnum.values) {
        db.insert(
            DatabaseRequest.tableGender, Gender(gender: element.name).toMap());
      }
      for (var element in AgeEnum.values) {
        db.insert(DatabaseRequest.tableAge, Age(age: element.name).toMap());
      }
      for (var element in StatysEnum.values) {
        db.insert(
            DatabaseRequest.tableStatus, Status(status: element.name).toMap());
      }
      db.insert(
        DatabaseRequest.tableUser,
        User(
          login: 'admin',
          idRole: RoleEnum.admin,
          password: 'admin123',
        ).toMap(),
      );
    } on DatabaseException catch (error) {
      print(error.result);
    }
  }

  Future<void> onUpdateTable(Database db) async {
    var tables = await db.rawQuery('Select name from sqlite_master');
    for (var table in DatabaseRequest.tableList.reversed) {
      if (tables.where((element) => element['name'] == table).isNotEmpty) {
        await db.execute(DatabaseRequest.deleteTable(table));
      }
    }

    await onCreateTable(db);
  }

  Future<void> onDropDatabase() async {
    database.close();

    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactoryFfi.deleteDatabase(_pathDB);
    } else {
      deleteDatabase(_pathDB);
    }
  }
}
