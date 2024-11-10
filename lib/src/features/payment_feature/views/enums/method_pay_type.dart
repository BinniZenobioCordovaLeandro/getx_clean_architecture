enum MethodPayType {
  wallet,
  cash,
  yape,
  plin,
}

extension MethodPayTypeExtension on MethodPayType {
  int? get value {
    if (this == MethodPayType.wallet) return 1;
    if (this == MethodPayType.cash) return 2;
    if (this == MethodPayType.yape) return 3;
    if (this == MethodPayType.plin) return 4;
    return null;
  }

  String? get label {
    if (this == MethodPayType.wallet) return 'wallet';
    if (this == MethodPayType.cash) return 'cash';
    if (this == MethodPayType.yape) return 'yape';
    if (this == MethodPayType.plin) return 'plin';
    return null;
  }

  String? get description {
    if (this == MethodPayType.wallet) return 'Wallet';
    if (this == MethodPayType.cash) return 'Cash';
    if (this == MethodPayType.yape) return 'Yape';
    if (this == MethodPayType.plin) return 'Plin';
    return null;
  }

  String? get link {
    if (this == MethodPayType.wallet) {
      return "https://play.google.com/store/apps/details?id=com.pickpointer.app";
    }
    if (this == MethodPayType.cash) {
      return "https://itunes.apple.com/app/id1023455677";
    }
    if (this == MethodPayType.yape) {
      return "https://itunes.apple.com/app/id1023455677";
    }
    if (this == MethodPayType.plin) {
      return "https://itunes.apple.com/app/id1023455677";
    }
    return null;
  }
}
