import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/helpers/launcher_link_helper.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/circle_avatar_image_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';

class PopupMarkerPassengerWidget extends StatelessWidget {
  final double meters;
  final String? avatar;
  final String? fullName;
  final String? phoneNumber;

  const PopupMarkerPassengerWidget({
    Key? key,
    required this.meters,
    this.avatar,
    this.fullName,
    this.phoneNumber,
  }) : super(key: key);

  child(BuildContext context) {
    return CardWidget(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Column(
              children: [
                CircleAvatarImageWidget(
                  urlSvgOrImage: '$avatar',
                  radius: 30,
                ),
              ],
            ),
            const VerticalDivider(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextWidget(
                    meters > 1000
                        ? (meters / 1000).toStringAsFixed(2)
                        : meters.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextWidget(
                    '${meters > 1000 ? "Kilometros" : "metros"} de ti',
                  ),
                  TextWidget(
                    '$fullName',
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const VerticalDivider(),
            if (phoneNumber != null)
              IconButton(
                onPressed: () {
                  LauncherLinkHelper launcherLinkHelper = LauncherLinkHelper(
                    url: phoneNumber!,
                    isPhone: true,
                  );
                  launcherLinkHelper.makePhoneCall();
                },
                icon: const Icon(
                  Icons.phone,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 80,
      child: Stack(
        children: [
          Blur(
            child: child(context),
          ),
          child(context),
        ],
      ),
    );
  }
}
