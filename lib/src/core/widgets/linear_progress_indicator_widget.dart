import 'package:flutter/material.dart';

class LinearProgressIndicatorWidget extends StatefulWidget {
  const LinearProgressIndicatorWidget({Key? key}) : super(key: key);

  @override
  State<LinearProgressIndicatorWidget> createState() =>
      _LinearProgressIndicatorWidgetState();
}

class _LinearProgressIndicatorWidgetState
    extends State<LinearProgressIndicatorWidget>
    with SingleTickerProviderStateMixin {
  
  AnimationController? _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _animationController!.repeat(
      period: const Duration(seconds: 5),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (BuildContext context, Widget? child) {
        return const LinearProgressIndicator(
          backgroundColor: Colors.transparent,
        );
      },
    );
  }
}
