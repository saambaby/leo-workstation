import 'package:flutter/cupertino.dart';

import '../../../../../core/theme/app_theme.dart';

/// Full-screen auth shell with grid background (`.auth-stage` + `.auth-grid-bg`).
class AuthStage extends StatelessWidget {
  const AuthStage({
    super.key,
    required this.child,
    this.alignTop = false,
    this.topPadding = 30,
  });

  final Widget child;
  final bool alignTop;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: LeoColors.black900,
      child: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: _AuthGridPainter())),
          SafeArea(
            child: alignTop
                ? SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24, topPadding, 24, 24),
                    child: Center(child: child),
                  )
                : Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: child,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _AuthGridPainter extends CustomPainter {
  const _AuthGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const gridSize = 40.0;
    final paint = Paint()
      ..color = const Color.fromRGBO(255, 255, 255, 0.02)
      ..strokeWidth = 1;

    for (var x = 0.0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
