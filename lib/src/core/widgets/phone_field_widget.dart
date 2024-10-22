import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneFieldWidget extends StatelessWidget {
  final String? code;
  final String? number;
  final void Function(String value)? onPhoneChanged;
  final void Function(String value)? onCountryChanged;

  const PhoneFieldWidget({
    Key? key,
    this.code,
    this.number,
    this.onPhoneChanged,
    this.onCountryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: InputDecoration(
        labelText: 'Teléfono',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      initialCountryCode: code ?? '+51',
      initialValue: number,
      onChanged: (phone) => onPhoneChanged!(phone.number),
      onCountryChanged: (country) {
        print(country.dialCode);
        onCountryChanged!("+${country.dialCode}");
      },
    );
  }
}
