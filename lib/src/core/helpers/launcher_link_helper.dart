import 'package:url_launcher/url_launcher.dart';

class LauncherLinkHelper {
  late final Uri _uri;

  LauncherLinkHelper({
    required String url,
  }) {
    _uri = Uri.parse(url);
  }

  Future<void> launchInBrowser() async {
    if (!await launchUrl(
      _uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $_uri';
    }
  }

  Future<void> launchInWebViewOrVC() async {
    if (!await launchUrl(
      _uri,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(
          headers: <String, String>{'my_header_key': 'my_header_value'}),
    )) {
      throw 'Could not launch $_uri';
    }
  }

  Future<void> launchInWebViewWithoutJavaScript() async {
    if (!await launchUrl(
      _uri,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: false),
    )) {
      throw 'Could not launch $_uri';
    }
  }

  Future<void> launchInWebViewWithoutDomStorage() async {
    if (!await launchUrl(
      _uri,
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
    )) {
      throw 'Could not launch $_uri';
    }
  }

  Future<void> launchUniversalLinkIos() async {
    final bool nativeAppLaunchSucceeded = await launchUrl(
      _uri,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        _uri,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
