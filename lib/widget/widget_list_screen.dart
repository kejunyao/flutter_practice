import 'package:flutter/cupertino.dart';
import 'package:flutter_practice/widget/base_list_view_screen.dart';
import 'package:flutter_practice/item.dart';
import 'package:flutter_practice/widget/star_rating.dart';

/// 各种控件列表
class WidgetListScreen extends BaseListView {

  WidgetListScreen({Key key, String title}) : super(key: key, title: title);

  @override
  List<Item> buildItems() {
    List<Item> items = [];
    items.add(Item.withScaffold('评分控件', StartRating(rating: 9.5, count: 10)));
    return items;
  }

}