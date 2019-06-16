/*
 * Developed by Lukas Krauch 16.6.2019.
 * Copyright (c) 2019. All rights reserved.
 *
 */
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SlidingFABMenu extends StatefulWidget {
  SlidingFABMenu({@required this.onMenuFunction});

  ValueChanged<int> onMenuFunction;

  @override
  _SlidingFABMenuState createState() => _SlidingFABMenuState();
}

class _SlidingFABMenuState extends State<SlidingFABMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  bool _pressed = false;

  double _width = 60;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, lowerBound: -0.5, upperBound: 0.5);
    _controller.value = 0.0;
    _controller.addListener(() {});

    _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.5, 0.0))
        .animate(_controller);
  }

  @override
  void didUpdateWidget(SlidingFABMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animation = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.5, 0.0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  double offsetFromGlobalPos(Offset globalPosition) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset local = box.globalToLocal(globalPosition);
    return ((local.dx * 0.75) / box.size.width) - 0.4;
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _pressed = true;
//      _width = 280;
    });
    _controller.stop();
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanDown(DragDownDetails details) {
    setState(() {
      _width = 280;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (details.globalPosition.dx < 90 || details.globalPosition.dx > 290)
      return;
    _controller.value = offsetFromGlobalPos(details.globalPosition);
    print(details.globalPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    _controller.stop();
    if (_controller.value <= -0.20) {
      widget.onMenuFunction(-1);
//      print("Ended left");
    } else if (_controller.value >= 0.20) {
      widget.onMenuFunction(1);
//      print("Ended right");
    }

//    _controller.animateTo(0.0,
//        curve: Curves.bounceOut, duration: Duration(milliseconds: 500));

    _controller.value = 0;
    setState(() {
      _pressed = false;
      _width = 60;
    });
  }

  Widget _test() {
    return FittedBox(
        child: Container(
      width: _width,
      height: 60,
      child: Material(
        clipBehavior: Clip.antiAlias,
        type: MaterialType.canvas,
        borderRadius: BorderRadius.circular(30),
        color: _pressed ? Colors.black38 : Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _pressed
                ? Positioned(
                    left: 10,
                    bottom: null,
                    child: Icon(Icons.add, size: 26, color: Colors.white),
                  )
                : Container(),
            _pressed
                ? Positioned(
                    right: 10,
                    bottom: null,
                    child: Icon(
                      Icons.remove,
                      size: 26,
                      color: Colors.white,
                    ),
                  )
                : Container(),
            GestureDetector(
              onHorizontalDragStart: _onPanStart,
              onHorizontalDragUpdate: _onPanUpdate,
              onHorizontalDragEnd: _onPanEnd,
              onHorizontalDragDown: _onPanDown,
              dragStartBehavior: DragStartBehavior.down,
              child: SlideTransition(
                position: _animation,
                child: Material(
                  color: Colors.white,
                  shape: CircleBorder(),
                  elevation: 5,
                  child: Center(
                      child: FloatingActionButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.swap_horiz,
                      color: Colors.white,
                    ),
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _test();
  }
}
