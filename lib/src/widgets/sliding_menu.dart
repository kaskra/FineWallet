/*
 * Project: FineWallet
 * Last Modified: Tuesday, 10th September 2019 11:16:34 am
 * Modified By: Lukas (luke.krauch@gmail.com>)
 * -----
 * Copyright 2019 - 2019 Sylu, Sylu
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SlidingButtonMenu extends StatefulWidget {
  const SlidingButtonMenu({@required this.onMenuFunction, this.tapCallback});

  final ValueChanged<int> onMenuFunction;
  final Function(bool) tapCallback;

  @override
  _SlidingButtonMenuState createState() => _SlidingButtonMenuState();
}

class _SlidingButtonMenuState extends State<SlidingButtonMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  double _width = 60;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, lowerBound: -0.5, upperBound: 0.5);
    _controller.value = 0.0;
    _controller.addListener(() {});

    _animation = Tween<Offset>(
            begin: const Offset(0.0, 0.0), end: const Offset(1.5, 0.0))
        .animate(_controller);
  }

  @override
  void didUpdateWidget(SlidingButtonMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animation = Tween<Offset>(
            begin: const Offset(0.0, 0.0), end: const Offset(1.5, 0.0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  double offsetFromGlobalPos(Offset globalPosition) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset local = box.globalToLocal(globalPosition);
    return ((local.dx * 0.75) / box.size.width) - 0.4;
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanDown(DragDownDetails details) {
    setState(() {
      _width = 280;
    });
    if (widget.tapCallback != null) {
      widget.tapCallback(false);
    }
  }

  void _onPanCancel() {
    setState(() {
      _width = 60;
    });
    if (widget.tapCallback != null) {
      widget.tapCallback(true);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (details.globalPosition.dx < 90 || details.globalPosition.dx > 290) {
      return;
    }
    _controller.value = offsetFromGlobalPos(details.globalPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    _controller.stop();
    if (_controller.value <= -0.20) {
      widget.onMenuFunction(-1);
    } else if (_controller.value >= 0.20) {
      widget.onMenuFunction(1);
    }

    _controller.value = 0;
    setState(() {
      _width = 60;
    });
    if (widget.tapCallback != null) {
      widget.tapCallback(true);
    }
  }

  Widget _buildSlider() {
    return FittedBox(
        child: Container(
      width: _width,
      height: 60,
      child: Material(
        clipBehavior: Clip.antiAlias,
        type: MaterialType.canvas,
        borderRadius: BorderRadius.circular(30),
        color: Colors.black38,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              left: 10,
              bottom: null,
              child: Icon(Icons.add,
                  size: 26, color: Theme.of(context).iconTheme.color),
            ),
            Positioned(
              right: 10,
              bottom: null,
              child: Icon(
                Icons.remove,
                size: 26,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            GestureDetector(
              onHorizontalDragStart: _onPanStart,
              onHorizontalDragUpdate: _onPanUpdate,
              onHorizontalDragEnd: _onPanEnd,
              onHorizontalDragDown: _onPanDown,
              onHorizontalDragCancel: _onPanCancel,
              dragStartBehavior: DragStartBehavior.down,
              child: SlideTransition(
                position: _animation,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 5,
                  child: Center(
                      child: FloatingActionButton(
                    heroTag: 'DockedFAB',
                    onPressed: () {},
                    child: Icon(
                      Icons.swap_horiz,
                      color: Theme.of(context).iconTheme.color,
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
    return _buildSlider();
  }
}
