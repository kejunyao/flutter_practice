import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/item.dart';
import 'package:flutter_practice/util/navigator_utils.dart';

typedef OnItemSelectedCallback = Function(int index, Item item);

/// 通用GridView界面
abstract class BaseGridView extends StatelessWidget {

  final List<Item> items = [];

  final String title;
  BaseGridView({Key key, this.title}) : super(key: key) {
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
    return GridView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 1, crossAxisSpacing: 1, childAspectRatio: 1.0),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                NavigatorUtils.push(context, items[index].page);
              },
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text(items[index].name, style: TextStyle(fontSize: 20, color: Colors.white))));
        });
  }

  List<Item> buildItems();
}