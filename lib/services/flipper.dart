import 'dart:math';
import 'package:flutter/material.dart';

class Flipper extends StatefulWidget {
  const Flipper(
      {super.key,
      required this.front,
      required this.back,
      this.reverse = false});
  final Widget front;
  final Widget back;
  final bool reverse;
  @override
  State<Flipper> createState() => _FlipperState();
}

class _FlipperState extends State<Flipper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double p;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    p = widget.reverse ? -pi : pi;
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _startFlip();
  }

  void _startFlip() {
    if (_controller.isAnimating) return;

    _controller.forward().then((_) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => widget.back,
          transitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            double rotationAngle = _animation.value * p;

            bool showFront = widget.reverse
                ? rotationAngle >= p / 2
                : rotationAngle <= p / 2;

            return Stack(
              children: [
                widget.reverse
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(
                              rotationAngle < p / 2 ? rotationAngle - p : p),
                        child:
                            !showFront ? _buildBack() : const SizedBox.shrink(),
                      )
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(
                              rotationAngle > p / 2 ? rotationAngle - p : p),
                        child:
                            !showFront ? _buildBack() : const SizedBox.shrink(),
                      ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(rotationAngle),
                  child: showFront ? _buildFront() : const SizedBox.shrink(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFront() {
    return widget.front;
  }

  Widget _buildBack() {
    return widget.back;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
