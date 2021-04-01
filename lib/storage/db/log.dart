import 'package:flutter/material.dart';

class LiteLog {

  /// 打印日志
  /// [tag]日志的tag
  /// [messages] 日志信息
  static void d(List<String> messages, {String tag}) {
    StringBuffer sb = StringBuffer();
    if (tag?.isNotEmpty == true) {
      sb.write(tag);
      sb.write(': ');
    }
    messages?.forEach((e) {
      sb.write(e);
    });
    print(sb.toString());
  }

  static void e({String tag, @required Error e}) {
    d([e.toString()], tag: tag);
  }

}