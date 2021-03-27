import 'package:flutter/material.dart';

/// 评分控件
class StartRating extends StatefulWidget {
  /// 分数最大值
  final double max;
  /// 当前多少分
  final double rating;
  /// 五角星未选中的颜色
  final Color unselectedColor;
  /// 五角星选中的颜色
  final Color selectedColor;
  /// 五角星的大小
  final double size;
  /// 一共展示个数
  final int count;

  final Widget unselectedImage;
  final Widget selectedImage;

  StartRating(
      {@required this.rating,
      this.unselectedColor = Colors.grey,
      this.selectedColor = Colors.red,
      this.max = 10,
      this.size = 30,
      this.count = 5,
      Widget unselectedImage,
      Widget selectedImage
      }): unselectedImage = unselectedImage ?? Icon(Icons.star_border, color: unselectedColor, size: size),
          selectedImage = selectedImage ?? Icon(Icons.star, color: selectedColor, size: size);

  @override
  State<StatefulWidget> createState() {
    return _StartRatingState();
  }
}

class _StartRatingState extends State<StartRating> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(mainAxisSize: MainAxisSize.min, children: _buildUnselectedStar()),
        Row(mainAxisSize: MainAxisSize.min, children: _buildSelectedStar())
      ],
    );
  }

  /// 未选中的五角星
  List<Widget> _buildUnselectedStar() {
    return List.generate(widget.count, (index) {
      return widget.unselectedImage;
    });
  }

  /// 选中的五角星
  List<Widget> _buildSelectedStar() {
    List<Widget> stars = [];
    final star = widget.selectedImage;
    double total = widget.count * widget.rating / widget.max;
    int entireCount = total.floor();
    for (var i = 0; i < entireCount; i++) stars.add(star);
    final partStar = ClipRect(
      child: star,
      clipper: _StarClipper((total - entireCount) * widget.size),
    );
    stars.add(partStar);
    return stars;
  }
}

/// 裁剪器
class _StarClipper extends CustomClipper<Rect> {

  final double width;
  _StarClipper(this.width);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, width, size.height);
  }

  @override
  bool shouldReclip(covariant _StarClipper oldClipper) {
    return this.width != oldClipper.width;
  }
}
