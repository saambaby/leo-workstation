import 'package:flutter/cupertino.dart';

import 'auth_screen_layout.dart';

/// Composes the standard auth card shell: stage, card, logo, subtitle, error.
class AuthFormShell extends StatelessWidget {
  const AuthFormShell({
    super.key,
    required this.subtitle,
    required this.child,
    this.error,
    this.width = AuthCardWidth.standard,
    this.alignTop = false,
    this.header,
  });

  final String subtitle;
  final Widget child;
  final String? error;
  final AuthCardWidth width;
  final bool alignTop;

  /// Optional widgets between subtitle and [child] (e.g. info notes).
  final List<Widget>? header;

  @override
  Widget build(BuildContext context) {
    return AuthStage(
      alignTop: alignTop,
      child: AuthCard(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LeoLogo(),
            LeoAuthSub(subtitle),
            if (error != null) ...[
              AuthErrorBanner(message: error!),
              const SizedBox(height: 16),
            ],
            if (header != null) ...header!,
            child,
          ],
        ),
      ),
    );
  }
}
