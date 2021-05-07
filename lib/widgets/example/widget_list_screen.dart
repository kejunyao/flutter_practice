import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_practice/example/base_list_view_screen.dart';
import 'package:flutter_practice/item.dart';
import 'package:flutter_practice/widgets/compatible/keyboard_compatible.dart';
import 'package:flutter_practice/widgets/dashed_line.dart';
import 'package:flutter_practice/widgets/example/ripple_widget_screen.dart';
import 'package:flutter_practice/widgets/example/row_right_show_widget.dart';
import 'package:flutter_practice/widgets/star_rating.dart';
import 'compatible_text_editing.dart';
import 'nested_scroll_view_widget.dart';

/// 各种控件列表
class WidgetListScreen extends BaseListView {
  WidgetListScreen({Key key, String title}) : super(key: key, title: title);

  @override
  List<Item> buildItems() {
    List<Item> items = [];
    items.add(Item.withScaffoldCenter('评分控件', StartRating(rating: 9.5, count: 10)));
    items.add(
        Item.withScaffoldCenter('虚线',
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 200,
                  child: DashedLine(axis: Axis.horizontal, width: 6, height: 1, count: 20, color: Colors.black)
              ),
              Container(
                  height: 200,
                  child: DashedLine(axis: Axis.vertical, width: 1, height: 6, count: 20, color: Colors.red)
              )
            ],
          )
        )
    );
    items.add(Item.withScaffold('CompatibleTextEditingController', CompatibleTextEditing()));
    items.add(Item('键盘兼容性问题', KeyboardCompatibleWidget()));
    items.add(Item('NestedScrollView', NestedScrollViewWidget()));
    items.add(Item('Row控件右侧子控件优先显示', RowRightShowFirstWidget()));
    items.add(Item('水波涟漪效果Widget', RippleWidgetScreen()));
    return items;
  }

}
