import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';

class ProgressStateButtonWidget extends StatelessWidget {
  final String? idle;
  final String? loading;
  final String? fail;
  final String? success;
  final Function? onPressed;
  final ButtonState? state;
  final double? radius;
  final Color? color;
  final Color? background;
  final CircularProgressIndicator? progressIndicator;

  const ProgressStateButtonWidget({
    Key? key,
    this.idle,
    this.loading,
    this.fail,
    this.success,
    this.onPressed,
    this.state = ButtonState.success,
    this.radius = 8.00,
    this.color,
    this.background,
    this.progressIndicator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ProgressButton(
        stateWidgets: {
          ButtonState.idle: Text(
            '${idle ?? success}',
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(color: color ?? Colors.white),
          ),
          ButtonState.loading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${loading ?? success}',
              style: Theme.of(context)
                  .textTheme
                  .button!
                  .copyWith(color: color ?? Colors.white),
            ),
          ),
          ButtonState.fail: Text(
            '${fail ?? success}',
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(color: color ?? Colors.white),
          ),
          ButtonState.success: Text(
            '$success',
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(color: color ?? Colors.white),
          )
        },
        stateColors: {
          ButtonState.idle:
              background?.withOpacity(0.3) ?? Theme.of(context).primaryColor,
          ButtonState.loading:
              background?.withOpacity(0.3) ?? Theme.of(context).primaryColor,
          ButtonState.fail: background ?? Theme.of(context).primaryColor,
          ButtonState.success: background ?? Theme.of(context).primaryColor,
        },
        onPressed: state != ButtonState.idle
            ? () {
                if (state != ButtonState.idle && state != ButtonState.loading) {
                  onPressed!();
                }
              }
            : null,
        state: state,
        padding: const EdgeInsets.all(8.0),
        radius: radius!,
        progressIndicatorAlignment: MainAxisAlignment.center,
        progressIndicator: progressIndicator ??
            CircularProgressIndicator(
              backgroundColor: color,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
      ),
    );
  }
}
