import 'package:flutter/material.dart';

import '../ripple_widget.dart';

class RippleWidgetScreen extends StatefulWidget {
  @override
  _RippleWidgetScreenState createState() => _RippleWidgetScreenState();
}

class _RippleWidgetScreenState extends State<RippleWidgetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('水波涟漪Widget'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topCenter,
            end: AlignmentDirectional.bottomCenter,
            colors: [Color(0XFF7658FF), Color(0XFFA889FD)],
          ),
        ),
        child: Center(
          child: RippleWidget(
            radius: 100,
            maxRadius: 350,
            child: Image.asset(
              'assets/images/widget/ripple_logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
