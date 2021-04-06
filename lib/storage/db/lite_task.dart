import 'dart:collection';

import 'package:flutter_practice/storage/db/lite.dart';

/// 任务执行结果回调
typedef OnLiteResult<R> = Function(R result);

/// 数据库操作任务
class RootTask<R> {

  final Type type;
  final OnLiteResult<R> onResult;

  RootTask(this.type, this.onResult);
}

/// 查询Task, [RootDao.query]
class QueryTask<R> extends RootTask<R> {
  final String whereClause;
  final List<dynamic> whereArgs;
  QueryTask(Type type, OnLiteResult<R> onResult, this.whereClause, this.whereArgs)
      : super(type, onResult);
}

/// 是否有记录Task，[RootDao.has]
class HasTask extends QueryTask<bool> {
  HasTask(Type type, OnLiteResult<bool> onResult, String whereClause, {List<dynamic> whereArgs})
      : super(type, onResult, whereClause, whereArgs);
}

/// 查询多条记录，[RootDao.queryMany]
class QueryManyTask<T> extends QueryTask<List<T>> {
  QueryManyTask(Type type, OnLiteResult<List<T>> onResult, String whereClause, {List<dynamic> whereArgs})
      : super(type, onResult, whereClause, whereArgs);
}

/// 查询所有某张表所有记录，[RootDao.queryAll]
class QueryAllTask<T> extends QueryManyTask<List<T>> {
  QueryAllTask(Type type, OnLiteResult<List<List<T>>> onResult) : super(type, onResult, null);
}

/// 完成查询，[RootDao.rawQuery]
class RawQueryTask extends RootTask<List<Map<String, dynamic>>> {
  final String sql;
  final List<dynamic> whereArgs;
  RawQueryTask(Type type, OnLiteResult<List<Map<String, dynamic>>> onResult, this.sql, this.whereArgs) : super(type, onResult);
}

/// 插入实体，[RootDao.insert]
class InsertTask<T> extends RootTask<int> {
  final T entity;
  InsertTask(Type type, OnLiteResult<int> onResult, this.entity)
      : super(type, onResult);
}

/// 批量插入实体，[RootDao.batchInsert]
class BatchInsertTask<T> extends RootTask<List<dynamic>> {
  final List<T> entities;
  final bool exclusive;
  final bool noResult;
  final bool continueOnError;
  BatchInsertTask(Type type, OnLiteResult<List> onResult, this.entities,
      {this.exclusive, this.noResult, this.continueOnError})
      : super(type, onResult);
}

/// 按条件更新实体记录部分信息, [RootDao.batchInsert]
class UpdatePart extends QueryTask<int> {
  final Map<String, dynamic> values;
  UpdatePart(Type type, OnLiteResult<int> onResult, this.values,
      String whereClause, {List<dynamic> whereArgs})
      : super(type, onResult, whereClause, whereArgs);
}

/// 按条件更新实体记录, [RootDao.update]
class UpdateTask<T> extends QueryTask<int> {
  final T entity;
  UpdateTask(Type type, OnLiteResult<int> onResult, this.entity,
      String whereClause, {List<dynamic> whereArgs})
      : super(type, onResult, whereClause, whereArgs);
}

/// 按条件批量更新, [RootDao.batchUpdate]
class BatchUpdateTask<T> extends RootTask<List<dynamic>> {
  final List<T> entities;
  final String primaryKey;
  final bool exclusive;
  final bool noResult;
  final bool continueOnError;
  BatchUpdateTask(Type type, OnLiteResult<List> onResult,
  this.entities, this.primaryKey, {this.exclusive, this.noResult, this.continueOnError})
      : super(type, onResult);
}

/// 删除符合条件的记录，[RootDao.delete]
class DeleteTask extends QueryTask<int> {
  DeleteTask(Type type, OnLiteResult<int> onResult, String whereClause, {List<dynamic> whereArgs})
      : super(type, onResult, whereClause, whereArgs);
}

/// 按条件插入或更新, [RootDao.insertOrUpdate]
class InsertOrUpdate<T> extends QueryTask<int> {
  final T entity;
  InsertOrUpdate(Type type, OnLiteResult<int> onResult,
      this.entity, String whereClause, {List<dynamic> whereArgs})
      : super(type, onResult, whereClause, whereArgs);
}

/// 与部分查询相关的Task基类
class GetTask<R> extends QueryTask<R> {
  final String columnOrExpression;
  GetTask(Type type, OnLiteResult<R> onResult,
      this.columnOrExpression, String whereClause, List<dynamic> whereArgs)
      : super(type, onResult, whereClause, whereArgs);
}

/// 查询column值、求和（SUM(column))、最大值（MAX(column)）等等（仅一条记录）, [RootDao.getInt]
class GetIntTask extends GetTask<int> {
  GetIntTask(Type type, OnLiteResult<int> onResult,
      String columnOrExpression, String whereClause, {List<dynamic> whereArgs})
      : super(type, onResult, columnOrExpression, whereClause, whereArgs);
}

/// 获取行某列的文本（仅一条记录）, [RootDao.getString]
class GetString extends GetTask<String> {
  GetString(Type type, OnLiteResult<String> onResult,
      String columnOrExpression, String whereClause, {List<dynamic> whereArgs})
      : super(type, onResult, columnOrExpression, whereClause, whereArgs);
}

/// 查询column值、求和（SUM(column))、最大值（MAX(column)）等等（多条记录）, [RootDao.getInts]
class GetIntsTask extends GetTask<List<int>> {
  GetIntsTask(Type type, OnLiteResult<List<int>> onResult,
      String columnOrExpression, String whereClause, {List<dynamic> whereArgs})
      : super(type, onResult, columnOrExpression, whereClause, whereArgs);
}

/// 获取行某列的文本（多条记录）, [RootDao.getStrings]
class GetStringsTask extends GetTask<List<String>> {
  GetStringsTask(Type type, OnLiteResult<List<String>> onResult,
      String columnOrExpression, String whereClause, {List<dynamic> whereArgs})
      : super(type, onResult, columnOrExpression, whereClause, whereArgs);
}

/// 获取某行数据的部分或全部值, [RootDao.getRowValues]
class GetRowValuesTask extends QueryTask<Map<String, dynamic>> {
  final List<String> columnsOrExpressions;
  GetRowValuesTask(Type type, OnLiteResult<Map<String, dynamic>> onResult,
      this.columnsOrExpressions, String whereClause, List whereArgs)
      : super(type, onResult, whereClause, whereArgs);
}

/// 数据库操作任务执行器
class TaskExecutor {
  /// 任务队列缓存池
  ///
  /// 任务采用双链表实现的队列存储，主要有以下考虑：
  ///
  /// 1、链表内存是动态分配的，因数组内存大小固定，涉及到扩容，会影响性能；
  ///
  /// 2、链表的缺陷是查找，而在这里，任务从表头加入，从表尾消费（移除），不仅保证顺序，还不会影响查找性能；
  Queue<RootTask> _tasks = DoubleLinkedQueue();

  final Lite lite;
  TaskExecutor(this.lite);

  /// 任务进入队列
  void enqueue<R>(RootTask<R> task) {
    _tasks.addFirst(task);
  }

  /// 执行任务
  void execute() {
    while (_tasks.isNotEmpty) {
      _executeTask();
    }
  }

  void _executeTask() async {
    RootTask task = _tasks.removeLast();
    if (task is HasTask) {
      bool result = await lite.has(task.type, task.whereClause, whereArgs: task.whereArgs);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is QueryManyTask) {
      List result = await lite.queryMany(task.type, task.whereClause, whereArgs: task.whereArgs);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is RawQueryTask) {
      List<Map<String, dynamic>> result = await lite.rawQuery(task.type, task.sql, whereArgs: task.whereArgs);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is InsertTask) {
      int result = await lite.insert(task.type, task.entity);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is QueryAllTask) {
      List result = await lite.queryAll(task.type);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is BatchInsertTask) {
      List<dynamic> result = await lite.batchInsert(task.type, task.entities, exclusive: task.exclusive, noResult: task.noResult, continueOnError: task.continueOnError);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is UpdateTask) {
      int result = await lite.update(task.runtimeType, task.entity, task.whereClause, whereArgs: task.whereArgs);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is UpdatePart) {
      int result = await lite.updatePart(task.type, task.values, task.whereClause, whereArgs: task.whereArgs);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is BatchUpdateTask) {
      List<dynamic> result = await lite.batchUpdate(task.type, task.entities, task.primaryKey,
          exclusive: task.exclusive, noResult: task.noResult, continueOnError: task.continueOnError);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is DeleteTask) {
      int result = await lite.delete(task.type, task.whereClause, whereArgs: task.whereArgs);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is InsertOrUpdate) {
      int result = await lite.insertOrUpdate(task.type, task.entity, task.whereClause, whereArgs: task.whereArgs);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is GetIntTask) {
      int result = await lite.getInt(task.type, task.columnOrExpression, task.whereClause, whereArgs: task.whereArgs);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is GetString) {
      String result = await lite.getString(task.type, task.columnOrExpression, task.whereClause, whereArgs: task.whereArgs);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is GetIntsTask) {
      List<int> result = await lite.getInts(task.type, task.columnOrExpression, task.whereClause, whereArgs: task.whereArgs);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is GetStringsTask) {
      List<String> result = await lite.getStrings(task.type, task.columnOrExpression, task.whereClause, whereArgs: task.whereArgs);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is GetRowValuesTask) {
      Map<String, dynamic> result = await lite.getRowValues(task.type, task.columnsOrExpressions, task.whereClause, whereArgs: task.whereArgs);
      if (task.onResult != null) task.onResult(result);
      return;
    }
    if (task is QueryTask) {
      dynamic result = await lite.query(task.type, task.whereClause, whereArgs: task.whereArgs);
      if (task.onResult != null) task.onResult(result);
      return;
    } else {
      /// 无法识别的Task
    }
  }
}