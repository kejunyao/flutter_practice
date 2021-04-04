import 'package:sqflite/sqflite.dart';

/// Database最顶层协议类
///
/// 定义此数据库协议，有如下考虑：
///
/// 1、目前数据库实现，是对sqflite库进行封装的，sqflite详情请参考：https://pub.dev/packages/sqflite；
///
/// 2、如果后期想改为其他库，为了解耦，故定义[Database]解决此问题。
///
/// 额外说明：因翻译水平有限，以下英文注释，直接拷贝sqflite。
abstract class RootDatabase implements RootDatabaseExecutor {
  /// The path of the database
  String get path;

  /// Close the database. Cannot be accessed anymore
  Future<void> close();

  /// Calls in action must only be done using the transaction object
  /// using the database will trigger a dead-lock
  Future<T> transaction<T>(Future<T> action(Transaction txn), {bool exclusive});

  ///
  /// Get the database inner version
  ///
  Future<int> getVersion();

  /// Tell if the database is open, returns false once close has been called
  bool get isOpen;
}

///
/// A batch is used to perform multiple operation as a single atomic unit.
/// A Batch object can be acquired by calling [Database.batch]. It provides
/// methods for adding operation. None of the operation will be
/// executed (or visible locally) until commit() is called.
///
abstract class RootBatch {
  /// Commits all of the operations in this batch as a single atomic unit
  /// The result is a list of the result of each operation in the same order
  /// if [noResult] is true, the result list is empty (i.e. the id inserted
  /// the count of item changed is not returned.
  ///
  /// The batch is stopped if any operation failed
  /// If [continueOnError] is true, all the operations in the batch are executed
  /// and the failure are ignored (i.e. the result for the given operation will
  /// be a DatabaseException)
  ///
  /// During [Database.onCreate], [Database.onUpgrade], [Database.onDowngrade]
  /// (we are already in a transaction) or if the batch was created in a
  /// transaction it will only be commited when
  /// the transaction is commited ([exclusive] is not used then)
  Future<List<dynamic>> commit({bool exclusive, bool noResult, bool continueOnError});

  void update(String table, Map<String, dynamic> values, String where, {List<dynamic> whereArgs});

  void insert(String table, Map<String, dynamic> values, {String nullColumnHack});
}

///
/// Common API for [Database] and [Transaction] to execute SQL commands
///
abstract class RootDatabaseExecutor {
  /// Execute an SQL query with no return value
  Future<void> execute(String sql, [List<dynamic> arguments]);

  /// Execute a raw SQL INSERT query
  ///
  /// Returns the last inserted record id
  Future<int> rawInsert(String sql, [List<dynamic> arguments]);

  // INSERT helper
  Future<int> insert(String table, Map<String, dynamic> values, {String nullColumnHack});

  /// Helper to query a table
  ///
  /// @param distinct true if you want each row to be unique, false otherwise.
  /// @param table The table names to compile the query against.
  /// @param columns A list of which columns to return. Passing null will
  ///            return all columns, which is discouraged to prevent reading
  ///            data from storage that isn't going to be used.
  /// @param where A filter declaring which rows to return, formatted as an SQL
  ///            WHERE clause (excluding the WHERE itself). Passing null will
  ///            return all rows for the given URL.
  /// @param groupBy A filter declaring how to group rows, formatted as an SQL
  ///            GROUP BY clause (excluding the GROUP BY itself). Passing null
  ///            will cause the rows to not be grouped.
  /// @param having A filter declare which row groups to include in the cursor,
  ///            if row grouping is being used, formatted as an SQL HAVING
  ///            clause (excluding the HAVING itself). Passing null will cause
  ///            all row groups to be included, and is required when row
  ///            grouping is not being used.
  /// @param orderBy How to order the rows, formatted as an SQL ORDER BY clause
  ///            (excluding the ORDER BY itself). Passing null will use the
  ///            default sort order, which may be unordered.
  /// @param limit Limits the number of rows returned by the query,
  /// @param offset starting index,

  /// @return the items found
  Future<List<Map<String, dynamic>>> query(String table,
      {bool distinct,
        List<String> columns,
        String where,
        List<dynamic> whereArgs,
        String groupBy,
        String having,
        String orderBy,
        int limit,
        int offset});

  /// Execute a raw SQL SELECT query
  ///
  /// Returns a list of rows that were found
  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<dynamic> arguments]);

  /// Execute a raw SQL UPDATE query
  ///
  /// Returns the number of changes made
  Future<int> rawUpdate(String sql, [List<dynamic> arguments]);

  /// Convenience method for updating rows in the database.
  ///
  /// Update [table] with [values], a map from column names to new column
  /// values. null is a valid value that will be translated to NULL.
  ///
  /// [where] is the optional WHERE clause to apply when updating.
  /// Passing null will update all rows.
  ///
  /// You may include ?s in the where clause, which will be replaced by the
  /// values from [whereArgs]
  ///
  /// [conflictAlgorithm] (optional) specifies algorithm to use in case of a
  /// conflict. See [ConflictResolver] docs for more details
  Future<int> update(String table, Map<String, dynamic> values,
      {String where,
        List<dynamic> whereArgs});

  /// Executes a raw SQL DELETE query
  ///
  /// Returns the number of changes made
  Future<int> rawDelete(String sql, [List<dynamic> arguments]);

  /// Convenience method for deleting rows in the database.
  ///
  /// Delete from [table]
  ///
  /// [where] is the optional WHERE clause to apply when updating. Passing null
  /// will update all rows.
  ///
  /// You may include ?s in the where clause, which will be replaced by the
  /// values from [whereArgs]
  ///
  /// [conflictAlgorithm] (optional) specifies algorithm to use in case of a
  /// conflict. See [ConflictResolver] docs for more details
  ///
  /// Returns the number of rows affected if a whereClause is passed in, 0
  /// otherwise. To remove all rows and get a count pass "1" as the
  /// whereClause.
  Future<int> delete(String table, {String where, List<dynamic> whereArgs});

  /// Creates a batch, used for performing multiple operation
  /// in a single atomic operation.
  ///
  /// a batch can be commited using [Batch.commit]
  ///
  /// If the batch was created in a transaction, it will be commited
  /// when the transaction is done
  RootBatch batch();
}