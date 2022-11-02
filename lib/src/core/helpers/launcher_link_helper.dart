import 'package:url_launcher/url_launcher.dart';

class LauncherLinkHelper {
  late final Uri _uri;

  LauncherLinkHelper({
    required String url,
    bool? isPhone,
    bool? isMail,
  }) {
    if (isPhone == true) {
      _uri = Uri(
        scheme: 'tel',
        path: url,
      );
    } else if (isMail == true) {
      _uri = Uri(
        scheme: 'mailto',
        path: url,
      );
    } else {
      _uri = Uri.parse(url);
    }
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

  Future<void> makePhoneCall() async {
    await launchUrl(_uri);
  }

  Future<void> sendEmail() async {
    await launchUrl(_uri);
  }
}
