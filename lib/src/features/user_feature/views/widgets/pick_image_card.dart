import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/providers/media_picker_provider.dart';
import 'package:pickpointer/src/core/widgets/ink_well_widget.dart';
import 'package:pickpointer/src/core/widgets/svg_or_image_widget.dart';

class PickImageCard extends StatefulWidget {
  final String? urlSvgOrImage;
  final Function(String? string)? onChanged;

  const PickImageCard({
    Key? key,
    this.urlSvgOrImage,
    this.onChanged,
  }) : super(key: key);

  @override
  State<PickImageCard> createState() => _PickImageCardState();
}

class _PickImageCardState extends State<PickImageCard> {
  String? path;

  @override
  Widget build(BuildContext context) {
    return InkWellWidget(
      onTap: widget.onChanged != null
          ? () {
              MediaPickerProvider.getInstance()!
                  .getCameraImage()
                  .then((String? value) {
                widget.onChanged!(value);
                setState(() {
                  path = value;
                });
              });
            }
          : null,
      child: AspectRatio(
        aspectRatio: 3 / 1,
        child: Stack(
          children: [
            Center(
              child: SvgOrImageWidget(
                key: Key('$path'),
                urlSvgOrImage: widget.urlSvgOrImage,
              ),
            ),
            const Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 44,
                ),
              ),
            ),
            const Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
