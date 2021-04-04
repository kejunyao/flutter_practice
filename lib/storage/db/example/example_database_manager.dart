import 'package:flutter_practice/storage/db/example/book.dart';
import '../easy_lite.dart';

/// 数据库接入示例
class ExampleDatabaseManager extends EasyLite {

  final _databaseName = 'doudou.db';
  final _databaseVersion = 1;
  final _logTag = 'ExampleDatabaseManager';

  ExampleDatabaseManager._() {
    setDebug(debug: true, tag: _logTag);
    registerDao(Book, BookDaoImpl());
  }

  static ExampleDatabaseManager _instance;

  static ExampleDatabaseManager _sharedInstance() {
    if (_instance == null) _instance = ExampleDatabaseManager._();
    return _instance;
  }

  static ExampleDatabaseManager get instance => _sharedInstance();

  @override
  bool get checkIntegrityAuto => true;

  @override
  String get databaseName => _databaseName;

  @override
  int get databaseVersion => _databaseVersion;

}