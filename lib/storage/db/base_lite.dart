import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_practice/storage/db/base_dao.dart';
import 'package:flutter_practice/storage/db/dao.dart';
import 'package:flutter_practice/storage/db/database.dart';
import 'package:flutter_practice/storage/db/sqflite_database.dart';
import 'package:flutter_practice/storage/db/table_builder.dart';
import 'package:flutter_practice/storage/db/time_recorder.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'db_utils.dart';
import 'lite_task.dart';
import 'lite.dart';
import 'callback.dart';
import 'db_log.dart';

/// 数据库所有操作Base实现
abstract class BaseLite implements OnDatabaseCallback, Lite {

  final Map<Type, Dao> _daoMap = {};

  final TableBuilder tableBuilder = TableBuilder();
  TaskExecutor taskExecutor;

  final SqfliteDatabase _database = SqfliteDatabase();

  String get databaseName;
  int get databaseVersion;
  bool get checkIntegrityAuto;

  BaseLite() {
    taskExecutor = TaskExecutor(this);
  }

  bool _debug = false;
  String _debugTag;
  @override
  void setDebug({@required bool debug, String tag}) {
    _debug = debug ?? false;
    _debugTag = tag;
    _database.setDebug(debug: _debug, tag: _debugTag);
  }

  OnDatabaseError _onDatabaseErrorCallback;
  /// 设置数据库异常回调，在非debug环境下，可以监听数据库异常
  @override
  void setOnDatabaseError(OnDatabaseError callback) {
    _onDatabaseErrorCallback = callback;
  }

  OnDatabaseCreate _onDatabaseCreateCallback;
  @override
  void setOnDatabaseCreate(OnDatabaseCreate callback) {
    _onDatabaseCreateCallback = callback;
  }

  OnDatabaseVersionChange _onDatabaseDowngradeCallback;
  @override
  void setOnDatabaseDowngrade(OnDatabaseVersionChange callback) {
    _onDatabaseDowngradeCallback = callback;
  }

  OnDatabaseOpen _onDatabaseOpenCallback;
  @override
  void setOnDatabaseOpen(OnDatabaseOpen callback) {
    _onDatabaseOpenCallback = callback;
  }

  OnDatabaseVersionChange _onDatabaseUpgradeCallback;
  @override
  void setOnDatabaseUpgrade(OnDatabaseVersionChange callback) {
    _onDatabaseUpgradeCallback = callback;
  }

  OnDatabaseInitialized onDatabaseInitialized;
  @override
  void setOnDatabaseInitialized(OnDatabaseInitialized callback) {
    onDatabaseInitialized = callback;
  }

  /// 正在初始化
  bool _initializing = false;
  /// 已初始化完毕
  bool _initialized  = false;
  /// 数据库初始化
  @override
  void init() async {
    if (_initialized || _initializing) {
      if (_debug) {
        DbLog.dSingle('$databaseName已初始化完毕，请勿重复初始化!', tag: _debugTag);
      }
      return;
    }
    _initializing = true;
    TimeRecorder recorder;
    if (_debug) {
      recorder = TimeRecorder.of();
      DbLog.dSingle(
          '开始初始化$databaseName，${recorder.info}',
          currClass: this,
          tag: _debugTag
      );
    }
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);
    if (_debug) {
      recorder.record();
      DbLog.dSingle(
          'documentsDirectory: $path, ${recorder.info}, version: $databaseVersion',
          currClass: this,
          tag: _debugTag);
    }
    await _database.openSqfliteDatabase(
        path,
        version: databaseVersion,
        onDatabaseCreate: _onDatabaseCreate,
        onDatabaseUpgrade: _onDatabaseUpgradeCallback,
        onDatabaseDowngrade: _onDatabaseDowngradeCallback,
        onDatabaseOpen: _onDatabaseOpenCallback
    );
    if (_debug) {
      recorder.record();
      DbLog.dSingle(
          'openSqfliteDatabase，${DbUtils.filename(path)}, ${recorder.info}, version: $databaseVersion',
          currClass: this,
          tag: _debugTag
      );
    }
    await _checkDatabaseIntegrity();
    if (_debug) {
      recorder.record();
      DbLog.dSingle(
          '_checkDatabaseIntegrity，${DbUtils.filename(path)}, ${recorder.info}, version: $databaseVersion',
          currClass: this,
          tag: _debugTag
      );
    }
    _initialized = true;
    _initializing = false;
    if (onDatabaseInitialized != null) onDatabaseInitialized();
    if (_debug) {
      recorder.record();
      DbLog.dSingle(
          'init，${recorder.info}',
          currClass: this,
          tag: _debugTag
      );
    }
    taskExecutor?.execute();
  }

  /// 检查数据库表完整性
  Future<void> _checkDatabaseIntegrity() async {
    if (!(checkIntegrityAuto ?? false)) {
      return;
    }
    Map<String, List<String>> tables = await tableBuilder.findTables(_database, debug: _debug, tag: _debugTag);
    _daoMap.forEach((key, value) async {
      await tableBuilder.checkTableIntegrity(_database, tables, value, debug: _debug, tag: _debugTag);
    });
  }

  @override
  void registerDao(Type type, Dao dao) {
    if (type == null || dao == null) {
      if (type == null) _handleError("the parameter type can not be null!");
      if (dao == null) _handleError("the parameter dao can not be null!");
      return;
    }
    if (dao is BaseDao) dao.dao = _database;
    _daoMap[type] = dao;
  }

  /// 严重异常处理
  void _handleError(String message) {
    if (_debug) {
      /// 若当前是debug模式，则直接抛出异常
      throw FlutterError(message);
    } else {
      /// 非debug模式
      if (_onDatabaseErrorCallback == null) {
        DbLog.dSingle(message, currClass: this, tag: _debugTag);
      } else {
        _onDatabaseErrorCallback(FlutterError(message));
      }
    }
  }

  /// 处理程序异常
  void _handleException(Error e) {
    if (_debug) {
      throw e;
    }
    if (_onDatabaseErrorCallback != null) {
      _onDatabaseErrorCallback(e);
    }
  }

  void _onDatabaseCreate(RootDatabase db, int version) {
    if (!(checkIntegrityAuto ?? false)) {
      _daoMap.forEach((key, value) {
        if (version is BaseDao) tableBuilder.createTable(db, version as BaseDao);
      });
    }
    if (_onDatabaseCreateCallback != null) _onDatabaseCreateCallback(db, version);
    if (_debug) DbLog.dSingle('_onDatabaseCreate', currClass: this, tag: _debugTag);
  }

  @override
  Future<List<dynamic>> batchInsert<T>(Type type, List<T> entities, {bool exclusive, bool noResult, bool continueOnError}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      List<dynamic> result = await _daoMap[type].batchInsert(entities, exclusive: exclusive, noResult: noResult, continueOnError: continueOnError);
      if (_debug) {
        recorder.record();
        DbLog.printResult(
            _debugTag, _daoMap[type], 'batchInsert', type, result, recorder.info,
            entities: entities,
            exclusive: exclusive, noResult: noResult, continueOnError: continueOnError
        );
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<List<dynamic>> batchUpdate<T>(Type type, List<T> entities, String primaryKey, {bool exclusive, bool noResult, bool continueOnError}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      List<dynamic> result = await _daoMap[type].batchUpdate(entities, primaryKey, exclusive: exclusive, noResult: noResult, continueOnError: continueOnError);
      if (_debug) {
        recorder.record();
        DbLog.printResult(
            _debugTag, _daoMap[type], 'batchUpdate', type, result, recorder.info,
            primaryKey: primaryKey, exclusive: exclusive, noResult: noResult, continueOnError: continueOnError
        );
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<int> delete(Type type, String whereClause, {List<dynamic> whereArgs}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      int result = await _daoMap[type].delete(whereClause, whereArgs: whereArgs);
      if (_debug) {
        recorder.record();
        DbLog.printResult(_debugTag, _daoMap[type], 'delete', type, result, recorder.info,
            whereClause: whereClause, whereArgs: whereArgs);
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<int> deleteAll(Type type) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      int result = await _daoMap[type].delete('1 = 1');
      if (_debug) {
        recorder.record();
        DbLog.printResult(_debugTag, _daoMap[type], 'deleteAll', type, result, recorder.info);
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<bool> exeTransaction(Future<bool> Function(Transaction txn) action, {bool exclusive}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      bool result = await _database.transaction<bool>(action, exclusive: exclusive);
      if (_debug) {
        recorder.record();
        DbLog.printResult(_debugTag, null, 'exeTransaction', null, result, recorder.info, exclusive: exclusive);
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<int> getInt(Type type, String columnOrExpression, String whereClause, {List<dynamic> whereArgs}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      int result = await _daoMap[type].getInt(columnOrExpression, whereClause, whereArgs: whereArgs);
      if (_debug) {
        recorder.record();
        DbLog.printResult(
            _debugTag, _daoMap[type], 'getInt', type, result, recorder.info,
            columnOrExpression: columnOrExpression, whereClause: whereClause, whereArgs: whereArgs
        );
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<List<int>> getInts(Type type, String columnOrExpression, String whereClause, {List<dynamic> whereArgs}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      List<int> result = await _daoMap[type].getInts(columnOrExpression, whereClause, whereArgs: whereArgs);
      if (_debug) {
        recorder.record();
        DbLog.printResult(_debugTag, _daoMap[type], 'getInts', type, result, recorder.info,
            columnOrExpression: columnOrExpression, whereClause: whereClause, whereArgs: whereArgs
        );
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> getRowValues(Type type, List<String> columnsOrExpressions, String whereClause, {List<dynamic> whereArgs}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      Map<String, dynamic> result = await _daoMap[type].getRowValues(columnsOrExpressions, whereClause, whereArgs: whereArgs);
      if (_debug) {
        recorder.record();
        DbLog.printResult(_debugTag, _daoMap[type], 'getRowValues', type, result, recorder.info,
            columnsOrExpressions: columnsOrExpressions, whereClause: whereClause, whereArgs: whereArgs);
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<String> getString(Type type, String columnOrExpression, String whereClause, {List<dynamic> whereArgs}) async {
    if (!_initialized) {
      return null;
    }
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      String result = await _daoMap[type].getString(columnOrExpression, whereClause, whereArgs: whereArgs);
      if (_debug) {
        recorder.record();
        DbLog.printResult(_debugTag, _daoMap[type], 'getString', type, result, recorder.info,
            columnOrExpression: columnOrExpression,
          whereClause: whereClause,
          whereArgs: whereArgs
        );
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<List<String>> getStrings(Type type, String columnOrExpression, String whereClause, {List<dynamic> whereArgs}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      List<String> result = await _daoMap[type].getStrings(columnOrExpression, whereClause, whereArgs: whereArgs);
      if (_debug) {
        recorder.record();
        DbLog.printResult(_debugTag, _daoMap[type], 'getStrings', type, result, recorder.info,
            columnOrExpression: columnOrExpression, whereClause: whereClause, whereArgs: whereArgs
        );
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<bool> has(Type type, String whereClause, {List<dynamic> whereArgs}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      bool result = await _daoMap[type].has(whereClause, whereArgs: whereArgs);
      if (_debug) {
        recorder.record();
        DbLog.printResult(_debugTag, _daoMap[type], 'has', type, result, recorder.info,
            whereClause: whereClause, whereArgs: whereArgs
        );
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<int> insert<T>(Type type, T entity) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      int result = await _daoMap[type].insert(entity);
      if (_debug) {
        recorder.record();
        DbLog.printResult(_debugTag, _daoMap[type], 'insert', type, result, recorder.info, entity: entity);
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<int> insertOrUpdate<T>(Type type, T entity, String whereClause, {List<dynamic> whereArgs}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      int result = await _daoMap[type].insertOrUpdate(entity, whereClause, whereArgs: whereArgs);
      if (_debug) {
        recorder.record();
        DbLog.printResult(
            _debugTag, _daoMap[type], 'insertOrUpdate', type, result, recorder.info, entity: entity,
            whereClause: whereClause, whereArgs: whereArgs
        );
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<T> query<T>(Type type, String whereClause, {List<dynamic> whereArgs}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      T result = await _daoMap[type].query(whereClause, whereArgs: whereArgs);
      if (_debug) {
        recorder.record();
        DbLog.printResult(
            _debugTag, _daoMap[type], 'query', type, result, recorder.info,
            whereClause: whereClause, whereArgs: whereArgs
        );
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<List<T>> queryAll<T>(Type type) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      List<T> result = await _daoMap[type].queryAll();
      if (_debug) {
        recorder.record();
        DbLog.printResult(_debugTag, _daoMap[type], 'queryAll', type, result, recorder.info);
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<List<T>> queryMany<T>(Type type, String whereClause, {List<dynamic> whereArgs}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      List<T> result = await _daoMap[type].queryMany(whereClause, whereArgs: whereArgs);
      if (_debug) {
        recorder.record();
        DbLog.printResult(
            _debugTag, _daoMap[type], 'queryMany', type, result, recorder.info,
            whereClause: whereClause, whereArgs: whereArgs
        );
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(Type type, String sql, {List<dynamic> whereArgs}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      List<Map<String, dynamic>> result = await _daoMap[type].rawQuery(sql, whereArgs: whereArgs);
      if (_debug) {
        recorder.record();
        DbLog.printResult(
            _debugTag, _daoMap[type], 'rawQuery', type, result, recorder.info,
            sql: sql, whereArgs: whereArgs
        );
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<int> update<T>(Type type, T entity, String whereClause, {List<dynamic> whereArgs}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      int result = await _daoMap[type].update(entity, whereClause, whereArgs: whereArgs);
      if (_debug) {
        recorder.record();
        DbLog.printResult(
            _debugTag, _daoMap[type], 'update', type, result, recorder.info, entity: entity,
            whereClause: whereClause, whereArgs: whereArgs
        );
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  @override
  Future<int> updatePart(Type type, Map<String, dynamic> values, String whereClause, {List<dynamic> whereArgs}) async {
    if (!_initialized) return null;
    try {
      TimeRecorder recorder;
      if (_debug) recorder = TimeRecorder.of();
      int result = await _daoMap[type].updatePart(values, whereClause, whereArgs: whereArgs);
      if (_debug) {
        recorder.record();
        DbLog.printResult(
            _debugTag, _daoMap[type], 'update', type, result, recorder.info, values: values,
            whereClause: whereClause, whereArgs: whereArgs
        );
      }
      return result;
    } catch (e) {
      _handleException(e);
      return null;
    }
  }

  /// See: [Lite].executeSafely
  @override
  void executeSafely(RootTask task) {
    if (task == null) _handleError("task can not be null");
    taskExecutor.enqueue(task);
    if (_initialized) taskExecutor.execute();
  }

}