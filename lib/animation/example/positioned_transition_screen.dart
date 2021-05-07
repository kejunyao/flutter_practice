import 'package:flutter/material.dart';

/// PositionedTransition
class PositionedTransitionScreen extends StatefulWidget {
  @override
  _PositionedTransitionScreenState createState() => _PositionedTransitionScreenState();
}

class _PositionedTransitionScreenState extends State<PositionedTransitionScreen> with SingleTickerProviderStateMixin {

  final RelativeRectTween relativeRectTween = RelativeRectTween(
    begin: RelativeRect.fromLTRB(54, 183, 0, 0),
    end: RelativeRect.fromLTRB(0, 0, 0, 0),
  );

  AnimationController _controller;
  bool status = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.yellow,
          width: 300,
          height: 300,
          child: Stack(
            children: <Widget>[
              PositionedTransition(
                rect: relativeRectTween.animate(_controller),
                child: Container(
                  color: Colors.red,
                  width: 54,
                  height: 183,
                  margin: EdgeInsetsDirectional.only(bottom: 7, end: 36),
                  padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                  child: FlutterLogo(),
                ),
              ),
            ],
          ),
        ),
        RaisedButton(
          onPressed: () {
            status ? _controller.forward() : _controller.reverse();
            status = !status;
          },
          child: Text('Change Positione'),
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
