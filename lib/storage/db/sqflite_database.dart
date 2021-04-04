import 'package:flutter/material.dart';
import 'package:flutter_practice/storage/db/database.dart';
import 'package:sqflite/sqflite.dart';

import 'callback.dart';
import 'db_utils.dart';
import 'log.dart';
import 'time_recorder.dart';

/// sqflite数据库接入实现
class SqfliteDatabase implements RootDatabase {

  Database _database;
  BatchImpl _batchImpl;

  bool _debug = false;
  String _debugTag;
  @override
  void setDebug({@required bool debug, String tag}) {
    _debug = debug ?? false;
    _debugTag = tag;
  }

  Future<void> openSqfliteDatabase(String path,
      {int version,
        OnDatabaseConfigure onDatabaseConfigure,
        OnDatabaseCreate onDatabaseCreate,
        OnDatabaseVersionChange onDatabaseUpgrade,
        OnDatabaseVersionChange onDatabaseDowngrade,
        OnDatabaseOpen onDatabaseOpen,
        bool readOnly = false,
        bool singleInstance = true}) async {
    final sqfliteDatabase = this;
    TimeRecorder recorder;
    if (_debug) {
      recorder = TimeRecorder.of();
      Log.dSingle('开始创建数据库${DbUtils.filename(path)}, ${recorder.time}', currClass: this, tag: _debugTag);
    }
    _database = await openDatabase(
        path,
        version: version,
        onCreate: (Database db, int version) {
          if (_debug) {
            recorder.record();
            Log.dSingle(
                '创建数据库${DbUtils.filename(path)}, ${recorder.info}, version: $version',
                currClass: this,
                tag: _debugTag
            );
          }
          if (onDatabaseCreate != null) onDatabaseCreate(sqfliteDatabase, version);
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) {
          if (_debug) {
            recorder.record();
            Log.dSingle(
                '升级数据库${DbUtils.filename(path)}, ${recorder.info}, oldVersion: $oldVersion, newVersion: $newVersion',
                currClass: this,
                tag: _debugTag
            );
          }
          if (onDatabaseUpgrade != null) onDatabaseUpgrade(sqfliteDatabase, oldVersion, newVersion);
        },
        onDowngrade: (Database db, int oldVersion, int newVersion) {
          if (_debug) {
            recorder.record();
            Log.dSingle(
                '降级数据库${DbUtils.filename(path)}, ${recorder.info}, oldVersion: $oldVersion, newVersion: $newVersion',
                currClass: this,
                tag: _debugTag
            );
          }
          if (onDatabaseDowngrade != null) onDatabaseDowngrade(sqfliteDatabase, oldVersion, newVersion);
        },
        onOpen: (Database db) {
          if (_debug) {
            recorder.record();
            Log.dSingle(
                '打开数据库${DbUtils.filename(path)}, time: ${recorder.info}',
                currClass: this,
                tag: _debugTag
            );
          }
          if (onDatabaseOpen != null) onDatabaseOpen(sqfliteDatabase);
        }
    );
    _batchImpl = BatchImpl(_database);
  }

  @override
  RootBatch batch() {
    return _batchImpl;
  }

  @override
  Future<int> delete(String table, {String where, List whereArgs}) {
    return _database.delete(table, where: where, whereArgs: whereArgs);
  }

  @override
  Future<void> execute(String sql, [List arguments]) {
    return _database.execute(sql, arguments);
  }

  @override
  Future<List<Map<String, dynamic>>> query(String table, {bool distinct, List<String> columns, String where, List whereArgs,
    String groupBy, String having, String orderBy, int limit, int offset}) {
    return _database.query(table, distinct: distinct, columns: columns, where: where, whereArgs: whereArgs,
        groupBy: groupBy, having: having, orderBy: orderBy,
        limit: limit, offset: offset);
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List arguments]) {
    return _database.rawQuery(sql, arguments);
  }

  @override
  Future<int> update(String table, Map<String, dynamic> values, {String where, List whereArgs}) {
    return _database.update(table, values, where: where, whereArgs: whereArgs);
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> values, {String nullColumnHack}) {
    return _database.insert(table, values, nullColumnHack: nullColumnHack);
  }

  @override
  Future<void> close() {
    return _database.close();
  }

  @override
  Future<int> getVersion() {
    return _database.getVersion();
  }

  bool get isOpen => _database.isOpen;

  @override
  String get path => _database.path;

  @override
  Future<int> rawDelete(String sql, [List<dynamic> arguments]) {
    return _database.rawDelete(sql, arguments);
  }

  @override
  Future<int> rawInsert(String sql, [List<dynamic> arguments]) {
    return _database.rawInsert(sql, arguments);
  }

  @override
  Future<int> rawUpdate(String sql, [List<dynamic> arguments]) {
    return _database.rawUpdate(sql, arguments);
  }

  @override
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action, {bool exclusive}) {
    return _database.transaction(action, exclusive: exclusive);
  }

}

class BatchImpl extends RootBatch {

  final Database database;
  BatchImpl(this.database);

  @override
  Future<List> commit({bool exclusive, bool noResult, bool continueOnError}) {
    return database.batch().commit(exclusive: exclusive, noResult: noResult, continueOnError: continueOnError);
  }

  @override
  void insert(String table, Map<String, dynamic> values, {String nullColumnHack}) {
    database.batch().insert(table, values, nullColumnHack: nullColumnHack);
  }

  @override
  void update(String table, Map<String, dynamic> values, String where, {List whereArgs}) {
    database.batch().update(table, values, where: where, whereArgs: whereArgs);
  }

}