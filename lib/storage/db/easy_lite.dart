import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'base_lite.dart';
import 'callback.dart';
import 'dao.dart';
import 'lite.dart';
import 'lite_task.dart';

/// 数据库的操作总入口类
abstract class EasyLite implements OnDatabaseCallback, Lite {

  String get databaseName;
  int get databaseVersion;
  bool get checkIntegrityAuto;

  BaseLite _lite;
  EasyLite() {
    _lite = BaseLite(databaseName, databaseVersion, checkIntegrityAuto);
  }

  @override
  void setOnDatabaseCreate(callback) {
    _lite.setOnDatabaseCreate(callback);
  }

  @override
  void setOnDatabaseDowngrade(callback) {
    _lite.setOnDatabaseDowngrade(callback);
  }

  @override
  void setOnDatabaseError(callback) {
    _lite.setOnDatabaseError(callback);
  }

  @override
  void setOnDatabaseInitialized(callback) {
    _lite.setOnDatabaseInitialized(callback);
  }

  @override
  void setOnDatabaseOpen(callback) {
    _lite.setOnDatabaseOpen(callback);
  }

  @override
  void setOnDatabaseUpgrade(callback) {
    _lite.setOnDatabaseUpgrade(callback);
  }

  @override
  Future<List<dynamic>> batchInsert<T>(Type type, List<T> entities, {bool exclusive, bool noResult, bool continueOnError}) {
    return _lite.batchInsert(type, entities, exclusive: exclusive, noResult: noResult, continueOnError: continueOnError);
  }

  @override
  Future<List<dynamic>> batchUpdate<T>(Type type, List<T> entities, String whereClause,
      {List<dynamic> whereArgs, bool exclusive, bool noResult, bool continueOnError}) {
    return _lite.batchUpdate(type, entities, whereClause, whereArgs: whereArgs,
        exclusive: exclusive, noResult: noResult, continueOnError: continueOnError);
  }

  @override
  Future<int> delete(Type type, String whereClause, {List<dynamic> whereArgs}) {
    return _lite.delete(type, whereClause, whereArgs: whereArgs);
  }

  @override
  Future<bool> exeTransaction(Future<bool> Function(Transaction txn) action, {bool exclusive}) {
    return _lite.exeTransaction(action, exclusive: exclusive);
  }

  @override
  void executeSafely(RootTask task) {
    _lite.executeSafely(task);
  }

  @override
  Future<int> getInt(Type type, String columnOrExpression, String whereClause, {List<dynamic> whereArgs}) {
    return _lite.getInt(type, columnOrExpression, whereClause, whereArgs: whereArgs);
  }

  @override
  Future<List<int>> getInts(Type type, String columnOrExpression, String whereClause, {List<dynamic> whereArgs}) {
    return _lite.getInts(type, columnOrExpression, whereClause, whereArgs: whereArgs);
  }

  @override
  Future<Map<String, dynamic>> getRowValues(Type type, List<String> columnsOrExpressions, String whereClause, {List<dynamic> whereArgs}) {
    return _lite.getRowValues(type, columnsOrExpressions, whereClause, whereArgs: whereArgs);
  }

  @override
  Future<String> getString(Type type, String columnOrExpression, String whereClause, {List<dynamic> whereArgs}) {
    return _lite.getString(type, columnOrExpression, whereClause, whereArgs: whereArgs);
  }

  @override
  Future<List<String>> getStrings(Type type, String columnOrExpression, String whereClause, {List<dynamic> whereArgs}) {
    return _lite.getStrings(type, columnOrExpression, whereClause, whereArgs: whereArgs);
  }

  @override
  Future<bool> has(Type type, String whereClause, {List<dynamic> whereArgs}) {
    return _lite.has(type, whereClause, whereArgs: whereArgs);
  }

  @override
  void init() {
    _lite.init();
  }

  @override
  Future<int> insert<T>(Type type, T entity) {
    return _lite.insert(type, entity);
  }

  @override
  Future<int> insertOrUpdate<T>(Type type, T entity, String whereClause, {List<dynamic> whereArgs}) {
    return _lite.insertOrUpdate(type, entity, whereClause, whereArgs: whereArgs);
  }

  @override
  Future<T> query<T>(Type type, String whereClause, {List<dynamic> whereArgs}) {
    return _lite.query(type, whereClause, whereArgs: whereArgs);
  }

  @override
  Future<List<T>> queryAll<T>(Type type) {
    return _lite.queryAll(type);
  }

  @override
  Future<List<T>> queryMany<T>(Type type, String whereClause, {List<dynamic> whereArgs}) {
    return _lite.queryMany(type, whereClause, whereArgs: whereArgs);
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(Type type, String sql, {List<dynamic> whereArgs}) {
    return _lite.rawQuery(type, sql, whereArgs: whereArgs);
  }

  @override
  void registerDao(Type type, Dao dao) {
    _lite.registerDao(type, dao);
  }

  @override
  void setDebug({@required bool debug, String tag}) {
    _lite.setDebug(debug: debug, tag: tag);
  }

  @override
  Future<int> update<T>(Type type, T entity, String whereClause, {List<dynamic> whereArgs}) {
    return _lite.update(type, entity, whereClause, whereArgs: whereArgs);
  }

  @override
  Future<int> updatePart(Type type, Map<String, dynamic> values, String whereClause, {List<dynamic> whereArgs}) {
    return _lite.updatePart(type, values, whereClause, whereArgs: whereArgs);
  }
}