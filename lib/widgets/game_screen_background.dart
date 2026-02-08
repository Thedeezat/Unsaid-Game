import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class GameScreenBackground extends StatelessWidget {
  const GameScreenBackground({
    super.key,
    required this.child,
    this.backgroundOpacity = 0.8,
  });

  final Widget child;
  final double backgroundOpacity;

  static const Color _bgColor = Color(0xFFB2E9FF);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFF5FBFF),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _bgColor.withValues(alpha: backgroundOpacity),
                const Color(0xFFC5EFFF).withValues(alpha: backgroundOpacity),
                const Color(0xFFD8F4FF).withValues(alpha: backgroundOpacity),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _GameGridPatternPainter(),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _GameScatteredPatternPainter(),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _GameShapePatternPainter(),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 0.8, sigmaY: 0.8),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.18),
                      Colors.white.withValues(alpha: 0.08),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _GameGridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;
    const spacing = 14.0;
    for (var x = 0.0; x < size.width + spacing; x += spacing) {
      for (var y = 0.0; y < size.height + spacing; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
    paint.color = Colors.white.withValues(alpha: 0.25);
    const offset = 7.0;
    for (var x = offset; x < size.width + spacing + offset; x += spacing) {
      for (var y = offset; y < size.height + spacing + offset; y += spacing) {
        canvas.drawCircle(Offset(x, y), 0.8, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GameScatteredPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = _SeededRandom(12345);
    final paint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 120; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final radius = 2.5 + rnd.nextDouble() * 10.0;
      paint.color = Colors.white.withValues(alpha: 0.15 + rnd.nextDouble() * 0.18);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
    final rnd2 = _SeededRandom(67890);
    for (var i = 0; i < 80; i++) {
      final x = rnd2.nextDouble() * size.width;
      final y = rnd2.nextDouble() * size.height;
      final radius = 1.5 + rnd2.nextDouble() * 4.0;
      paint.color = Colors.white.withValues(alpha: 0.1 + rnd2.nextDouble() * 0.12);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GameShapePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = AppTheme.primaryBlue.withValues(alpha: 0.06);
    final path1 = Path()
      ..moveTo(0, size.height * 0.75)
      ..lineTo(size.width * 0.35, size.height * 0.55)
      ..lineTo(size.width * 0.5, size.height * 0.9)
      ..close();
    canvas.drawPath(path1, paint);

    paint.color = Colors.white.withValues(alpha: 0.1);
    final path2 = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width * 0.65, size.height * 0.25)
      ..lineTo(size.width * 0.85, size.height * 0.45)
      ..close();
    canvas.drawPath(path2, paint);

    paint.color = AppTheme.primaryBlueLight.withValues(alpha: 0.07);
    final path3 = Path()
      ..moveTo(size.width * 0.05, size.height * 0.15)
      ..lineTo(size.width * 0.45, 0)
      ..lineTo(size.width * 0.3, size.height * 0.3)
      ..close();
    canvas.drawPath(path3, paint);

    paint.color = AppTheme.primaryBlue.withValues(alpha: 0.04);
    final path4 = Path()
      ..moveTo(size.width * 0.6, size.height * 0.7)
      ..lineTo(size.width, size.height * 0.5)
      ..lineTo(size.width * 0.8, size.height)
      ..close();
    canvas.drawPath(path4, paint);

    paint.color = Colors.white.withValues(alpha: 0.06);
    final path5 = Path()
      ..moveTo(0, size.height * 0.35)
      ..lineTo(size.width * 0.2, size.height * 0.2)
      ..lineTo(size.width * 0.15, size.height * 0.5)
      ..close();
    canvas.drawPath(path5, paint);
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

Widget gameScreenIconButton({
  required IconData icon,
  required VoidCallback onPressed,
  Color? iconColor,
}) {
  return IconButton(
    icon: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: iconColor ?? const Color(0xFF555555), size: 22),
    ),
    onPressed: onPressed,
  );
}

Widget gameScreenPrimaryButton({
  required VoidCallback onPressed,
  required IconData icon,
  required String label,
}) {
  return Container(
    height: 56,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppTheme.primaryBlue, AppTheme.primaryBlueDark],
      ),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: AppTheme.primaryBlue.withValues(alpha: 0.4),
          blurRadius: 14,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _GameButtonDotsPainter(),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(18),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _GameButtonDotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    const spacing = 10.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
