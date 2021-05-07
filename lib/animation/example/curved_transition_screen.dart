import 'package:flutter/material.dart';

/// CurvedTransition
class CurvedTransitionScreen extends StatefulWidget {
  @override
  _CurvedTransitionScreenState createState() => _CurvedTransitionScreenState();
}

class _CurvedTransitionScreenState extends State<CurvedTransitionScreen> with SingleTickerProviderStateMixin {

  Animation growingAnimation;
  Animation animation;
  AnimationController _controller;
  bool status = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    growingAnimation = Tween(begin: 0.0, end: 100.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.linear)
    );
    animation = Tween(begin: -0.25, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Transform(
            transform: Matrix4.translationValues(animation.value * width, 0.0, 0.0),
            child: Center(
                child: AnimatedBuilder(
                  animation: growingAnimation,
                  builder: (BuildContext context, Widget child) {
                    return Center(
                        child: Container(
                          height: growingAnimation.value,
                          width: growingAnimation.value * 2,
                          color: Colors.black12,
                        ));
                  },
                ))),
        RaisedButton(onPressed: () {
          status = !status;
          return status ? _controller.forward() : _controller.reverse();
        }, child: Text('开始', style: TextStyle(fontSize: 20, color: Colors.blue)))
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
