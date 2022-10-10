import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/helpers/launcher_link_helper.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/circle_avatar_image_widget.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class AcceptPassengerCardWidget extends StatelessWidget {
  final String? avatar;
  final String? fullName;
  final String? phoneNumber;
  final int? count;
  final Function()? onPressed;

  const AcceptPassengerCardWidget({
    Key? key,
    required this.avatar,
    required this.fullName,
    required this.phoneNumber,
    this.count,
    required this.onPressed,
  }) : super(key: key);

  child(BuildContext context) {
    return CardWidget(
      color: Colors.transparent,
      child: FractionallySizedBoxWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: WrapWidget(
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  if (avatar != null)
                    Column(
                      children: [
                        CircleAvatarImageWidget(
                          urlSvgOrImage: avatar,
                          radius: 30,
                        ),
                      ],
                    ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextWidget(
                          '$fullName',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  if (phoneNumber != null)
                    IconButton(
                      onPressed: () {
                        LauncherLinkHelper launcherLinkHelper =
                            LauncherLinkHelper(
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
              ElevatedButtonWidget(
                title: (count != null && count! > 1)
                    ? '+$count Pasajeros a bordo'
                    : '+1 Pasajero a bordo',
                onPressed: onPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(children: [
        BlurWidget(
          child: child(context),
        ),
        child(context),
      ]),
    );
  }
}
