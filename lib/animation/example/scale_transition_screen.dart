import 'package:flutter/material.dart';

/// ScaleTransition
class ScaleTransitionScreen extends StatefulWidget {
  @override
  _ScaleTransitionScreenState createState() => _ScaleTransitionScreenState();
}

class _ScaleTransitionScreenState extends State<ScaleTransitionScreen> with SingleTickerProviderStateMixin {

  static const String _path = 'http://xs-image-proxy.oss-cn-hangzhou.aliyuncs.com/202103/02/129444898_603de8f45eaf22.38785708.jpg!head150';

  AnimationController _controller;
  bool status = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        // Image.asset('assets/images/juren.jpeg', width: 32, height: 68),
        Image.asset('assets/images/join_group_anchor_diamond.webp', width: 32, height: 68),
        _portrait,
        Container(
          margin: EdgeInsetsDirectional.only(bottom: 7, end: 36),
          child: ScaleTransition(
            scale: _controller,
            child: _tips(),
            alignment: Alignment.bottomRight
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(bottom: 300),
          child: RaisedButton(onPressed: () {
            status = !status;
            return status ? _controller.forward() : _controller.reverse();
          }, child: Text('开始', style: TextStyle(fontSize: 20, color: Colors.blue))),
        )
      ],
    );
  }

  /// 主播头像
  Widget get _portrait {
    return Container(
      margin: EdgeInsetsDirectional.only(bottom: 36),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Color(0XFFD364D7)),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.network(_path, fit: BoxFit.cover, width: 30, height: 30)
      )
    );
  }

  Widget _tips() {
    return Container(
      width: 183,
      height: 54,
      padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [Color(0XFF616CFF), Color(0XFFA25FFF)])),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          '加入楚楚动人小七的粉丝团',
          textScaleFactor: 1.0,
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
        Text(
          '加入即享粉丝专属权益',
          textScaleFactor: 1.0,
          style: TextStyle(
            fontSize: 11.0,
            color: Colors.white.withOpacity(0.6),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        )
      ]),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
