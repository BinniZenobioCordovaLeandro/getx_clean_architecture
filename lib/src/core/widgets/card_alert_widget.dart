import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';

class CardAlertWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final Color? color;

  const CardAlertWidget({
    Key? key,
    this.title,
    this.message,
    this.color = const Color(0x33f44336),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      elevation: 0,
      color: color,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: FractionallySizedBoxWidget(
          child: RichText(
            text: TextSpan(
              text: (title != null) ? '$title ' : null,
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: Colors.red,
                  ),
              children: [
                if (message != null)
                  TextSpan(
                    style: Theme.of(context).textTheme.bodyText2,
                    text: message,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
