import 'package:flutter/cupertino.dart';

import '../../../../../core/theme/app_theme.dart';

class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: LeoColors.signalError.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(LeoRadii.md),
        border: Border.all(
          color: LeoColors.signalError.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        message,
        style: LeoTypography.note.copyWith(color: LeoColors.signalError),
      ),
    );
  }
}
