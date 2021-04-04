import 'package:flutter/material.dart';

/// 列表通用数据结构模型
class Item {
  String name;
  Widget page;
  Color color;
  Item(this.name, this.page, {this.color = Colors.blue});

  Item.withScaffold(String name, Widget widget, {Color color}) {
    this.name = name;
    this.color = color ?? Colors.blue;
    this.page = Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: widget,
    );
  }

  Item.withScaffoldCenter(String name, Widget widget, {Color color}) {
    this.name = name;
    this.color = color ?? Colors.blue;
    this.page = Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(child: widget),
    );
  }

  // Scaffold

}