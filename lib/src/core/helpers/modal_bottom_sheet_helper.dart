import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pickpointer/src/core/widgets/safe_area_widget.dart';
import 'package:pickpointer/src/core/widgets/text_widget.dart';

class ModalBottomSheetHelper {
  final String? title;
  final BuildContext? context;
  final Widget? child;
  final Widget? childFooter;
  final bool? enableDrag;
  final bool? useRootNavigator;
  final bool? isDismissible;
  final bool? showGoback;
  final Function? onTapBack;
  final Function? onTapClose;
  final Function? complete;
  final EdgeInsetsGeometry? padding;

  ModalBottomSheetHelper({
    this.title,
    required this.context,
    this.child,
    this.childFooter,
    this.enableDrag = false,
    this.useRootNavigator = false,
    this.isDismissible = true,
    this.showGoback = false,
    this.onTapBack,
    this.onTapClose,
    this.complete,
    this.padding,
  }) {
    showMaterialModalBottomSheet(
        context: context!,
        enableDrag: enableDrag!,
        isDismissible: isDismissible!,
        useRootNavigator: useRootNavigator!,
        expand: false,
        bounce: false,
        clipBehavior: Clip.hardEdge,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
        barrierColor:
            Theme.of(context!).scaffoldBackgroundColor.withOpacity(0.3),
        builder: (BuildContext context) {
          final double maxHeight = ((MediaQuery.of(context).size.height -
                  MediaQuery.of(context).viewPadding.top -
                  (title != null ? 60 + (childFooter != null ? 60 : 0) : 0)) -
              MediaQuery.of(context).viewInsets.bottom);
          return Container(
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SafeAreaWidget(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null)
                      Container(
                        key: const Key('title'),
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        constraints: const BoxConstraints(
                          minHeight: 56,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                return Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (showGoback!)
                                      InkWell(
                                        child: const Icon(
                                          Icons.arrow_back_ios,
                                        ),
                                        onTap: () {
                                          if (onTapBack != null) {
                                            onTapBack!();
                                          }
                                        },
                                      ),
                                    Expanded(
                                      child: SizedBox(
                                        width: constraints.maxWidth,
                                        child: TextWidget(
                                          '$title',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                        .appBarTheme
                                                        .titleTextStyle
                                                        ?.color ??
                                                    Colors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      child: IconButton(
                                        enableFeedback: false,
                                        tooltip: 'Cerrar',
                                        icon: Icon(
                                          Icons.close_outlined,
                                          color: Theme.of(context)
                                                  .appBarTheme
                                                  .titleTextStyle
                                                  ?.color ??
                                              Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          if (onTapClose != null) onTapClose!();
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    Container(
                      key: const Key('children'),
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.3),
                      constraints: (maxHeight > 0)
                          ? BoxConstraints(
                              maxHeight: maxHeight,
                            )
                          : const BoxConstraints(),
                      width: double.infinity,
                      child: Container(
                        child: child,
                      ),
                    ),
                    if (childFooter != null)
                      Container(
                        key: const Key('footer'),
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.3),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: childFooter!,
                      )
                  ],
                ),
              ),
            ),
          );
        }).whenComplete(() {
      if (complete != null) complete!();
    });
  }
}
