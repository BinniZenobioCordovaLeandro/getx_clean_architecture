import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_icon_widget.dart';

class CallCardWidget extends StatelessWidget {
  const CallCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: ElevatedButtonIconWidget(
              icon: Icons.call,
              title: 'Llamar al vehiculo',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
