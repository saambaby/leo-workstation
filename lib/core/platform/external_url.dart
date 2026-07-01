import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in the system browser when the platform can handle it.
Future<void> launchExternalUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
