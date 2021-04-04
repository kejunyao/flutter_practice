/// 数据库工具类
class DbUtils {

  DbUtils._();

  /// 获取当前时间（单位：毫秒）
  static int get millis => DateTime.now().millisecondsSinceEpoch;

  /// 获取文件名称
  static String filename(String path) {
    return path.substring(path.lastIndexOf('/') + 1);
  }
}