import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  final String? title;
  final EdgeInsets? margin;
  final bool? value;
  final Function(bool? boolean)? onChanged;

  const SwitchWidget({
    Key? key,
    this.title,
    this.margin = const EdgeInsets.all(0.0),
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$title',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Switch(
            value: value!,
            onChanged: (bool? boolean) {
              if (onChanged != null) onChanged!(boolean);
            },
          ),
        ],
      ),
    );
  }
}
