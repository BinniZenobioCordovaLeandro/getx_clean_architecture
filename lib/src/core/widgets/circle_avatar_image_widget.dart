import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/svg_or_image_widget.dart';

class CircleAvatarImageWidget extends StatelessWidget {
  final String? urlSvgOrImage;
  final double? radius;

  const CircleAvatarImageWidget({
    Key? key,
    this.urlSvgOrImage,
    this.radius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(radius!),
        ),
        child: SvgOrImageWidget(
          urlSvgOrImage: urlSvgOrImage,
        ),
      ),
    );
  }
}
