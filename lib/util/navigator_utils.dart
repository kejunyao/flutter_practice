import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 跳转工具类
class NavigatorUtils {

  /// 页面跳转
  static Future<T> push<T>(BuildContext context, Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

}