import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/widgets/app_bar_widget.dart';
import 'package:pickpointer/src/core/widgets/fractionally_sized_box_widget.dart';
import 'package:pickpointer/src/core/widgets/safe_area_widget.dart';
import 'package:pickpointer/src/core/widgets/shimmer_widget.dart';
import 'package:pickpointer/src/core/widgets/single_child_scroll_view_widget.dart';
import 'package:pickpointer/src/core/widgets/wrap_widget.dart';

class ScaffoldScrollWidget extends StatelessWidget {
  final String? title;
  final bool? isLoading;
  final List<Widget> children;
  final Widget? footer;

  const ScaffoldScrollWidget({
    Key? key,
    this.title,
    this.isLoading = false,
    required this.children,
    this.footer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBarWidget(
        title: '$title',
        showGoback: true,
      ),
      body: SafeAreaWidget(
        child: SingleChildScrollViewWidget(
          child: Center(
            child: FractionallySizedBoxWidget(
              child: ShimmerWidget(
                enabled: isLoading,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: WrapWidget(
                    children: children,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      persistentFooterButtons: (footer != null)
          ? [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: FractionallySizedBoxWidget(
                    child: footer,
                  ),
                ),
              ),
            ]
          : null,
    );
  }
}
