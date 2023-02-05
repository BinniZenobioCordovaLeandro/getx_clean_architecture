import 'package:flutter/material.dart';

class DropdownButtonFormFieldWidget extends StatelessWidget {
  final List<dynamic>? listValue;
  final Function(dynamic value)? onChanged;
  final dynamic value;
  final String? labelText;
  final String? errorText;
  final bool? enabled;
  final bool? isExpanded;
  final EdgeInsets? contentPadding;

  const DropdownButtonFormFieldWidget({
    Key? key,
    required this.listValue,
    required this.onChanged,
    this.value,
    this.labelText,
    this.errorText,
    this.enabled = true,
    this.isExpanded = false,
    this.contentPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: isExpanded!,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        border: const OutlineInputBorder(),
        labelText: labelText,
        errorText: errorText,
      ),
      items: <DropdownMenuItem>[
        for (final value in listValue!)
          DropdownMenuItem(
            value: value,
            child: Text(
              '$value',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
      ],
      value: value,
      onChanged: enabled!
          ? (dynamic value) {
              if (onChanged != null) onChanged!(value);
            }
          : null,
    );
  }
}
