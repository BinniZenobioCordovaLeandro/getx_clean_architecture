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
    this.color = Colors.red,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      elevation: 0,
      color: color?.withOpacity(0.3),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: FractionallySizedBoxWidget(
          child: RichText(
            text: TextSpan(
              text: (title != null) ? '$title ' : null,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: color,
                  ),
              children: [
                if (message != null)
                  TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
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
