import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class PatternedBackground extends StatelessWidget {
  const PatternedBackground({
    super.key,
    required this.child,
    this.blend = true,
  });

  final Widget child;
  final bool blend;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFFE8F5E0),
                Color(0xFFF0F4E8),
                Color(0xFFF5F5F5),
                Color(0xFFE8F0FF),
                AppTheme.gradientEnd,
              ],
              stops: [0.0, 0.3, 0.5, 0.75, 1.0],
            ),
          ),
        ),
        CustomPaint(
          painter: _PolygonPatternPainter(),
          size: Size.infinite,
        ),
        // Scattered dots (particles)
        CustomPaint(
          painter: _DotsPainter(),
          size: Size.infinite,
        ),
        if (blend)
          Positioned.fill(
            child: IgnorePointer(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                child: Container(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ),
          ),
        child,
      ],
    );
  }
}

class _PolygonPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppTheme.primaryBlue.withValues(alpha: 0.06);

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.4, size.height * 0.5);
    path.lineTo(size.width * 0.6, size.height * 0.85);
    path.close();
    canvas.drawPath(path, paint);

    paint.color = const Color(0xFFE8F5E0).withValues(alpha: 0.5);
    final path2 = Path();
    path2.moveTo(size.width, 0);
    path2.lineTo(size.width * 0.7, size.height * 0.3);
    path2.lineTo(size.width * 0.85, size.height * 0.5);
    path2.close();
    canvas.drawPath(path2, paint);

    paint.color = AppTheme.primaryBlueLight.withValues(alpha: 0.08);
    final path3 = Path();
    path3.moveTo(size.width * 0.1, size.height * 0.2);
    path3.lineTo(size.width * 0.5, 0);
    path3.lineTo(size.width * 0.35, size.height * 0.35);
    path3.close();
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final rnd = _SeededRandom(42);
    for (var i = 0; i < 80; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final radius = 1.2 + rnd.nextDouble() * 1.5;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SeededRandom {
  _SeededRandom(this.seed);

  int seed;

  double nextDouble() {
    seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    return seed / 0x7fffffff;
  }
}
