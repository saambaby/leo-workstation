import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';

/// Six-cell OTP input with auto-advance (auth MFA + privileged switch).
class OtpInputRow extends StatefulWidget {
  const OtpInputRow({
    super.key,
    required this.onCompleted,
    this.enabled = true,
  });

  final ValueChanged<String> onCompleted;
  final bool enabled;

  @override
  State<OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  static const _length = 6;
  final _controllers = List.generate(_length, (_) => TextEditingController());
  final _focusNodes = List.generate(_length, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      _controllers[index].text = value.characters.last;
    }
    if (value.isNotEmpty && index < _length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_code.length == _length) {
      widget.onCompleted(_code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_length, (i) {
        return Padding(
          padding: EdgeInsets.only(right: i < _length - 1 ? 8 : 0),
          child: SizedBox(
            width: 40,
            height: 48,
            child: Semantics(
              textField: true,
              label: 'Digit ${i + 1} of $_length',
              child: CupertinoTextField(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                enabled: widget.enabled,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(1),
                ],
                style: const TextStyle(
                  fontSize: 18,
                  color: LeoColors.signalWhite,
                ),
                decoration: BoxDecoration(
                  color: LeoColors.black700,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: LeoColors.black500),
                ),
                onChanged: (v) => _onChanged(i, v),
              ),
            ),
          ),
        );
      }),
    );
  }
}
