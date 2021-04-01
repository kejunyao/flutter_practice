import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_practice/storage/db/dao.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'base_lite.dart';
import 'callback.dart';
import 'dao_owner.dart';
import 'log.dart';

/// Flutter数据库
class DarLite implements OnDatabaseConfigCallback, BaseLite {

  final Map<Type, DaoOwner> _daoOwners = {};
  final OnDatabaseChange _onDatabaseChange = OnDatabaseChange();

  Database _database;

  final String dbName;
  final int dbVersion;
  final bool checkIntegrityAuto;

  DarLite(this.dbName, this.dbVersion, this.checkIntegrityAuto);

  bool _debug = false;
  String _debugTag;
  void setDebug({@required bool debug, String tag}) {
    _debug = debug;
    _debugTag = tag;
  }

  OnDatabaseErrorCallback _errorCallback;
  /// 设置数据库异常回调，在非debug环境下，可以监听数据库异常
  void setOnDatabaseErrorCallback(OnDatabaseErrorCallback callback) {
    _errorCallback = callback;
  }

  /// 正在初始化
  bool _initializing = false;
  /// 已初始化完毕
  bool _initialized  = false;
  /// 数据库初始化
  void init() async {
    if (_initialized || _initializing) {
      return;
    }
    _initializing = true;

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    _database = await openDatabase(
        path, version: dbVersion,
        onCreate: _onDatabaseCreate,
        onUpgrade: _onDatabaseUpgrade,
        onDowngrade: _onDatabaseDowngrade,
        onOpen: _onDatabaseOpen
    );
    await _checkDatabaseIntegrity();
  }

  /// 检查数据库表完整性
  Future<void> _checkDatabaseIntegrity() async {
    if (!checkIntegrityAuto) {
      return;
    }
    _daoOwners.forEach((key, value) {
      value.checkTableIntegrity();
    });
    _initialized = true;
    _initializing = false;
  }

  @override
  void registerDao(Type type, Dao dao) {
    if (type == null || dao == null) {
      if (type == null) _handleError("the parameter type can not be null!");
      if (dao == null) _handleError("the parameter dao can not be null!");
      return;
    }
    _daoOwners[type] = DaoOwner(dao);
  }

  void _handleError(String message) {
    if (_debug) {
      throw FlutterError(message);
    } else {
      if (_errorCallback == null) {
        LiteLog.d([message], tag: _debugTag);
      } else {
        _errorCallback(FlutterError(message));
      }
    }
  }

  void _onDatabaseCreate(Database db, int version) {
    _onDatabaseChange.postOnCreate(db, version);
  }

  void _onDatabaseUpgrade(Database db, int oldVersion, int newVersion) {
    _onDatabaseChange.postOnUpgrade(db, oldVersion, newVersion);
  }

  void _onDatabaseDowngrade(Database db, int oldVersion, int newVersion) {
    _onDatabaseChange.postOnDowngrade(db, oldVersion, newVersion);
  }

  void _onDatabaseOpen(Database db) {
    _onDatabaseChange.postOnOpen(db);
  }

  @override
  void registerOnCreateCallback(String key, OnDatabaseCreateFn callback) {
    _onDatabaseChange.registerOnCreateCallback(key, callback);
  }

  @override
  void registerOnDowngradeCallback(String key, OnDatabaseVersionChangeFn callback) {
    _onDatabaseChange.registerOnDowngradeCallback(key, callback);
  }

  @override
  void registerOnOpenCallback(String key, OnDatabaseOpenFn callback) {
    _onDatabaseChange.registerOnOpenCallback(key, callback);
  }

  @override
  void registerOnUpgradeCallback(String key, OnDatabaseVersionChangeFn callback) {
    _onDatabaseChange.registerOnUpgradeCallback(key, callback);
  }

  @override
  void unregisterOnCreateCallback(String key) {
    _onDatabaseChange.unregisterOnCreateCallback(key);
  }

  @override
  void unregisterOnOpenCallback(String key) {
    _onDatabaseChange.unregisterOnOpenCallback(key);
  }

  @override
  void unregisterOnUpgradeCallback(String key) {
    _onDatabaseChange.unregisterOnUpgradeCallback(key);
  }

  @override
  Future<List> batchInsert<T>({Type type, List<T> entities, bool exclusive, bool noResult, bool continueOnError}) {
    return _daoOwners[type].dao.batchInsert(entities, exclusive: exclusive, noResult: noResult, continueOnError: continueOnError);
  }

  @override
  Future<List> batchUpdate<T>({Type type, List<T> entities, String whereClause, List whereArgs, bool exclusive, bool noResult, bool continueOnError}) {
    return _daoOwners[type].dao.batchUpdate(entities, whereClause, whereArgs, exclusive: exclusive, noResult: noResult, continueOnError: continueOnError);
  }

  @override
  Future<int> delete({Type type, String whereClause, List whereArgs}) {
    return _daoOwners[type].dao.delete(whereClause, whereArgs);
  }

  @override
  Future<bool> exeTransaction(Future<bool> Function(Transaction txn) action, {bool exclusive}) {
    return _daoOwners.values.first.dao.exeTransaction(action, exclusive: exclusive);
  }

  @override
  Future<int> getInt({Type type, String columnOrExpression, String whereClause, List whereArgs}) {
    return _daoOwners[type].dao.getInt(columnOrExpression, whereClause, whereArgs);
  }

  @override
  Future<List<int>> getInts({Type type, String columnOrExpression, String whereClause, List whereArgs}) {
    return _daoOwners[type].dao.getInts(columnOrExpression, whereClause, whereArgs);
  }

  @override
  Future<Map<String, dynamic>> getRowValues({Type type, List<String> columnsOrExpressions, String whereClause, List whereArgs}) {
    return _daoOwners[type].dao.getRowValues(columnsOrExpressions, whereClause, whereArgs);
  }

  @override
  Future<String> getString({Type type, String columnOrExpression, String whereClause, List whereArgs}) {
    return _daoOwners[type].dao.getString(columnOrExpression, whereClause, whereArgs);
  }

  @override
  Future<List<String>> getStrings({Type type, String columnOrExpression, String whereClause, List whereArgs}) {
    return _daoOwners[type].dao.getStrings(columnOrExpression, whereClause, whereArgs);
  }

  @override
  Future<bool> has({Type type, String whereClause, List whereArgs}) {
    return _daoOwners[type].dao.has(whereClause: whereClause, whereArgs: whereArgs);
  }

  @override
  Future<int> insert<T>({@required Type type, @required T entity}) {
    return _daoOwners[type].dao.insert(entity);
  }

  @override
  Future<int> insertOrUpdate<T>({Type type, T entity, String whereClause, List whereArgs}) {
    return _daoOwners[type].dao.insertOrUpdate(entity, whereClause, whereArgs);
  }

  @override
  Future<T> query<T>({Type type, String whereClause, List whereArgs}) {
    return _daoOwners[type].dao.query(whereClause: whereClause, whereArgs: whereArgs);
  }

  @override
  Future<List<T>> queryAll<T>(Type type) {
    return _daoOwners[type].dao.queryAll();
  }

  @override
  Future<List<T>> queryMany<T>({Type type, String whereClause, List whereArgs}) {
    return _daoOwners[type].dao.queryMany(whereClause: whereClause, whereArgs: whereArgs);
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery({Type type, String sql, List selectionArgs}) {
    return _daoOwners[type].dao.rawQuery(sql, selectionArgs);
  }

  @override
  Future<int> update<T>({Type type, T entity, String whereClause, List whereArgs}) {
    return _daoOwners[type].dao.update(entity, whereClause, whereArgs);
  }

  @override
  Future<int> updatePart({Type type, Map<String, dynamic> values, String whereClause, List whereArgs}) {
    return _daoOwners[type].dao.updatePart(values, whereClause, whereArgs);
  }

}