import 'package:flutter/material.dart';
import 'package:flutter_practice/example/base_list_view_screen.dart';
import 'package:flutter_practice/example/db/ui/query_screen.dart';
import 'package:flutter_practice/example/db/ui/transaction_screen.dart';
import '../../../item.dart';
import 'delete_screen.dart';
import '../example_database_manager.dart';
import 'insert_and_update_sreen.dart';
import 'lite_task_sreen.dart';

class LiteScreen extends BaseListView {

  LiteScreen({Key key, String title}) : super(key: key, title: title);

  @override
  List<Item> buildItems() {
    List<Item> items = [];
    items.add(_buildInit());
    items.add(Item('Insert、Update（先手动初始化）', InsertAndUpdateScreen()));
    items.add(Item('Query（先手动初始化）', QueryScreen()));
    items.add(Item('Delete（先手动初始化）', DeleteScreen()));
    items.add(Item('Transaction（先手动初始化）', TransactionScreen()));
    items.add(Item('LiteTask（不要先手动初始化）', LiteTaskScreen()));
    return items;
  }

  ///  数据库初始化
  Item _buildInit() {
    return Item.withScaffoldCenter('初始化(务必先手动初始化)', RaisedButton(
      onPressed: () {
        ExampleDatabaseManager.instance.init();
      },
      child: Text(
          '数据库初始化',
          style: TextStyle(fontSize: 20, color: Colors.blue)
      ),
    ), color: Colors.red);
  }
}
