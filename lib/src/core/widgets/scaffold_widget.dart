import 'package:flutter/material.dart';

class ScaffoldWidget extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;

  const ScaffoldWidget({
    Key? key,
    this.appBar,
    this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
