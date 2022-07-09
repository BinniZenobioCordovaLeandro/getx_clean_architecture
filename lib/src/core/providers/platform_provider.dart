import 'package:flutter/material.dart';
import 'package:pickpointer/src/core/enums/platform_enum.dart';

class PlatformProvider {
  static PlatformProvider? _instance;

  static PlatformProvider? getInstance() {
    _instance ??= PlatformProvider();
    return _instance;
  }

  PlatformEnum getPlatformEnum({
    required BuildContext context,
  }) {
    if (Theme.of(context).platform == TargetPlatform.android) {
      return PlatformEnum.android;
    }
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return PlatformEnum.iOS;
    }
    if (Theme.of(context).platform == TargetPlatform.fuchsia) {
      return PlatformEnum.fuchsia;
    }
    if (Theme.of(context).platform == TargetPlatform.linux) {
      return PlatformEnum.linux;
    }
    if (Theme.of(context).platform == TargetPlatform.macOS) {
      return PlatformEnum.macOS;
    }
    if (Theme.of(context).platform == TargetPlatform.windows) {
      return PlatformEnum.windows;
    }
    return PlatformEnum.web;
  }
}
