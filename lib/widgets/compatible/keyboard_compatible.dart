import 'dart:math';
import 'package:flutter/material.dart';

/// 场景：
///
/// 数据框在屏幕的底部，键盘弹起顶起输入框，输入框上方的控件被顶到屏幕上方，然后底部空间依然不够。
class KeyboardCompatibleWidget extends StatefulWidget {
  @override
  _KeyboardCompatibleWidgetState createState() => _KeyboardCompatibleWidgetState();
}

class _KeyboardCompatibleWidgetState extends State<KeyboardCompatibleWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('键盘兼容性问题'),
      ),
      body: buildBody(),
    );
  }

  Widget buildList() {
    Divider divider = Divider(color: Colors.blue);
    return ListView.separated(
        // scrollDirection: Axis.horizontal,
        itemCount: 11,
        separatorBuilder: (BuildContext context, int index) {
          return divider;
        },
        itemBuilder: (BuildContext context, int index) {
          Widget widget = Container(
            color: Colors.white,
            child: Container(
                color: color,
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: Text('文本$index', style: TextStyle(fontSize: 20, color: Colors.blue))),
          );
          return widget;
        });
  }

  Widget buildBody() {
    return Stack(
        children: [
          Container(height: 650, child: buildList()),
          Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
            decoration: InputDecoration(hintText: '请输入文本'),
          ))
        ],
    );
  }

  Color get color => Color.fromARGB(255, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255));
}
