import 'package:sqflite/sqflite.dart';

/// 数据库创建、打开、升级、降级等行为
abstract class OnDatabaseConfigCallback {
  /// 注册监听数据库创建Callback
  /// [key] 查找[callback]关键字
  /// [callback] 监听数据库创建回调函数
  void registerOnCreateCallback(String key, OnDatabaseCreateFn callback);

  /// 注销监听数据库创建Callback
  /// [key] 查找[callback]关键字
  void unregisterOnCreateCallback(String key);

  /// 注册监听数据库打开Callback
  /// [key] 查找[callback]关键字
  /// [callback] 监听数据库打开回调函数
  void registerOnOpenCallback(String key, OnDatabaseOpenFn callback);

  /// 注销监听数据库打开Callback
  /// [callback] 监听数据库升级回调函数
  void unregisterOnOpenCallback(String key);

  /// 注册监听数据库升级Callback
  /// [key] 查找[callback]关键字
  /// [callback] 监听数据库升级回调函数
  void registerOnUpgradeCallback(String key, OnDatabaseVersionChangeFn callback);

  /// 注销监听数据库升级Callback
  /// [key] 查找[callback]关键字
  void unregisterOnUpgradeCallback(String key);

  /// 注册监听数据库降级Callback
  /// [key] 查找[callback]关键字
  /// [callback] 监听数据库降级回调函数
  void registerOnDowngradeCallback(String key, OnDatabaseVersionChangeFn callback);
}

/// 数据库发生异常
typedef OnDatabaseErrorCallback(Error error);

class OnDatabaseChange implements OnDatabaseConfigCallback {

  /// 数据库创建回调
  Map<String, OnDatabaseCreateFn> _onCreateCallbacks;

  /// 数据库打开回调
  Map<String, OnDatabaseOpenFn> _onOpenCallbacks;

  /// 数据库升级回调
  Map<String, OnDatabaseVersionChangeFn> _onUpgradeCallbacks;

  /// 数据库降级回调
  Map<String, OnDatabaseVersionChangeFn> _onDowngradeCallbacks;

  /// 注册监听数据库创建Callback
  void registerOnCreateCallback(String key, OnDatabaseCreateFn callback) {
    if (key?.isEmpty == true || callback == null) return;
    if (_onCreateCallbacks == null) {
      _onCreateCallbacks = {};
    }
    _onCreateCallbacks[key] = callback;
  }

  /// 注销监听数据库创建Callback
  void unregisterOnCreateCallback(String key) {
    if (key?.isEmpty == true) return;
    _onCreateCallbacks?.remove(key);
  }

  /// 注册监听数据库打开Callback
  void registerOnOpenCallback(String key, OnDatabaseOpenFn callback) {
    if (key?.isEmpty == true || callback == null) return;
    if (_onOpenCallbacks == null) {
      _onOpenCallbacks = {};
    }
    _onOpenCallbacks[key] = callback;
  }

  /// 注销监听数据库打开Callback
  void unregisterOnOpenCallback(String key) {
    if (key?.isEmpty == true) return;
    _onOpenCallbacks?.remove(key);
  }

  /// 注册监听数据库升级Callback
  void registerOnUpgradeCallback(String key, OnDatabaseVersionChangeFn callback) {
    if (key?.isEmpty == true || callback == null) return;
    if (_onUpgradeCallbacks == null) {
      _onUpgradeCallbacks = {};
    }
    _onUpgradeCallbacks[key] = callback;
  }

  /// 注销监听数据库升级Callback
  void unregisterOnUpgradeCallback(String key) {
    if (key?.isEmpty == true) return;
    _onUpgradeCallbacks?.remove(key);
  }

  /// 注册监听数据库降级Callback
  void registerOnDowngradeCallback(String key, OnDatabaseVersionChangeFn callback) {
    if (key?.isEmpty == true || callback == null) return;
    if (_onUpgradeCallbacks == null) {
      _onUpgradeCallbacks = {};
    }
    _onDowngradeCallbacks[key] = callback;
  }

  /// 注销监听数据库降级Callback
  void unregisterOnDowngradeCallback(String key) {
    if (key?.isEmpty == true) return;
    _onDowngradeCallbacks?.remove(key);
  }

  /// 分发数据库创建事件
  void postOnCreate(Database db, int version) {
    _onCreateCallbacks?.forEach((key, value) {
      value(db, version);
    });
  }

  /// 分发数据库被打开事件
  void postOnOpen(Database db) {
    _onOpenCallbacks?.forEach((key, value) {
      value(db);
    });
  }

  /// 分发数据库升级事件
  void postOnUpgrade(Database db, int oldVersion, int newVersion) {
    _onUpgradeCallbacks?.forEach((key, value) {
      value(db, oldVersion, newVersion);
    });
  }

  /// 分发数据库降级事件
  void postOnDowngrade(Database db, int oldVersion, int newVersion) {
    _onDowngradeCallbacks?.forEach((key, value) {
      value(db, oldVersion, newVersion);
    });
  }
}