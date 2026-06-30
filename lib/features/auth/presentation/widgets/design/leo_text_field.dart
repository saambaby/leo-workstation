import 'package:flutter/cupertino.dart';

import '../../../../../core/theme/app_theme.dart';

/// Label + input field (`.field-label` + `.input`).
class LeoTextField extends StatefulWidget {
  const LeoTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.placeholder,
    this.bottomSpacing = 0,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? placeholder;
  final double bottomSpacing;

  @override
  State<LeoTextField> createState() => _LeoTextFieldState();
}

class _LeoTextFieldState extends State<LeoTextField> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final focused = _focusNode.hasFocus;

    return Padding(
      padding: EdgeInsets.only(bottom: widget.bottomSpacing),
      child: Semantics(
        textField: true,
        label: widget.label,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.label, style: LeoTypography.fieldLabel),
            const SizedBox(height: 6),
            CupertinoTextField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              placeholder: widget.placeholder,
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
              decoration: BoxDecoration(
                color: focused ? LeoColors.black600 : LeoColors.black700,
                borderRadius: BorderRadius.circular(LeoRadii.md),
                border: Border.all(
                  color: focused ? LeoColors.black300 : LeoColors.black500,
                ),
              ),
              style: LeoTypography.input,
              placeholderStyle: LeoTypography.inputPlaceholder,
            ),
          ],
        ),
      ),
    );
  }
}
