import 'package:sqflite/sqflite.dart';

import 'dao.dart';

abstract class BaseDao<T> implements Dao<T> {

  Database _database;
  BaseDao(Database database) {
    _database = database;
  }

  String getTable();

  List<String> getColumns();

  T toEntity(Map<String, dynamic> map);

  Map<String, dynamic> toValues(T entity);

  @override
  Future<List<dynamic>> batchInsert(List<T> entities,
      {bool exclusive, bool noResult, bool continueOnError}) async {
    Batch batch = _database.batch();
    String table = getTable();
    for (T e in entities) {
      Map<String, dynamic> values = toValues(e);
      batch.insert(table, values);
    }
    return batch.commit(exclusive: exclusive, noResult: noResult, continueOnError: continueOnError);
  }

  @override
  Future<List<dynamic>> batchUpdate(List<T> entities, String whereClause, List<dynamic> whereArgs,
      {bool exclusive, bool noResult, bool continueOnError}) async {
    Batch batch = _database.batch();
    String table = getTable();
    for (T e in entities) {
      Map<String, dynamic> values = toValues(e);
      batch.update(table, values);
    }
    return batch.commit(exclusive: exclusive, noResult: noResult, continueOnError: continueOnError);
  }

  @override
  Future<int> delete(String whereClause, List<dynamic> whereArgs) async {
    return _database.delete(getTable(), where: whereClause, whereArgs: whereArgs);
  }

  @override
  Future<int> getInt(String columnOrExpression, String whereClause, List<dynamic> whereArgs) async {
    return await _getOne(columnOrExpression, whereClause, whereArgs);
  }

  @override
  Future<List<int>> getInts(String columnOrExpression, String whereClause, List<dynamic> whereArgs) async {
    List<Map<String, dynamic>> data = await _getMany(columnOrExpression, whereClause, whereArgs);
    if (data?.isEmpty == true) { /// 无结果
      return null;
    }
    List<int> result = [];
    for (Map<String, dynamic> map in data) {
      result.add(map[columnOrExpression]);
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getRowValues(List<String> columnsOrExpressions, String whereClause, List<dynamic> whereArgs) async {
    List<Map<String, dynamic>> data = await _database.rawQuery("SELECT $columnsOrExpressions FROM ${getTable()} WHERE $whereClause LIMIT 1", whereArgs);
    return data?.isEmpty == true ? null : data.first;
  }

  @override
  Future<String> getString(String columnOrExpression, String whereClause, List<dynamic> whereArgs) async {
    return await _getOne(columnOrExpression, whereClause, whereArgs);
  }

  @override
  Future<List<String>> getStrings(String columnOrExpression, String whereClause, List<dynamic> whereArgs) async {
    List<Map<String, dynamic>> data = await _getMany(columnOrExpression, whereClause, whereArgs);
    if (data?.isEmpty == true) { /// 无结果
      return null;
    }
    List<String> result = [];
    for (Map<String, dynamic> map in data) {
      result.add(map[columnOrExpression]);
    }
    return result;
  }

  @override
  Future<bool> has({String whereClause, List<dynamic> whereArgs}) async {
    List<Map<String, dynamic>> data = await _database.rawQuery("SELECT COUNT(1) FROM ${getTable()} WHERE $whereClause LIMIT 1", whereArgs);
    if (data?.isEmpty == true) {
      return false;
    }
    Map<String, dynamic> map = data[0];
    return map?.isNotEmpty == true;
  }

  @override
  Future<int> insert(T entity) {
    return _database.insert(getTable(), toValues(entity));
  }

  @override
  Future<int> insertOrUpdate(T entity, String whereClause, List<dynamic> whereArgs) async {
    if (await has(whereClause: whereClause, whereArgs: whereArgs)) {
      return await update(entity, whereClause, whereArgs);
    }
    return await insert(entity);
  }

  @override
  Future<T> query({String whereClause, List<dynamic> whereArgs}) async {
    List<Map<String, dynamic>> data = await _database.query(getTable(), columns: getColumns(), where: whereClause, whereArgs: whereArgs);
    if (data?.isEmpty == true) {
      return null;
    }
    Map values = data.first;
    if (values?.isEmpty == true) {
      return null;
    }
    return toEntity(values);
  }

  @override
  Future<List<T>> queryAll() async {
    return await queryMany(whereClause: null, whereArgs: null);
  }

  @override
  Future<List<T>> queryMany({String whereClause, List<dynamic> whereArgs}) async {
    List<Map<String, dynamic>> data = await _database.query(getTable(), columns: getColumns(), where: whereClause, whereArgs: whereArgs);
    if (data?.isEmpty == true) {
      return null;
    }
    List<T> result = [];
    for (Map values in data) {
      T e = toEntity(values);
      if (e != null) result.add(e);
    }
    return result;
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(String sql, List<dynamic> selectionArgs) {
    return _database.rawQuery(sql, selectionArgs);
  }

  @override
  Future<int> update(T entity, String whereClause, List<dynamic> whereArgs) {
    return _database.update(getTable(), toValues(entity), where: whereClause, whereArgs: whereArgs);
  }

  @override
  Future<int> updatePart(Map<String, dynamic> values, String whereClause, List<dynamic> whereArgs) {
    return _database.update(getTable(), values, where: whereClause, whereArgs: whereArgs);
  }

  @override
  Future<bool> exeTransaction(Future<bool> Function(Transaction txn) action, {bool exclusive}) {
    return _database.transaction<bool>(action, exclusive: exclusive);
  }

  Future<dynamic> _getOne(String columnOrExpression, String whereClause, List<dynamic> whereArgs) async {
    List<Map<String, dynamic>> result = await _database.rawQuery("SELECT $columnOrExpression FROM ${getTable()} WHERE $whereClause LIMIT 1", whereArgs);
    if (result?.isEmpty == true) { /// 无结果
      return null;
    }
    Map<String, dynamic> map = result.first;
    if (map?.isEmpty == true) { /// 无结果
      return null;
    }
    return map[columnOrExpression];
  }

  Future<List<Map<String, dynamic>>> _getMany(String columnOrExpression, String whereClause, List<dynamic> whereArgs) async {
    List<Map<String, dynamic>> data = await _database.rawQuery("SELECT $columnOrExpression FROM ${getTable()} WHERE $whereClause", whereArgs);
    return data;
  }
}