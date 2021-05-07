import 'package:flutter/material.dart';

class RowRightShowFirstWidget extends StatefulWidget {
  @override
  _RowRightShowFirstWidgetState createState() => _RowRightShowFirstWidgetState();
}

class _RowRightShowFirstWidgetState extends State<RowRightShowFirstWidget> {
  @override
  Widget build(BuildContext context) {
    String left = '左侧斤斤计较';
    String right = '右侧的文本';
    double width = calculateTextWidth(context, right, 13.0, FontWeight.w400, 98.0, 1);
    print('RowRightShow, leftWidth: ${100 - width}, rightWidth: $width');
    return Scaffold(
      appBar: AppBar(
        title: Text('Row控件右侧子控件优先显示'),
      ),
      body: Center(
          child: Container(
              constraints: BoxConstraints(maxWidth: 100),
              child: _buildBody(left, right, 100 - width - 2, width),
              color: Colors.grey
          )
      ),
    );
  }

  Widget _buildBody(String left, String right, double leftMaxWidth, double rightMaxWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: rightMaxWidth),
          child: Text(
              right,
              style: TextStyle(fontSize: 13, color: Colors.blue, fontWeight: FontWeight.w400),
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis
          ),
        ),
        SizedBox(width: 2),
        Container(
          constraints: BoxConstraints(maxWidth: leftMaxWidth),
          child: Text(
              left,
              style: TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.w400),
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis
          ),
        )
      ],
    );
  }

  Widget _buildBody2(String left, String right) {
    return Container(
      height: 18,
      constraints: BoxConstraints(maxWidth: 100),
      child: Wrap(
        spacing: 2,
        direction: Axis.horizontal,
        alignment: WrapAlignment.end,
        textDirection: TextDirection.rtl,
        children: [
          Text(
              right,
              style: TextStyle(fontSize: 13, color: Colors.blue, fontWeight: FontWeight.w400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis
          ),
          Text(
              left,
              style: TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.w400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis

          ),
        ]
      ),
    );
  }

  ///value: 文本内容；fontSize : 文字的大小；fontWeight：文字权重；maxWidth：文本框的最大宽度；maxLines：文本支持最大多少行
  static double calculateTextWidth(BuildContext context,
      String value, double fontSize, FontWeight fontWeight, double maxWidth, int maxLines) {
    value = filterText(value);
    TextPainter painter = TextPainter(
      ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        locale: Localizations.localeOf(context, nullOk: true),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: value,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);
    ///文字的宽度:painter.width
    return painter.width;
  }

  static String filterText(String text) {
    String tag = '<br>';
    while (text.contains('<br>')) {
    // flutter 算高度,单个\n算不准,必须加两个
      text = text.replaceAll(tag, '\n\n');
    }
    return text;
  }
}
