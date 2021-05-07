import 'package:flutter/material.dart';

/// SlideTransition
class SlideTransitionScreen extends StatefulWidget {
  @override
  _SlideTransitionScreenState createState() => _SlideTransitionScreenState();
}

class _SlideTransitionScreenState extends State<SlideTransitionScreen> with SingleTickerProviderStateMixin {

  Animation<Offset> _animationSlide;
  AnimationController _controller;
  bool status = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animationSlide = Tween(begin: Offset(0, 0), end: Offset(0.5, 0.5)).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlideTransition(
          position: _animationSlide,
          child: Container(
            color: Colors.cyan,
            height: 100,
            child: Text('SlideTransition'),
          ),
        ),
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
