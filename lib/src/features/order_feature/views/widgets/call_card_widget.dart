import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/circle_avatar_image_widget.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_icon_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class CallCardWidget extends StatelessWidget {
  final String? avatarUrl;
  final String? name;
  final String? carPhoto;
  final String? carModel;
  final String? carPlate;
  final Function()? onPressed;

  const CallCardWidget({
    Key? key,
    required this.avatarUrl,
    required this.name,
    required this.carPhoto,
    required this.carModel,
    required this.carPlate,
    required this.onPressed,
  }) : super(key: key);

  child(BuildContext context) {
    return CardWidget(
      color: Colors.transparent,
      child: FractionallySizedBoxWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.00,
          ),
          child: WrapWidget(
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  SizedBox(
                    child: CircleAvatarImageWidget(
                      urlSvgOrImage: avatarUrl ??
                          'https://upload.wikimedia.org/wikipedia/commons/f/f4/User_Avatar_2.png',
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '$name',
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  VerticalDivider(
                    color: Theme.of(context).primaryColor,
                    thickness: 2.00,
                  ),
                  SizedBox(
                    child: CircleAvatarImageWidget(
                      urlSvgOrImage: carPhoto ??
                          'https://www.motorshow.me/uploadImages/GalleryPics/295000/B295521-2021-Peugeot-2008-GT--5-.jpg',
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '$carModel',
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.bodyText2?.copyWith(),
                          textAlign: TextAlign.right,
                        ),
                        TextWidget(
                          '$carPlate',
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ElevatedButtonIconWidget(
                  icon: Icons.call,
                  title: 'Llamar al vehiculo',
                  onPressed: onPressed,
                ),
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
