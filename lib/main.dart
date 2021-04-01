import 'package:flutter/material.dart';
import 'package:flutter_practice/example/base_grid_view_screen.dart';
import 'package:flutter_practice/item.dart';
import 'package:flutter_practice/storage/db/flutter_lite.dart';
import 'package:flutter_practice/widgets/example/widget_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// DartLite lite = DartLite();
    /// print('lite.runtimeType: ${lite.runtimeType}');
    return MaterialApp(
      title: 'Flutter学习实践',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter学习实践'),
    );
  }
}

class MyHomePage extends BaseGridView {

  MyHomePage({Key key, String title}) : super(key: key, title: title);

  @override
  List<Item> buildItems() {
    List<Item> items = [];
    items.add(Item('Widget', WidgetListScreen(title: 'Widget')));
    return items;
  }

}