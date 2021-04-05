import 'package:flutter/material.dart';
import 'package:flutter_practice/storage/db/lite_task.dart';
import 'package:sqflite/sqflite.dart';
import 'dao.dart';

/// 数据库所有操作最顶层基类
abstract class Lite {
  /// 注册dao
  ///
  /// [type] dao对应的实体类型
  ///
  /// [dao] [Dao]的实现类
  void registerDao(Type type, Dao dao);

  /// 设置debug
  ///
  /// [debug] true，开启debug模式；false，关闭debug模式
  ///
  /// [tag] 日志过滤tag
  void setDebug({@required bool debug, String tag});

  /// 初始化数据库
  void init();

  /// 是否有记录
  /// [type]实体类型
  /// [whereClause] 查询条件
  /// [whereArgs] 查询条件参数
  /// return：true，记录存在；false，记录不存在
  Future<bool> has(Type type, String whereClause, {List<dynamic> whereArgs});

  /// 查询符合条件的某条记录
  /// [type]实体类型
  /// [whereClause] 查询条件
  /// [whereArgs] 查询条件中的参数
  /// return 实体类
  Future<T> query<T>(Type type, String whereClause, {List<dynamic> whereArgs});

  /// 查询符合条件的多条记录
  /// [type]实体类型
  /// [whereClause] 查询条件
  /// [whereArgs] 查询条件中的参数
  /// return 符合条件的多条记录
  Future<List<T>> queryMany<T>(Type type, String whereClause, {List<dynamic> whereArgs});

  /// 万能查询
  /// [type]实体类型
  /// [sql] sql语句
  /// [selectionArgs] 条件参数
  /// return [Map]
  Future<List<Map<String, dynamic>>> rawQuery(Type type, String sql, {List<dynamic> whereArgs});

  /// 查询某实体（T）所有记录
  /// [type]实体类型
  /// return 所有记录
  Future<List<T>> queryAll<T>(Type type);

  /// 插入实体
  /// @param entity 实体
  /// @return true, 插入成功；false，操作失败
  Future<int> insert<T>(Type type, T entity);

  /// 批量插入实体
  /// [type]实体类型
  /// [entities] 批量实体
  /// 关于[exclusive]、[noResult]、[continueOnError]，请查看[Batch.commit]
  /// return [Batch.commit]
  Future<List<dynamic>> batchInsert<T>(Type type, List<T> entities,
      {bool exclusive, bool noResult, bool continueOnError});

  /// 按条件更新实体记录
  /// [type]实体类型
  /// [entity] 实体
  /// [whereClause] 更新条件
  /// [whereArgs] 更新条件中的参数
  /// return true，更新成功；false，更新失败
  Future<int> update<T>(Type type, T entity, String whereClause, {List<dynamic> whereArgs});

  /// 按条件更新实体记录部分信息
  /// [type]实体类型
  /// [values] 部分值更新
  /// [whereClause] 更新条件
  /// [whereArgs] 更新条件中的参数
  /// return true，更新成功；false，更新失败
  Future<int> updatePart(Type type, Map<String, dynamic> values,
    String whereClause, {List<dynamic> whereArgs});

  /// 按条件批量更新
  /// [type]实体类型
  /// [entities] 批量实体
  /// [primaryKey]主键
  /// return true，批量更新成功；false，批量更新失败
  Future<List<dynamic>> batchUpdate<T>(Type type, List<T> entities, String primaryKey,
      {bool exclusive, bool noResult, bool continueOnError});

  /// 删除符合条件的记录
  /// [type]实体类型
  /// [whereClause] 删除条件
  /// [whereArgs] 删除条件中的参数
  /// return，[Batch.delete]
  Future<int> delete(Type type, String whereClause, {List<dynamic> whereArgs});

  /// 删除表中所有的记录
  /// [type]实体类型
  Future<int> deleteAll(Type type);

  /// 按条件插入或更新
  /// [type]实体类型
  /// [entity] 实体
  /// [whereClause] 插入或更新条件
  /// [whereArgs] 插入或更新条件中的参数
  /// return 插入或更新成功；false，插入或更新失败
  Future<int> insertOrUpdate<T>(Type type, T entity, String whereClause, {List<dynamic> whereArgs});

  /// 查询column值、求和（SUM(column))、最大值（MAX(column)）等等（仅一条记录）
  /// [type]实体类型
  /// [columnOrExpression] 列名或表达式
  /// [whereClause] 查询条件
  /// [whereArgs] 查询参数
  /// return 查询结果
  Future<int> getInt(Type type, String columnOrExpression, String whereClause, {List<dynamic> whereArgs});

  /// 获取行某列的文本（仅一条记录）
  /// [type]实体类型
  /// [columnOrExpression] 列名或表达式
  /// [whereClause] 查询条件
  /// [whereArgs] 查询参数
  /// return 取行某列的文本
  Future<String> getString(Type type, String columnOrExpression, String whereClause, {List<dynamic> whereArgs});

  /// 查询column值、求和（SUM(column))、最大值（MAX(column)）等等（多条记录）
  /// [type]实体类型
  /// [columnOrExpression] 列名或表达式
  /// [whereClause] 查询条件
  /// [whereArgs] 查询参数
  /// return [columnOrExpression]对应的多个值
  Future<List<int>> getInts(Type type, String columnOrExpression, String whereClause, {List<dynamic> whereArgs});

  /// 获取行某列的文本（多条记录）
  /// [type]实体类型
  /// [columnOrExpression] 列名或表达式
  /// [whereClause] 查询条件
  /// [whereArgs] 查询参数
  /// @return 取行某列的文本
  Future<List<String>> getStrings(Type type, String columnOrExpression, String whereClause, {List<dynamic> whereArgs});

  /// 获取某行数据的部分或全部值
  /// [type]实体类型
  /// [columnsOrExpressions] 多列或多表达式
  /// [whereClause] 查询条件
  /// [whereArgs] 查询参数
  /// return [columnsOrExpressions]对应的值
  Future<Map<String, dynamic>> getRowValues(Type type, List<String> columnsOrExpressions, String whereClause, {List<dynamic> whereArgs});

  /// 事务操作
  Future<bool> exeTransaction(Future<bool> Function(Transaction txn) action, {bool exclusive});

  /// 安全执行数据库操作任务，提供本方法的考虑原因如下：
  ///
  /// 1、数据库在首次初始化时，要创建数据库文件；在非首次初始化时，要进行数据库文件更新操作；这些操作都是耗时操作；
  ///
  /// 2、假如数据库初始化还未完成，此时要对表进行增、删、改、查操作，势必会有问题；
  ///
  /// 3、出于对第2条的考虑，提供本方法以保证操作的有效性；
  ///
  /// 4、本方法的实现原理：
  ///
  /// 4.1、当执行到本方法，先将执行任务加入到执行队列；判断数据库是否已初始化完毕，若是，则直接执行任务队列中的任务；若否，请看4.2；
  ///
  /// 4.2、在数据库初始化完毕后，即在init方法中，会触发接执行任务队列中的任务。
  void executeSafely(RootTask task);
}