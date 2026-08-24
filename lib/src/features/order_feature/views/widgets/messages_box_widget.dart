import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class MessagesBoxWidget extends StatelessWidget {
  const MessagesBoxWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FractionallySizedBoxWidget(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 16,
                ),
                child: Flexible(
                  child: SingleChildScrollView(
                    child: WrapWidget(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        for (var i = 0; i < 10; i++)
                          CardWidget(
                            child: ListTile(
                              leading: i % 2 == 0
                                  ? CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: Text('$i'),
                                    )
                                  : null,
                              trailing: i % 2 == 0
                                  ? null
                                  : CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: Text('$i'),
                                    ),
                              dense: true,
                              title: Text(
                                'Hola, nos podemos ver a 2 cuadras del estadio principal de la ciudad.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              subtitle: Text(
                                'Hoy, a las 12:00',
                                textAlign: i % 2 == 0
                                    ? TextAlign.right
                                    : TextAlign.left,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            TextFieldWidget(
              labelText: 'Mensaje',
              suffixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send_rounded,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
