import 'package:flutter/material.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool? showGoback;
  final Function? onPressedGoBack;
  final PreferredSizeWidget? bottom;

  const AppBarWidget({
    Key? key,
    this.title,
    this.actions,
    this.showGoback = false,
    this.onPressedGoBack,
    this.bottom,
  }) : super(key: key);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();

  @override
  Size get preferredSize {
    if (bottom != null) return const Size.fromHeight(90.0);
    return const Size.fromHeight(56.0);
  }
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: (widget.showGoback == true)
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              tooltip: 'Ir atras',
              onPressed: () {
                if (widget.onPressedGoBack != null) {
                  widget.onPressedGoBack!();
                } else {
                  Navigator.of(context).pop();
                }
              },
            )
          : null,
      // toolbarHeight: widget.bottom != null ? null : 56,
      elevation: 0,
      centerTitle: widget.title != null ? false : true,
      title: widget.title != null
          ? Text(
              '${widget.title}',
            )
          : null,
      actions: widget.actions,
      bottom: widget.bottom,
    );
  }
}
