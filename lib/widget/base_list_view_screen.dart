import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/item.dart';
import 'package:flutter_practice/util/navigator_utils.dart';

typedef OnItemSelectedCallback = Function(int index, Item item);

/// 通用ListView界面
abstract class BaseListView extends StatefulWidget {

  final List<Item> items = [];

  final String title;
  BaseListView({Key key, this.title}) : super(key: key) {
    List<Item> _items = buildItems();
    if (_items?.isNotEmpty == true) {
      this.items.addAll(_items);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _BaseListState();
  }

  List<Item> buildItems();
}

class _BaseListState extends State<BaseListView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    List<Item> items = widget.items;
    Divider divider = Divider(color: Colors.blue);
    return ListView.separated(
        // scrollDirection: Axis.horizontal,
        itemCount: widget.items.length,
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
}