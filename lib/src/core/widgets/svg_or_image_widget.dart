import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pickpointer/src/core/widgets/cached_network_image_widget.dart';

class SvgOrImageWidget extends StatelessWidget {
  final String? urlSvgOrImage;
  final Color? color;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry? alignment;

  const SvgOrImageWidget({
    Key? key,
    required this.urlSvgOrImage,
    this.color,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform != TargetPlatform.iOS &&
        Theme.of(context).platform != TargetPlatform.android) {
      if (urlSvgOrImage != null) {
        return Container(
          key: Key('$urlSvgOrImage'),
          alignment: alignment,
          width: width,
          height: height,
          child: Image.network(
            '$urlSvgOrImage',
            alignment: alignment ?? Alignment.center,
            fit: fit,
          ),
        );
      } else {
        return Container(
          alignment: alignment,
          key: Key(
            '$urlSvgOrImage',
          ),
          child: Text('$urlSvgOrImage'),
        );
      }
    } else {
      RegExp regExp = RegExp('.svg\$');
      if (urlSvgOrImage != null && regExp.hasMatch(urlSvgOrImage!)) {
        return SvgPicture.network(
          '$urlSvgOrImage',
          alignment: alignment ?? Alignment.center,
          key: Key('$urlSvgOrImage'),
          width: width,
          height: height,
          fit: fit!,
          color: color,
        );
      } else if (urlSvgOrImage != null) {
        return Container(
          alignment: alignment,
          width: width,
          height: height,
          child: CachedNetworkImageWidget(
            key: Key('$urlSvgOrImage'),
            fit: fit,
            url: urlSvgOrImage,
          ),
        );
      } else {
        return Container(
          alignment: alignment,
          key: Key(
            '$urlSvgOrImage',
          ),
          child: Text('$urlSvgOrImage'),
        );
      }
    }
  }
}
