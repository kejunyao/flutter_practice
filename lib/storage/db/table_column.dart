import 'package:flutter/material.dart';

/// 数据库表字段结构类
class TableColumn {
  /// 主键
  static const String PRIMARY = "PRIMARY";
  static const String KEY = "KEY";
  /// 自增
  static const String AUTOINCREMENT = "AUTOINCREMENT";

  /// 表字段名称
  String name;
  /// 表字段类型
  String type;
  /// 表字段大小
  int size;
  /// 表字段约束
  String constraint;

  TableColumn({@required this.name, @required this.type, this.size, this.constraint});

  TableColumn.of(String name) {
    this.name = name;
  }

  /// 设置字段类型为text类型的
  TableColumn textType() {
    this.type = "TEXT";
    return this;
  }

  /// 设置字段类型为bool类型的
  TableColumn booleanType() {
    this.type = "BOOLEAN";
    return this;
  }

  /// 设置字段类型为real类型的
  TableColumn realType() {
    this.type = "REAL";
    return this;
  }

  /// 设置字段类型为nvarchar类型的
  TableColumn nvarcharType() {
    this.type = "NVARCHAR";
    return this;
  }

  /// 设置字段类型为float类型的
  TableColumn floatType() {
    this.type = "FLOAT";
    return this;
  }

  /// 设置字段类型为double类型的
  TableColumn doubleType() {
    this.type = "DOUBLE";
    return this;
  }

  /// 设置字段类型为int类型的
  TableColumn integerType() {
    this.type = "INTEGER";
    return this;
  }

  /// 设置字段类型为long类型的
  TableColumn longType() {
    this.type = "LONG";
    return this;
  }

  /// 非空限制
  TableColumn notNull() {
    this.constraint = "NOT NULL";
    return this;
  }

  /// 唯一约束
  TableColumn unique() {
    this.constraint = "UNIQUE";
    return this;
  }

  /// 主键约束
  TableColumn primaryKey() {
    this.constraint = "PRIMARY KEY";
    return this;
  }

  /// 主键自增约束
  TableColumn primaryKeyAuto() {
    this.constraint = "PRIMARY KEY AUTOINCREMENT";
    return this;
  }

  /// 外键
  TableColumn foreignKey() {
    this.constraint = "FOREIGN KEY";
    return this;
  }

  /// check
  TableColumn check() {
    this.constraint = "CHECK";
    return this;
  }

  /// 设置[String]类型默认值
  TableColumn defaultStringValue(String value) {
    this.constraint = "DEFAULT('$value')";
    return this;
  }

  /// 设置[int]类型默认值
  TableColumn defaultIntValue(int value) {
    this.constraint = "DEFAULT('$value')";
    return this;
  }

  /// 默认值为null
  TableColumn defaultNull() {
    this.constraint = "DEFAULT NULL";
    return this;
  }

  /// 是否为自增主键
  bool isPrimaryKeyAuto() {
    if (constraint == null) {
      return false;
    }
    String uc = constraint.toUpperCase();
    int primaryIndex = uc.indexOf(PRIMARY);
    if (primaryIndex < 0) {
      return false;
    }
    int keyIndex = uc.indexOf(KEY);
    if (keyIndex < 0) {
      return false;
    }
    if (primaryIndex >= keyIndex) {
      return false;
    }
    int autoIndex = uc.indexOf(AUTOINCREMENT);
    return autoIndex > keyIndex;
  }

  /// 是否为主键
  bool isPrimaryKey() {
    if (constraint?.isEmpty == true) {
      return false;
    }
    String uc = constraint.toUpperCase();
    if (uc.contains(AUTOINCREMENT)) {
      return false;
    }
    int primaryIndex = uc.indexOf(PRIMARY);
    if (primaryIndex < 0) {
      return false;
    }
    int keyIndex = uc.indexOf(KEY);
    if (keyIndex < 0) {
      return false;
    }
    return keyIndex > primaryIndex;
  }

  /// 创建表需要的字段语句
  String buildCreateTableNeedSql() {
    StringBuffer sb = new StringBuffer();
    sb.write(this.name);
    if (this.type?.isNotEmpty == true) {
      sb.write(' ');
      sb.write(this.type);
      if ((this.size ?? 0) > 0) {
        sb.write('(');
        sb.write(this.size);
        sb.write(')');
      }
    }
    if (this.constraint?.isNotEmpty == true) {
      sb.write(' ');
      sb.write(this.constraint);
    }
    return sb.toString();
  }

  /// 新增字段sql语句
  String buildAddColumnSql(String table) {
    StringBuffer sb = new StringBuffer();
    sb.write("ALTER TABLE $table ADD ${this.name} ");
    if (this.type?.isNotEmpty == true) {
      sb.write(" ${this.type}");
      if ((this.size ?? 0) > 0) {
        sb.write("(${this.size})");
      }
      sb.write(' ');
    }
    if (this.constraint?.isNotEmpty == true) {
      sb.write(" ${this.constraint} ");
    }
    sb.write(';');
    return sb.toString();
  }
}