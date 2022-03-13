import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/circle_avatar_image_widget.dart';
import 'package:pickpointer/src/core/widgets/elevated_button_icon_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class CallCardWidget extends StatelessWidget {
  const CallCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          BlurWidget(
            child: CardWidget(
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
                          const SizedBox(
                            child: CircleAvatarImageWidget(
                              urlSvgOrImage:
                                  'https://www.niemanlab.org/images/Greg-Emerson-edit-2.jpg',
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Roberto Gomez Bolaños De La Cruz',
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
                          const SizedBox(
                            child: CircleAvatarImageWidget(
                              urlSvgOrImage:
                                  'https://www.motorshow.me/uploadImages/GalleryPics/295000/B295521-2021-Peugeot-2008-GT--5-.jpg',
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Hyundai Negro',
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(),
                                  textAlign: TextAlign.right,
                                ),
                                TextWidget(
                                  'CKI-CKÑ',
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.headline6,
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
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          CardWidget(
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
                        const SizedBox(
                          child: CircleAvatarImageWidget(
                            urlSvgOrImage:
                                'https://www.niemanlab.org/images/Greg-Emerson-edit-2.jpg',
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Roberto Gomez Bolaños De La Cruz',
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
                        const SizedBox(
                          child: CircleAvatarImageWidget(
                            urlSvgOrImage:
                                'https://www.motorshow.me/uploadImages/GalleryPics/295000/B295521-2021-Peugeot-2008-GT--5-.jpg',
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Hyundai Negro',
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(),
                                textAlign: TextAlign.right,
                              ),
                              TextWidget(
                                'CKI-CKÑ',
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
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
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
