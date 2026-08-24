import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';

class PopupCardWidget extends StatelessWidget {
  final String? message;
  final Function()? onTap;
  final Color? background;

  const PopupCardWidget({
    Key? key,
    this.message,
    this.onTap,
    this.background = Colors.transparent,
  }) : super(key: key);

  child(BuildContext context) {
    return CardWidget(
      color: background,
      child: InkWell(
        onTap: onTap,
        child: FractionallySizedBoxWidget(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
            ),
            child: Column(
              children: <Widget>[
                TextWidget(
                  '$message',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 80,
      child: Stack(
        children: [
          BlurWidget(
            child: child(context),
          ),
          child(context),
        ],
      ),
    );
  }
}
