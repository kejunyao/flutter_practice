import 'package:flutter/material.dart';

class Log {

  /// 默认tag
  static const String TAG = 'FlutterLite';

  static void dSingle(String message, {Object currClass = '', String tag = TAG}) {
    print('$tag: ${currClass?.runtimeType}, $message');
  }

  static void printAfter(Object currClass, String message, {String tag, Error e}) {
    print("${tag ?? TAG}: ${currClass?.runtimeType ?? ''}\n${e == null ? message : e.toString()}====================================================== end ======================================================");
  }

  static void printQueryResult(String tag, Object dao, String method, Type type,
      String whereClause, List<dynamic> whereArgs,
      Object result, String info) {
    printResult(tag, dao, method, type, null, null, whereClause, whereArgs, result, info);
  }

  static void printResult<T>(String tag, Object dao, String method, Type type,
      T entity, List<T> entities, String whereClause, List<dynamic> whereArgs,
      Object result, String info) {
    StringBuffer sb = StringBuffer();
    sb.write('\n');
    sb.write(tag?.isEmpty == true ? TAG : tag);
    sb.write(':');
    sb.write(dao?.runtimeType ?? '');
    sb.write('\n');
    sb.write(method);
    sb.write('(type: $type');
    if (entity != null) sb.write(", entity: $entity");
    if (entities?.isNotEmpty == true) sb.write(", entities: $entities");
    if (whereClause?.isNotEmpty == true) sb.write(', whereClause: $whereClause');
    if (whereArgs?.isNotEmpty == true) sb.write(', whereArgs: $whereArgs');
    sb.write(')');
    sb.write('\nresult: $result');
    if (info?.isNotEmpty == true) sb.write('\n$info');
    sb.write('\n====================================================== end ======================================================');
    sb.write('\n');
    print(sb.toString());
  }
}