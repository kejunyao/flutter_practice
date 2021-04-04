import 'dart:core';
import 'package:flutter_practice/storage/db/base_dao.dart';
import 'package:flutter_practice/storage/db/database.dart';
import 'package:flutter_practice/storage/db/table_column.dart';
import 'log.dart';

/// 数据库表
class TableBuilder {

  /// 创建数据库表
  Future<bool> createTable(RootDatabase db, BaseDao dao, {bool debug = false, String tag = Log.TAG}) async {
    String table = dao.getTable();
    String sql = buildCreateTableSql(table, dao.getColumns());
    try {
      await db.execute(sql);
      if (debug) {
        Log.dSingle("$table表创建成功: $sql", currClass: this, tag: tag);
      }
    } catch (e) {
      if (debug) throw e;
    }
    return true;
  }

  /// 检查某张表结构完成性
  Future<bool> checkTableIntegrity(RootDatabase db, Map<String, List<String>> tables, BaseDao dao,
      {bool debug = false, String tag = Log.TAG}) async {
    /// 目前需要的字段
    List<TableColumn> tbColumns = dao.getColumns();
    String table = dao.getTable();
    if (tables.containsKey(table)) {
      /// 数据库中已有的字段
      List<String> columns = tables[table];
      tbColumns.forEach((e) async {
          /// 字段比对需要特别说明：
          /// 1、这里考虑到性能，只做简单比对；
          /// 2、字段的比对严谨的做法是，name，type、约束、大小、是否为主键都比较；如果name相同，而其他属性不同，说明字段有更新，此时需要做更新处理；
          /// 3、关于字段更新处理，开发者可以给Lite设置数据库版本监听callback，在callback中进行更新，这里出于性能考虑，只对没有的字段进行添加处理。
          if (columns.contains(e.name)) {
            /// 字段已存在
            if (debug) Log.dSingle('$table.${e.name}已存在!', tag: tag);
          } else {
            String sql = e.buildAddColumnSql(table);
            try {
              await db.execute(sql);
              if (debug) Log.dSingle('$table.${e.name}字段新增成功!', tag: tag);
            } catch(e) {
              if (debug) throw e;
            }
          }
      });
      return true;
    }
    await createTable(db, dao, debug: debug, tag: tag);
    return true;
  }

  /// 查找数据库中所有的表
  Future<Map<String, List<String>>> findTables(RootDatabase db,
      {bool debug = false, String tag = Log.TAG}) async {
    List<Map<String, dynamic>> data = await db.rawQuery(
        "SELECT name, sql FROM sqlite_master WHERE type = ?",
        ['table']
    );
    Map<String, List<String>> tables = {};
    data?.forEach((map) {
      String table = map['name'];
      String sql = map['sql'];
      if (table?.isNotEmpty == true) {
        tables[table] = _toColumns(sql);
      }
      if (debug) Log.dSingle('findTables, table: $table, sql: $sql, columns: ${tables[table]}');
    });
    return tables;
  }

  List<String> _toColumns(String sql) {
    final List<String> columns = [];
    List<String> array = sql?.substring(sql.indexOf('(') + 1)?.split(',');
    array?.forEach((e) {
      String column = e.trim().split(' ')?.first?.trim();
      if (column?.isNotEmpty == true) columns.add(column);
    });
    return columns;
  }

  /// 构建数据库建表SQL语句
  static String buildCreateTableSql(String table, List<TableColumn> columns) {
    StringBuffer sb = new StringBuffer();
    sb.write("CREATE TABLE IF NOT EXISTS $table(");
    if (columns.length == 1) {
      sb.write(columns[0].buildCreateTableNeedSql());
    } else {
      for (int i = 0, length = columns.length; i < length; i++) {
        sb.write(columns[i].buildCreateTableNeedSql());
        if (i < (length - 1)) {
          sb.write(', ');
        }
      }
    }
    sb.write(");");
    return sb.toString();
  }
}