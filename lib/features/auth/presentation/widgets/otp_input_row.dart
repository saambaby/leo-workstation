import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';

/// Six-cell OTP input with auto-advance (auth MFA + privileged switch).
class OtpInputRow extends StatefulWidget {
  const OtpInputRow({
    super.key,
    this.onCompleted,
    this.onChanged,
    this.autoSubmitOnComplete = false,
    this.enabled = true,
  });

  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final bool autoSubmitOnComplete;
  final bool enabled;

  @override
  State<OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  static const _length = 6;
  static const _cellWidth = 46.0;
  static const _cellHeight = 54.0;
  static const _gap = 8.0;

  final _controllers = List.generate(_length, (_) => TextEditingController());
  final _focusNodes = List.generate(_length, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (final node in _focusNodes) {
      node.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.removeListener(_onFocusChange);
      node.dispose();
    }
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  String get _code => _controllers.map((c) => c.text).join();

  void _notifyChanged() => widget.onChanged?.call(_code);

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      _controllers[index].text = value.characters.last;
    }
    if (value.isNotEmpty && index < _length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
    _notifyChanged();
    if (widget.autoSubmitOnComplete &&
        _code.length == _length &&
        widget.onCompleted != null) {
      widget.onCompleted!(_code);
    }
  }

  Color _borderColor(int index) {
    if (_focusNodes[index].hasFocus) return LeoColors.black200;
    if (_controllers[index].text.isNotEmpty) return LeoColors.black400;
    return LeoColors.black500;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(_length, (i) {
          return Padding(
            padding: EdgeInsets.only(right: i < _length - 1 ? _gap : 0),
            child: SizedBox(
              width: _cellWidth,
              height: _cellHeight,
              child: Semantics(
                textField: true,
                label: 'Digit ${i + 1} of $_length',
                child: CupertinoTextField(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  enabled: widget.enabled,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(1),
                  ],
                  style: LeoTypography.otpCell.copyWith(height: 1),
                  strutStyle: const StrutStyle(
                    fontSize: 22,
                    height: 1,
                    forceStrutHeight: true,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _focusNodes[i].hasFocus
                        ? LeoColors.black600
                        : LeoColors.black700,
                    borderRadius: BorderRadius.circular(LeoRadii.md),
                    border: Border.all(color: _borderColor(i)),
                  ),
                  onChanged: (v) => _onChanged(i, v),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
