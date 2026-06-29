import 'package:flutter/cupertino.dart';

import '../../../../core/theme/app_theme.dart';
import '../../l10n/auth_strings.dart';

/// Dark Cupertino layout shared by auth screens.
class AuthScreenLayout extends StatelessWidget {
  const AuthScreenLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: LeoColors.black900,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    AuthStrings.appTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: LeoColors.signalWhite,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: LeoColors.signalWhite,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: LeoColors.black100,
                        height: 1.4,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: LeoColors.black100,
            ),
          ),
          const SizedBox(height: 6),
          CupertinoTextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: LeoColors.black700,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: LeoColors.black500),
            ),
            style: const TextStyle(color: LeoColors.signalWhite),
            placeholderStyle: const TextStyle(color: LeoColors.black300),
          ),
        ],
      ),
    );
  }
}

class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: LeoColors.signalError.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: LeoColors.signalError.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        message,
        style: const TextStyle(color: LeoColors.signalError, fontSize: 13),
      ),
    );
  }
}
