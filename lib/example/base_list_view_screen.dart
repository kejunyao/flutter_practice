import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/item.dart';
import 'package:flutter_practice/util/navigator_utils.dart';

typedef OnItemSelectedCallback = Function(int index, Item item);

/// 通用ListView界面
abstract class BaseListView extends StatelessWidget {

  final List<Item> items = [];

  final String title;
  BaseListView({Key key, this.title}) : super(key: key) {
    this.items.clear();
    List<Item> _items = buildItems();
    if (_items?.isNotEmpty == true) {
      this.items.addAll(_items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    Divider divider = Divider(color: Colors.blue);
    return ListView.separated(
      // scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder:  (BuildContext context, int index) {
          return divider;
        },
        itemBuilder: (BuildContext context, int index) {
          Widget widget = Container(
            color: Colors.white,
            child: ListTile(
                title: Text(items[index].name, style: TextStyle(fontSize: 20, color: Colors.blue)),
                trailing: Icon(Icons.arrow_forward_ios)
            ),
          );
          return GestureDetector(
            onTap: () {
              NavigatorUtils.push(context, items[index].page);
            },
            child: widget,
          );
        });
  }

  List<Item> buildItems();
}