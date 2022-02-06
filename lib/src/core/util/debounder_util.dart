import 'dart:async';
import 'package:flutter/material.dart';

class Debouncer {
  final int milliseconds;

  Debouncer({
    this.milliseconds = 500,
  });
  
  Timer? _timer;

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(
      Duration(milliseconds: milliseconds),
      action,
    );
  }
}
