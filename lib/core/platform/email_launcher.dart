import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

/// Opens the user's default mail client (iOS: Mail app; others: mailto handler).
Future<void> openEmailApp() async {
  final uri = Platform.isIOS
      ? Uri.parse('message://')
      : Uri(scheme: 'mailto');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
