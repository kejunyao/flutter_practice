import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dao.dart';

abstract class BaseLite {
  /// 注册dao
  /// [type] dao对应的实体类型
  /// [dao] [Dao]的实现类
  void registerDao(Type type, Dao dao);

  /// 是否有记录
  /// [whereClause]：查询条件
  /// [whereArgs] 查询条件参数
  /// return：true，记录存在；false，记录不存在
  Future<bool> has({@required Type type, @required String whereClause, List<dynamic> whereArgs});

  /// 查询符合条件的某条记录
  /// [whereClause] 查询条件
  /// [whereArgs] 查询条件中的参数
  /// return 实体类
  Future<T> query<T>({@required Type type, @required String whereClause, List<dynamic> whereArgs});

  /// 查询符合条件的多条记录
  /// [whereClause] 查询条件
  /// [whereArgs] 查询条件中的参数
  /// return 符合条件的多条记录
  Future<List<T>> queryMany<T>({@required Type type, @required String whereClause, List<dynamic> whereArgs});

  /// 万能查询
  /// [sql] sql语句
  /// [selectionArgs] 条件参数
  /// return [Map]
  Future<List<Map<String, dynamic>>> rawQuery({@required Type type, @required String sql, List<dynamic> selectionArgs});

  /// 查询某实体（T）所有记录
  /// return 所有记录
  Future<List<T>> queryAll<T>(Type type);

  /// 插入实体
  /// @param entity 实体
  /// @return true, 插入成功；false，操作失败
  Future<int> insert<T>({@required Type type, @required T entity});

  /// 批量插入实体
  /// [entities] 批量实体
  /// 关于[exclusive]、[noResult]、[continueOnError]，请查看[Batch.commit]
  /// return [Batch.commit]
  Future<List<dynamic>> batchInsert<T>({@required Type type, @required List<T> entities,
    bool exclusive, bool noResult, bool continueOnError});

  /// 按条件更新实体记录
  /// [entity] 实体
  /// [whereClause] 更新条件
  /// [whereArgs] 更新条件中的参数
  /// return true，更新成功；false，更新失败
  Future<int> update<T>({@required Type type, @required T entity, @required String whereClause, List<dynamic> whereArgs});

  /// 按条件更新实体记录部分信息
  /// [values] 部分值更新
  /// [whereClause] 更新条件
  /// [whereArgs] 更新条件中的参数
  /// return true，更新成功；false，更新失败
  Future<int> updatePart({@required Type type, @required Map<String, dynamic> values,
    @required String whereClause, List<dynamic> whereArgs});

  /// 按条件批量更新
  /// [entities] 批量实体
  /// [whereClause] 更新条件
  /// [whereArgs] 更新条件中的参数
  /// return true，批量更新成功；false，批量更新失败
  Future<List<dynamic>> batchUpdate<T>({@required Type type, @required List<T> entities,
      @required String whereClause, List<dynamic> whereArgs,
      bool exclusive, bool noResult, bool continueOnError});

  /// 删除符合条件的记录
  /// [whereClause] 删除条件
  /// [whereArgs] 删除条件中的参数
  /// return，[Batch.delete]
  Future<int> delete({@required Type type, @required String whereClause, List<dynamic> whereArgs});

  /// 按条件插入或更新
  /// [entity] 实体
  /// [whereClause] 插入或更新条件
  /// [whereArgs] 插入或更新条件中的参数
  /// return 插入或更新成功；false，插入或更新失败
  Future<int> insertOrUpdate<T>({@required Type type, @required T entity,
    @required String whereClause, List<dynamic> whereArgs});

  /// 查询column值、求和（SUM(column))、最大值（MAX(column)）等等（仅一条记录）
  /// [columnOrExpression] 列名或表达式
  /// [whereClause] 查询条件
  /// [whereArgs] 查询参数
  /// return 查询结果
  Future<int> getInt({@required Type type, @required String columnOrExpression,
    @required String whereClause, List<dynamic> whereArgs});

  /// 获取行某列的文本（仅一条记录）
  /// [columnOrExpression] 列名或表达式
  /// [whereClause] 查询条件
  /// [whereArgs] 查询参数
  /// return 取行某列的文本
  Future<String> getString({@required Type type, @required String columnOrExpression,
    @required String whereClause, List<dynamic> whereArgs});

  /// 查询column值、求和（SUM(column))、最大值（MAX(column)）等等（多条记录）
  /// [columnOrExpression] 列名或表达式
  /// [whereClause] 查询条件
  /// [whereArgs] 查询参数
  /// return [columnOrExpression]对应的多个值
  Future<List<int>> getInts({@required Type type, @required String columnOrExpression,
    @required String whereClause, List<dynamic> whereArgs});

  /// 获取行某列的文本（多条记录）
  /// [columnOrExpression] 列名或表达式
  /// [whereClause] 查询条件
  /// [whereArgs] 查询参数
  /// @return 取行某列的文本
  Future<List<String>> getStrings({@required Type type, @required String columnOrExpression,
    @required String whereClause, List<dynamic> whereArgs});

  /// 获取某行数据的部分或全部值
  /// [columnsOrExpressions] 多列或多表达式
  /// [whereClause] 查询条件
  /// [whereArgs] 查询参数
  /// return [columnsOrExpressions]对应的值
  Future<Map<String, dynamic>> getRowValues({@required Type type, @required List<String> columnsOrExpressions,
    @required String whereClause, List<dynamic> whereArgs});

  /// 执行事务（非注解方式）
  /// [action] {@link Action}
  /// return true，事务执行成功；false，事务执行失败
  Future<bool> exeTransaction(Future<bool> Function(Transaction txn) action, {bool exclusive});
}