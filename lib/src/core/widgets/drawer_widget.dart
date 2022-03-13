import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';

class DrawerWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const DrawerWidget({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBarWidget(
            title: title,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}
