import 'dart:async';
import 'package:flutter_practice/storage/db/database.dart';

/// 数据库创建、打开、升级、降级等行为
abstract class OnDatabaseCallback {
  /// 设置监听数据库创建Callback
  ///
  /// [callback] 监听数据库创建回调函数
  void setOnDatabaseCreate(OnDatabaseCreate callback);

  /// 设置监听数据库打开Callback
  ///
  /// [callback] 监听数据库打开回调函数
  void setOnDatabaseOpen(OnDatabaseOpen callback);

  /// 设置监听数据库升级Callback
  ///
  /// [callback] 监听数据库升级回调函数
  void setOnDatabaseUpgrade(OnDatabaseVersionChange callback);


  /// 设置监听数据库降级Callback
  ///
  /// [callback] 监听数据库降级回调函数
  void setOnDatabaseDowngrade(OnDatabaseVersionChange callback);

  /// 数据库操作异常callback
  ///
  /// [callback] 监听数据库异常回调函数
  void setOnDatabaseError(OnDatabaseError callback);

  /// 数据库初始完毕
  void setOnDatabaseInitialized(OnDatabaseInitialized callback);
}

/// 数据库发生异常
typedef OnDatabaseError = Function(Error error);
/// 数据库初始化完毕
typedef OnDatabaseInitialized = Function();
/// 数据库升级/降级回调函数
typedef FutureOr<void> OnDatabaseVersionChange(RootDatabase db, int oldVersion, int newVersion);
/// 数据库升级/降级回调函数
typedef FutureOr<void> OnDatabaseCreate(RootDatabase db, int version);
/// 数据库打开回调函数
typedef FutureOr<void> OnDatabaseOpen(RootDatabase db);
/// 数据库配置回调函数
typedef FutureOr<void> OnDatabaseConfigure(RootDatabase db);