import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class BannerHelper {
  final BuildContext? context;
  final String? title;
  final String? body;

  BannerHelper({
    required this.context,
    required this.title,
    required this.body,
  }) {
    ScaffoldMessenger.of(context!).showMaterialBanner(
      _showMaterialBanner(context!),
    );
  }

  MaterialBanner _showMaterialBanner(BuildContext context) {
    return MaterialBanner(
      elevation: 5,
      content: SizedBox(
        child: WrapWidget(
          children: [
            if (title != null)
              SizedBox(
                child: TextWidget('$title'),
              ),
            if (body != null)
              SizedBox(
                child: TextWidget('$body'),
              ),
          ],
        ),
      ),
      leading: const Icon(Icons.info_outlined),
      padding: const EdgeInsets.all(0),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      contentTextStyle: Theme.of(context).textTheme.titleMedium,
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: Text(
            'Aceptar',
            style: Theme.of(context).textTheme.button,
          ),
        ),
      ],
    );
  }
}
