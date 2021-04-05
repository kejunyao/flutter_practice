import 'package:flutter_practice/storage/db/database.dart';
import 'package:flutter_practice/storage/db/table_column.dart';
import 'dao.dart';

/// 数据库表所有操作Base实现
abstract class BaseDao<T> implements Dao<T> {

  RootDatabase _database;
  final List<String> _columns = [];
  BaseDao() {
    columns?.forEach((e) {
      _columns.add(e.name);
    });
  }

  set dao(RootDatabase database) {
    _database = database;
  }

  String get table;

  List<TableColumn> get columns;

  T toEntity(Map<String, dynamic> map);

  Map<String, dynamic> toValues(T entity);

  @override
  Future<List<dynamic>> batchInsert(List<T> entities,
      {bool exclusive, bool noResult, bool continueOnError}) async {
    RootBatch batch = _database.batch();
    String table = this.table;
    entities.forEach((element) {
      Map<String, dynamic> values = toValues(element);
      batch.insert(table, values);
    });
    return await batch.commit(exclusive: exclusive, noResult: noResult, continueOnError: continueOnError);
  }

  @override
  Future<List<dynamic>> batchUpdate(List<T> entities, String primaryKey,
      {bool exclusive, bool noResult, bool continueOnError}) async {
    RootBatch batch = _database.batch();
    String table = this.table;
    entities?.forEach((e) {
      Map<String, dynamic> values = toValues(e);
      batch.update(table, values, '$primaryKey = ?', whereArgs: [values[primaryKey]]);
    });
    return batch.commit(exclusive: exclusive, noResult: noResult, continueOnError: continueOnError);
  }

  @override
  Future<int> delete(String whereClause, {List<dynamic> whereArgs}) async {
    return _database.delete(this.table, where: whereClause, whereArgs: whereArgs);
  }

  @override
  Future<int> getInt(String columnOrExpression, String whereClause, {List<dynamic> whereArgs}) async {
    return await _getOne(columnOrExpression, whereClause, whereArgs: whereArgs);
  }

  @override
  Future<List<int>> getInts(String columnOrExpression, String whereClause, {List<dynamic> whereArgs}) async {
    List<Map<String, dynamic>> data = await _getMany(columnOrExpression, whereClause, whereArgs: whereArgs);
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
  Future<Map<String, dynamic>> getRowValues(List<String> columnsOrExpressions, String whereClause, {List<dynamic> whereArgs}) async {
    List<Map<String, dynamic>> data = await _database.query(table, columns: columnsOrExpressions, where: whereClause, whereArgs: whereArgs, limit: 1);
    return data?.isEmpty == true ? null : data.first;
  }

  @override
  Future<String> getString(String columnOrExpression, String whereClause, {List<dynamic> whereArgs}) async {
    return await _getOne(columnOrExpression, whereClause, whereArgs: whereArgs);
  }

  @override
  Future<List<String>> getStrings(String columnOrExpression, String whereClause, {List<dynamic> whereArgs}) async {
    List<Map<String, dynamic>> data = await _getMany(columnOrExpression, whereClause, whereArgs: whereArgs);
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
  Future<bool> has(String whereClause, {List<dynamic> whereArgs}) async {
    List<Map<String, dynamic>> data = await _database.rawQuery("SELECT COUNT(*) AS _count FROM ${this.table} WHERE $whereClause LIMIT 1", whereArgs);
    return (data?.first['_count'] ?? 0) > 0;
  }

  @override
  Future<int> insert(T entity) {
    return _database.insert(this.table, toValues(entity));
  }

  @override
  Future<int> insertOrUpdate(T entity, String whereClause, {List<dynamic> whereArgs}) async {
    if (await has(whereClause, whereArgs: whereArgs)) {
      return await update(entity, whereClause, whereArgs: whereArgs);
    }
    return await insert(entity);
  }

  @override
  Future<T> query(String whereClause, {List<dynamic> whereArgs}) async {
    List<Map<String, dynamic>> data = await _database.query(this.table, columns: _columns, where: whereClause, whereArgs: whereArgs);
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
    return await queryMany(null, whereArgs: null);
  }

  @override
  Future<List<T>> queryMany(String whereClause, {List<dynamic> whereArgs}) async {
    List<Map<String, dynamic>> data = await _database.query(this.table, columns: _columns, where: whereClause, whereArgs: whereArgs);
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
  Future<List<Map<String, dynamic>>> rawQuery(String sql, {List<dynamic> whereArgs}) {
    return _database.rawQuery(sql, whereArgs);
  }

  @override
  Future<int> update(T entity, String whereClause, {List<dynamic> whereArgs}) {
    return _database.update(this.table, toValues(entity), where: whereClause, whereArgs: whereArgs);
  }

  @override
  Future<int> updatePart(Map<String, dynamic> values, String whereClause, {List<dynamic> whereArgs}) {
    return _database.update(this.table, values, where: whereClause, whereArgs: whereArgs);
  }

  Future<dynamic> _getOne(String columnOrExpression, String whereClause, {List<dynamic> whereArgs}) async {
    List<Map<String, dynamic>> result = await _database.rawQuery("SELECT $columnOrExpression FROM ${this.table} WHERE $whereClause LIMIT 1", whereArgs);
    if (result?.isEmpty == true) { /// 无结果
      return null;
    }
    Map<String, dynamic> map = result.first;
    if (map?.isEmpty == true) { /// 无结果
      return null;
    }
    return map[columnOrExpression];
  }

  Future<List<Map<String, dynamic>>> _getMany(String columnOrExpression, String whereClause, {List<dynamic> whereArgs}) async {
    List<Map<String, dynamic>> data = await _database.rawQuery("SELECT $columnOrExpression FROM ${this.table} WHERE $whereClause", whereArgs);
    return data;
  }

}