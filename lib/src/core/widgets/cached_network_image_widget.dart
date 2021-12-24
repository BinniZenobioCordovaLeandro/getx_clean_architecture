import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/shimmer_widget.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String? url;
  final BoxFit? fit;

  const CachedNetworkImageWidget({
    Key? key,
    required this.url,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url != null) {
      return CachedNetworkImage(
        imageUrl: '$url',
        fit: fit,
        imageBuilder:
            (BuildContext context, ImageProvider<Object> imageProvider) =>
                Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
              colorFilter: const ColorFilter.mode(
                Colors.transparent,
                BlendMode.colorBurn,
              ),
            ),
          ),
        ),
        placeholder: (BuildContext context, String url) => ShimmerWidget(
          child: Container(
            color: Colors.black,
          ),
        ),
        errorWidget: (BuildContext context, String url, dynamic error) =>
            const Icon(
          Icons.error,
        ),
      );
    }
    return Container();
  }
}
