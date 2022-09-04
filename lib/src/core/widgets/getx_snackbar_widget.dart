import 'package:get/get.dart';

class GetxSnackbarWidget {
  final String title;
  final String subtitle;
  final Duration? duration;

  GetxSnackbarWidget({
    required this.title,
    required this.subtitle,
    this.duration = const Duration(seconds: 5),
  }) {
    Get.snackbar(
      title,
      subtitle,
      duration: duration,
      barBlur: 70.0,
    );
  }
}
