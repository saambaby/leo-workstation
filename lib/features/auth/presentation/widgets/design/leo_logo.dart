import 'package:flutter/cupertino.dart';

import '../../../../../core/theme/app_theme.dart';

/// LEO connexio wordmark (`.auth-logo`).
class LeoLogo extends StatelessWidget {
  const LeoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'LEO ', style: LeoTypography.logo),
          TextSpan(text: 'connexio', style: LeoTypography.logoAccent),
        ],
      ),
    );
  }
}
