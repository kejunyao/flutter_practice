import 'dart:collection';

import 'package:flutter_practice/storage/db/lite.dart';

/// 任务执行结果回调
abstract class LiteResultCallback<R> {
  void onResult(R result);
}

/// 数据库操作任务
class RootTask<R> {

  final Type type;
  final LiteResultCallback<R> resultCallback;

  RootTask(this.type, this.resultCallback);
}

/// 查询Task, [RootDao.query]
class QueryTask<R> extends RootTask<R> {
  final String whereClause;
  final List<dynamic> whereArgs;
  QueryTask(Type type, LiteResultCallback<R> resultCallback, this.whereClause, this.whereArgs)
      : super(type, resultCallback);
}

/// 是否有记录Task，[RootDao.has]
class HasTask extends QueryTask<bool> {
  HasTask(Type type, LiteResultCallback<bool> resultCallback, String whereClause, {List<dynamic> whereArgs})
      : super(type, resultCallback, whereClause, whereArgs);
}

/// 查询多条记录，[RootDao.queryMany]
class QueryManyTask<T> extends QueryTask<List<T>> {
  QueryManyTask(Type type, LiteResultCallback<List<T>> resultCallback, String whereClause, {List<dynamic> whereArgs})
      : super(type, resultCallback, whereClause, whereArgs);
}

/// 查询所有某张表所有记录，[RootDao.queryAll]
class QueryAllTask<T> extends QueryManyTask<List<T>> {
  QueryAllTask(Type type, LiteResultCallback<List<List<T>>> resultCallback, String whereClause) : super(type, resultCallback, whereClause);
}

/// 完成查询，[RootDao.rawQuery]
class RawQueryTask extends RootTask<Map<String, dynamic>> {
  final String sql;
  final List<dynamic> whereArgs;
  RawQueryTask(Type type, LiteResultCallback<Map<String, dynamic>> resultCallback, this.sql, this.whereArgs) : super(type, resultCallback);

}

/// 插入实体，[RootDao.insert]
class InsertTask<T> extends RootTask<int> {
  final T entity;
  InsertTask(Type type, LiteResultCallback<int> resultCallback, this.entity)
      : super(type, resultCallback);
}

/// 批量插入实体，[RootDao.batchInsert]
class BatchInsertTask<T> extends RootTask<List<dynamic>> {
  final List<T> entities;
  final bool exclusive;
  final bool noResult;
  final bool continueOnError;
  BatchInsertTask(Type type, LiteResultCallback<List> resultCallback, this.entities,
      {this.exclusive, this.noResult, this.continueOnError})
      : super(type, resultCallback);
}

/// 按条件更新实体记录部分信息, [RootDao.batchInsert]
class UpdatePart extends QueryTask<int> {
  final Map<String, dynamic> values;
  UpdatePart(Type type, LiteResultCallback<int> resultCallback, this.values,
      String whereClause, {List<dynamic> whereArgs})
      : super(type, resultCallback, whereClause, whereArgs);
}

/// 按条件更新实体记录, [RootDao.update]
class UpdateTask<T> extends QueryTask<int> {
  final T entity;
  UpdateTask(Type type, LiteResultCallback<int> resultCallback, this.entity,
      String whereClause, {List<dynamic> whereArgs})
      : super(type, resultCallback, whereClause, whereArgs);
}

/// 按条件批量更新, [RootDao.batchUpdate]
class BatchUpdateTask<T> extends QueryTask<List<dynamic>> {
  final List<T> entities;
  final bool exclusive;
  final bool noResult;
  final bool continueOnError;
  BatchUpdateTask(Type type, LiteResultCallback<List<List>> resultCallback,
      this.entities, String whereClause,
      {List<dynamic> whereArgs, this.exclusive, this.noResult, this.continueOnError})
      : super(type, resultCallback, whereClause, whereArgs);
}

/// 删除符合条件的记录，[RootDao.delete]
class DeleteTask extends QueryTask<int> {
  DeleteTask(Type type, LiteResultCallback<int> resultCallback, String whereClause, {List<dynamic> whereArgs})
      : super(type, resultCallback, whereClause, whereArgs);
}

/// 按条件插入或更新, [RootDao.insertOrUpdate]
class InsertOrUpdate<T> extends QueryTask<int> {
  final T entity;
  InsertOrUpdate(Type type, LiteResultCallback<int> resultCallback,
      this.entity, String whereClause, {List<dynamic> whereArgs})
      : super(type, resultCallback, whereClause, whereArgs);
}

/// 与部分查询相关的Task基类
class GetTask<R> extends QueryTask<R> {
  final String columnOrExpression;
  GetTask(Type type, LiteResultCallback<R> resultCallback,
      this.columnOrExpression, String whereClause, List<dynamic> whereArgs)
      : super(type, resultCallback, whereClause, whereArgs);
}

/// 查询column值、求和（SUM(column))、最大值（MAX(column)）等等（仅一条记录）, [RootDao.getInt]
class GetIntTask extends GetTask<int> {
  GetIntTask(Type type, LiteResultCallback<int> resultCallback,
      String columnOrExpression, String whereClause, {List<dynamic> whereArgs})
      : super(type, resultCallback, columnOrExpression, whereClause, whereArgs);
}

/// 获取行某列的文本（仅一条记录）, [RootDao.getString]
class GetString extends GetTask<String> {
  GetString(Type type, LiteResultCallback<String> resultCallback,
      String columnOrExpression, String whereClause, {List<dynamic> whereArgs})
      : super(type, resultCallback, columnOrExpression, whereClause, whereArgs);
}

/// 查询column值、求和（SUM(column))、最大值（MAX(column)）等等（多条记录）, [RootDao.getInts]
class GetIntsTask extends GetTask<List<int>> {
  GetIntsTask(Type type, LiteResultCallback<List<int>> resultCallback,
      String columnOrExpression, String whereClause, {List<dynamic> whereArgs})
      : super(type, resultCallback, columnOrExpression, whereClause, whereArgs);
}

/// 获取行某列的文本（多条记录）, [RootDao.getStrings]
class GetStringsTask extends GetTask<List<String>> {
  GetStringsTask(Type type, LiteResultCallback<List<String>> resultCallback,
      String columnOrExpression, String whereClause, {List<dynamic> whereArgs})
      : super(type, resultCallback, columnOrExpression, whereClause, whereArgs);
}

/// 获取某行数据的部分或全部值, [RootDao.getRowValues]
class GetRowValuesTask extends QueryTask<Map<String, dynamic>> {
  final List<String> columnsOrExpressions;
  GetRowValuesTask(Type type, LiteResultCallback<Map<String, dynamic>> resultCallback,
      this.columnsOrExpressions, String whereClause, List whereArgs)
      : super(type, resultCallback, whereClause, whereArgs);
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
    var result;
    if (task is HasTask) {
      result = await lite.has(task.type, task.whereClause, whereArgs: task.whereArgs);
    } else if (task is QueryManyTask) {
      result = await lite.queryMany(task.type, task.whereClause, whereArgs: task.whereArgs);
    } else if (task is RawQueryTask) {
      result = await lite.rawQuery(task.type, task.sql, whereArgs: task.whereArgs);
    } else if (task is InsertTask) {
      result = await lite.insert(task.type, task.entity);
    } else if (task is QueryAllTask) {
      result = await lite.queryAll(task.type);
    } else if (task is BatchInsertTask) {
      result = await lite.batchInsert(task.type, task.entities, exclusive: task.exclusive, noResult: task.noResult, continueOnError: task.continueOnError);
    } else if (task is UpdateTask) {
      result = await lite.update(task.runtimeType, task.entity, task.whereClause, whereArgs: task.whereArgs);
    } else if (task is UpdatePart) {
      result = await lite.updatePart(task.type, task.values, task.whereClause, whereArgs: task.whereArgs);
    } else if (task is BatchUpdateTask) {
      result = await lite.batchUpdate(task.type, task.entities, task.whereClause, whereArgs: task.whereArgs,
          exclusive: task.exclusive, noResult: task.noResult, continueOnError: task.continueOnError);
    } else if (task is DeleteTask) {
      result = await lite.delete(task.type, task.whereClause, whereArgs: task.whereArgs);
    } else if (task is InsertOrUpdate) {
      result = await lite.insertOrUpdate(task.type, task.entity, task.whereClause, whereArgs: task.whereArgs);
    } else if (task is GetIntTask) {
      result = await lite.getInt(task.type, task.columnOrExpression, task.whereClause, whereArgs: task.whereArgs);
    } else if (task is GetString) {
      result = await lite.getString(task.type, task.columnOrExpression, task.whereClause, whereArgs: task.whereArgs);
    } else if (task is GetIntsTask) {
      result = await lite.getInts(task.type, task.columnOrExpression, task.whereClause, whereArgs: task.whereArgs);
    } else if (task is GetStringsTask) {
      result = await lite.getStrings(task.type, task.columnOrExpression, task.whereClause, whereArgs: task.whereArgs);
    } else if (task is GetRowValuesTask) {
      result = await lite.getRowValues(task.type, task.columnsOrExpressions, task.whereClause, whereArgs: task.whereArgs);
    } else if (task is QueryTask) {
      result = await lite.query(task.type, task.whereClause, whereArgs: task.whereArgs);
    } else {
      /// 无法识别的Task
    }
    if (task.resultCallback != null) task.resultCallback.onResult(result);
  }
}