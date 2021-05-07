import 'package:flutter/material.dart';
import 'package:flutter_practice/example/base_grid_view_screen.dart';
import 'package:flutter_practice/item.dart';
import 'package:flutter_practice/example/db/ui/lite_screen.dart';
import 'package:flutter_practice/widgets/example/device_info_screen.dart';
import 'package:flutter_practice/widgets/example/widget_list_screen.dart';

import 'animation/example/animation_list_screen.dart';

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
    items.add(Item('数据库', LiteScreen(title: '数据库')));
    items.add(Item('设备信息', DeviceInfoScreen(title: '设备信息')));
    items.add(Item('动画', AnimationListScreen(title: '动画')));
    return items;
  }

}