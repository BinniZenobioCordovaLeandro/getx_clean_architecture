import 'package:share_plus/share_plus.dart';

class ShareProvider {
  ShareProvider();

  string(String string, {String? subject}) {
    Share.share(
      string,
      subject: subject,
    );
  }

  fileFromPath(String path, {String? subject, String? text}) {
    Share.shareFiles(
      [path],
      subject: subject,
      text: text,
    );
  }
}
