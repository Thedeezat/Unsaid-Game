import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'instructions_screen.dart';
import 'player_setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(color: AppTheme.surfaceLight),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/background3.jpg',
              fit: BoxFit.cover,
              alignment: const Alignment(0, 0.25),
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppTheme.surfaceLight,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.25),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.9),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/profile.jpg',
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.white.withValues(alpha: 0.9),
                                child: const Icon(Icons.person_rounded, color: AppTheme.primaryBlue, size: 26),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const InstructionsScreen(),
                            ),
                          );
                        },
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(48, 48),
                        ),
                        icon: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu_book_rounded,
                            color: AppTheme.primaryBlue,
                            size: 24,
                          ),
                        ),
                        tooltip: 'Rules',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), 
                
                const SizedBox(height: 10),
                
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppTheme.primaryBlue, Color(0xFF7BB0FF)],
                        ).createShader(bounds),
                        child: const Text(
                          'One word is different.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _RoleImage(
                            asset: 'assets/bodyguard2.jpg',
                            size: 100,
                            fallbackIcon: Icons.visibility_off_rounded,
                          ),
                          const SizedBox(width: 12),
                          _RoleImage(
                            asset: 'assets/goldcup.png',
                            size: 76,
                            fallbackIcon: Icons.emoji_events_rounded,
                          ),
                          const SizedBox(width: 12),
                          _RoleImage(
                            asset: 'assets/girl.jpg',
                            size: 100,
                            fallbackIcon: Icons.people_rounded,
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 17,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Describe it. ',
                              style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text: 'Vote. ',
                              style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w600),
                            ),
                            const TextSpan(
                              text: 'Unmask the Undercover.',
                              style: TextStyle(color: Color(0xFF2D2D2D), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const PlayerSetupScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: double.infinity,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryBlue,
                              AppTheme.primaryBlueDark,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.45),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _ButtonPatternPainter(),
                              ),
                            ),
                            const Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.play_arrow_rounded, size: 36, color: Colors.white),
                                  SizedBox(width: 12),
                                  Text(
                                    'START GAME',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleImage extends StatelessWidget {
  const _RoleImage({
    required this.asset,
    required this.size,
    required this.fallbackIcon,
  });

  final String asset;
  final double size;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: size,
          height: size,
          color: AppTheme.primaryBlue.withValues(alpha: 0.12),
          child: Icon(fallbackIcon, size: size * 0.4, color: AppTheme.primaryBlue),
        ),
      ),
    );
  }
}

class _ButtonPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    const spacing = 12.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
