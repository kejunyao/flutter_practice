import 'package:flutter/material.dart';
import 'package:flutter_practice/example/base_list_view_screen.dart';

import '../../../item.dart';
import 'example_database_manager.dart';
import 'insert_book_sreen.dart';

class LiteScreen extends BaseListView {

  LiteScreen({Key key, String title}) : super(key: key, title: title);

  @override
  List<Item> buildItems() {
    List<Item> items = [];
    items.add(_buildInit());
    items.add(Item('数据库insertOrUpdate', InsertBookScreen()));
    return items;
  }

  ///  数据库初始化
  Item _buildInit() {
    return Item.withScaffoldCenter('初始化(务必先手动初始化)', RaisedButton(
      onPressed: () {
        ExampleDatabaseManager.instance.init();
      },
      child: Text('数据库初始化', style: TextStyle(fontSize: 20, color: Colors.blue)),
    ), color: Colors.red);
  }
}
