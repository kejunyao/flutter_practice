import 'package:flutter/material.dart';

/// 列表通用数据结构模型
class Item {
  String name;
  Widget page;
  Item(this.name, this.page);

  Item.withScaffold(String name, Widget widget) {
    this.name = name;
    this.page = Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: widget,
    );
  }

  Item.withScaffoldCenter(String name, Widget widget) {
    this.name = name;
    this.page = Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(child: widget),
    );
  }

  // Scaffold

}