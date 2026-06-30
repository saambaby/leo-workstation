import 'package:flutter/cupertino.dart';

import '../../l10n/auth_strings.dart';
import 'auth_screen_layout.dart';
import 'otp_input_row.dart';

/// Shared MFA OTP entry + verify button block.
class MfaCodeForm extends StatefulWidget {
  const MfaCodeForm({
    super.key,
    required this.loading,
    required this.onSubmit,
    this.onCodeChanged,
    this.autoSubmitOnComplete = false,
    this.submitLabel = AuthStrings.verifyAndContinue,
  });

  final bool loading;
  final Future<void> Function(String code) onSubmit;
  final ValueChanged<String>? onCodeChanged;
  final bool autoSubmitOnComplete;
  final String submitLabel;

  @override
  State<MfaCodeForm> createState() => _MfaCodeFormState();
}

class _MfaCodeFormState extends State<MfaCodeForm> {
  var _code = '';

  Future<void> _submit() async {
    if (_code.length != 6) return;
    await widget.onSubmit(_code);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OtpInputRow(
          enabled: !widget.loading,
          autoSubmitOnComplete: widget.autoSubmitOnComplete,
          onChanged: (code) {
            setState(() => _code = code);
            widget.onCodeChanged?.call(code);
          },
          onCompleted: widget.autoSubmitOnComplete ? (_) => _submit() : null,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: LeoButton(
            label: widget.submitLabel,
            fullWidth: true,
            enabled: !widget.loading && _code.length == 6,
            onPressed: _submit,
          ),
        ),
      ],
    );
  }
}
