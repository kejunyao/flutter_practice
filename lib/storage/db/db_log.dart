
/// 数据库日志工具类
class DbLog {

  DbLog._();

  /// 默认tag
  static const String TAG = 'EasyLite';

  static void dSingle(String message, {Object currClass = '', String tag = TAG}) {
    print('$tag: ${currClass?.runtimeType}, $message');
  }

  static void printResult<T>(String tag, Object dao, String method, Type type,
      Object result, String info,
      {T entity, List<T> entities, Map<String, dynamic> values,
        String sql, String whereClause, List<dynamic> whereArgs,
        String primaryKey, String columnOrExpression, List<String> columnsOrExpressions,
        bool exclusive, bool noResult, bool continueOnError}) {
    StringBuffer sb = StringBuffer();
    sb.write('\n');
    sb.write(tag?.isEmpty == true ? TAG : tag);
    sb.write(': ');
    sb.write(dao?.runtimeType ?? '');
    sb.write('\n');
    sb.write(method);
    sb.write('(type: $type');
    if (entity != null) sb.write(", entity: $entity");
    if (entities != null) sb.write(", entities: $entities");
    if (sql != null) sb.write(", sql: $sql");
    if (values != null) sb.write(", values: $values");
    if (primaryKey != null) sb.write(", primaryKey: $primaryKey");
    if (columnsOrExpressions != null) sb.write(", columnsOrExpressions: $columnsOrExpressions");
    if (exclusive != null) sb.write(', exclusive: $exclusive');
    if (noResult != null) sb.write(', noResult: $noResult');
    if (continueOnError != null) sb.write(', continueOnError: $continueOnError');
    if (whereClause != null) sb.write(', whereClause: $whereClause');
    if (whereArgs != null) sb.write(', whereArgs: $whereArgs');
    sb.write(')');
    sb.write('\nresult: $result');
    if (info?.isNotEmpty == true) sb.write('\n$info');
    sb.write('\n====================================================== end ======================================================');
    sb.write('\n');
    print(sb.toString());
  }
}