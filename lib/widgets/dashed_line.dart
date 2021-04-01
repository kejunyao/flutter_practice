import 'package:flutter/material.dart';

/// 虚线控件
class DashedLine extends StatelessWidget {
  /// 虚线方向，横向或纵向
  final Axis axis;
  /// 虚线宽度
  final double width;
  /// 虚线高度
  final double height;
  /// 虚线短横线个数
  final int count;
  /// 虚线颜色
  final Color color;

  DashedLine({
    this.axis = Axis.horizontal,
    this.width = 1,
    this.height = 1,
    this.count = 10,
    this.color = Colors.grey
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: axis,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(count, (_) {
        return SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color)
          )
        );
      }),
    );
  }

}