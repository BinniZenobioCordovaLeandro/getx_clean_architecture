import 'package:flutter/material.dart';

class RankWidget extends StatefulWidget {
  final double maxValue;
  final double minValue;
  final double value;
  final Function(double value)? onChanged;

  const RankWidget({
    Key? key,
    this.maxValue = 5.0,
    this.minValue = 1.0,
    this.value = 5.0,
    this.onChanged,
  }) : super(key: key);

  @override
  _RankWidgetState createState() => _RankWidgetState();
}

class _RankWidgetState extends State<RankWidget> {
  double value = 5.0;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        fit: StackFit.loose,
        children: [
          SizedBox(
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = widget.minValue; i <= widget.maxValue; i++)
                  IconButton(
                    tooltip: 'rank $i',
                    icon: Icon(
                      (i <= value) ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 35,
                    ),
                    onPressed: () {
                      setState(() {
                        value = i.toDouble();
                        if (widget.onChanged != null) {
                          widget.onChanged!(value);
                        }
                      });
                    },
                  )
              ],
            ),
          ),
          Positioned.fill(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.3,
              child: Slider(
                activeColor: Colors.transparent,
                inactiveColor: Colors.transparent,
                thumbColor: Colors.transparent,
                value: value,
                max: widget.maxValue,
                min: widget.minValue,
                divisions: widget.maxValue.toInt() - 1,
                onChanged: (widget.onChanged != null)
                    ? (double value) {
                        setState(() {
                          value = value;
                          if (widget.onChanged != null) {
                            widget.onChanged!(value);
                          }
                        });
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
