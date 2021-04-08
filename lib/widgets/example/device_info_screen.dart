import 'package:flutter/material.dart';
import 'package:flutter_practice/example/base_list_view_screen.dart';
import 'package:flutter_practice/item.dart';
import 'dart:ui';

class DeviceInfoScreen extends BaseListView {

  DeviceInfoScreen({Key key, String title}) : super(key: key, title: title);

  @override
  List<Item> buildItems() {
    List<Item> items = [];
    items.add(Item('屏幕宽高（px）：${window.physicalSize.width} * ${window.physicalSize.height}', null));
    items.add(Item('屏幕宽高（dp）：${window.physicalSize.width / window.devicePixelRatio} * ${window.physicalSize.height / window.devicePixelRatio}', null));
    return items;
  }
}