import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:pickpointer/src/core/widgets/blur_widget.dart';
import 'package:pickpointer/src/core/widgets/card_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/text_field_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class SearchDestinationCardWidget extends StatelessWidget {
  final List<Prediction>? predictions;
  final Function(Prediction prediction)? onTapPrediction;
  final Function(String string)? onChanged;

  const SearchDestinationCardWidget({
    Key? key,
    this.onChanged,
    this.predictions = const [],
    this.onTapPrediction,
  }) : super(key: key);

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
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: WrapWidget(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          for (var i = 0; i < predictions!.length; i++)
                            SizedBox(
                              width: double.infinity,
                              child: CardWidget(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: onTapPrediction != null
                                      ? () {
                                          onTapPrediction!(predictions![i]);
                                        }
                                      : null,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: FractionallySizedBoxWidget(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: TextWidget(
                                          '${predictions?[i].description}',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextFieldWidget(
                          labelText: 'Destination',
                          onChanged: onChanged,
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
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: WrapWidget(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        for (var i = 0; i < predictions!.length; i++)
                          SizedBox(
                            width: double.infinity,
                            child: CardWidget(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: onTapPrediction != null
                                    ? () {
                                        onTapPrediction!(predictions![i]);
                                      }
                                    : null,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: FractionallySizedBoxWidget(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: TextWidget(
                                        '${predictions?[i].description}',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextFieldWidget(
                        labelText: 'Destination',
                        onChanged: onChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
