import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/svg_or_image_widget.dart';

class CircleAvatarImageWidget extends StatefulWidget {
  final String? urlSvgOrImage;
  final double? radius;

  const CircleAvatarImageWidget({
    Key? key,
    this.urlSvgOrImage,
    this.radius = 20,
  }) : super(key: key);

  @override
  State<CircleAvatarImageWidget> createState() =>
      _CircleAvatarImageWidgetState();
}

class _CircleAvatarImageWidgetState extends State<CircleAvatarImageWidget> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isActive = !isActive;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 3),
        child: AnimatedScale(
          scale: isActive ? 2.0 : 1.0,
          duration: const Duration(seconds: 1),
          alignment: Alignment.bottomLeft,
          curve: Curves.easeInOut,
          child: CircleAvatar(
            radius: widget.radius,
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(widget.radius!),
              ),
              child: SvgOrImageWidget(
                urlSvgOrImage: widget.urlSvgOrImage,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
