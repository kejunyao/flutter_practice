import 'package:flutter/material.dart';
import 'package:flutter_practice/animation/example/positioned_transition_screen.dart';
import 'package:flutter_practice/animation/example/scale_transition_screen.dart';
import 'package:flutter_practice/animation/example/slide_transition_screen.dart';
import 'package:flutter_practice/example/base_list_view_screen.dart';
import 'package:flutter_practice/item.dart';

import 'curved_transition_screen.dart';

/// 各种控件列表
class AnimationListScreen extends BaseListView {
  AnimationListScreen({Key key, String title}) : super(key: key, title: title);

  @override
  List<Item> buildItems() {
    List<Item> items = [];
    items.add(Item.withScaffoldCenter('SlideTransition', SlideTransitionScreen()));
    items.add(Item.withScaffoldCenter('PositionedTransition', PositionedTransitionScreen()));
    items.add(Item.withScaffoldCenter('ScaleTransition', ScaleTransitionScreen()));
    items.add(Item.withScaffoldCenter('CurvedTransition', CurvedTransitionScreen()));
    return items;
  }

}
