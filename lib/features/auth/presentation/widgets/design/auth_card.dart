import 'package:flutter/cupertino.dart';

import '../../../../../core/theme/app_theme.dart';

/// Auth card width presets matching HTML `.auth-card` variants.
enum AuthCardWidth {
  standard(420),
  wide(460),
  enroll(480);

  const AuthCardWidth(this.width);
  final double width;
}

/// Dark card chrome (`.auth-card`).
class AuthCard extends StatelessWidget {
  const AuthCard({
    super.key,
    required this.child,
    this.width = AuthCardWidth.standard,
  });

  final Widget child;
  final AuthCardWidth width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: LeoColors.black800,
          borderRadius: BorderRadius.circular(LeoRadii.xl),
          border: Border.all(color: LeoColors.black600),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 32),
          child: child,
        ),
      ),
    );
  }
}
