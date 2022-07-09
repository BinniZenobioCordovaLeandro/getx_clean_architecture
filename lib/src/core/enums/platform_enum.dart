enum PlatformEnum {
  android,
  iOS,
  fuchsia,
  linux,
  macOS,
  windows,
  web,
}

extension PlatformEnumExtension on PlatformEnum {
  int? get value {
    if (this == PlatformEnum.android) return 1;
    if (this == PlatformEnum.iOS) return 2;
    if (this == PlatformEnum.fuchsia) return 3;
    if (this == PlatformEnum.linux) return 4;
    if (this == PlatformEnum.macOS) return 5;
    if (this == PlatformEnum.windows) return 6;
    if (this == PlatformEnum.web) return 7;
    return null;
  }

  String? get label {
    if (this == PlatformEnum.android) return 'android';
    if (this == PlatformEnum.iOS) return 'iOS';
    if (this == PlatformEnum.fuchsia) return 'fuchsia';
    if (this == PlatformEnum.linux) return 'linux';
    if (this == PlatformEnum.macOS) return 'macOS';
    if (this == PlatformEnum.windows) return 'windows';
    if (this == PlatformEnum.web) return 'web';
    return null;
  }

  String? get description {
    if (this == PlatformEnum.android) return 'Android';
    if (this == PlatformEnum.iOS) return 'IOS';
    if (this == PlatformEnum.fuchsia) return 'Fuchsia';
    if (this == PlatformEnum.linux) return 'Linux';
    if (this == PlatformEnum.macOS) return 'MacOS';
    if (this == PlatformEnum.windows) return 'Windows';
    if (this == PlatformEnum.web) return 'Web';
    return null;
  }

  String? get link {
    if (this == PlatformEnum.android) {
      return "https://play.google.com/store/apps/details?id=com.pickpointer.app";
    }
    if (this == PlatformEnum.iOS) {
      return "https://itunes.apple.com/app/id1023455677";
    }
    if (this == PlatformEnum.linux) {
      return "https://itunes.apple.com/app/id1023455677";
    }
    if (this == PlatformEnum.macOS) {
      return "https://itunes.apple.com/app/id1023455677";
    }
    if (this == PlatformEnum.windows) {
      return "https://itunes.apple.com/app/id1023455677";
    }
    return "https://pickpointer.com";
  }
}
