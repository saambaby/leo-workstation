/// Barrel exports for auth design primitives.
library;

export 'design/auth_card.dart';
export 'design/auth_error_banner.dart';
export 'design/auth_stage.dart';
export 'design/leo_auth_sub.dart';
export 'design/leo_button.dart';
export 'design/leo_card.dart';
export 'design/leo_checkbox.dart';
export 'design/leo_chip.dart';
export 'design/leo_divider.dart';
export 'design/leo_link.dart';
export 'design/leo_logo.dart';
export 'design/leo_note.dart';
export 'design/leo_text_field.dart';

import 'package:flutter/cupertino.dart';

import 'design/auth_card.dart';
import 'design/auth_stage.dart';
import 'design/leo_auth_sub.dart';
import 'design/leo_logo.dart';
import 'design/leo_text_field.dart';

/// Legacy layout wrapper — prefer composing [AuthStage] + [AuthCard] directly.
class AuthScreenLayout extends StatelessWidget {
  const AuthScreenLayout({
    super.key,
    required this.subtitle,
    required this.child,
    this.width = AuthCardWidth.standard,
    this.alignTop = false,
  });

  final String subtitle;
  final Widget child;
  final AuthCardWidth width;
  final bool alignTop;

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
            child,
          ],
        ),
      ),
    );
  }
}

/// @deprecated Use [LeoTextField] instead.
typedef AuthTextField = LeoTextField;
