import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_theme.dart';
import '../models/game_state.dart';
import 'role_distribution_flow_screen.dart';

const Color _setupBg = Color(0xFFB2E9FF);
const double _setupBgOpacity = 0.8;

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  static const int minPlayers = 3;
  static const int maxPlayers = 12;

  int _playerCount = 4;
  final List<TextEditingController> _nameControllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  void _syncControllers() {
    while (_nameControllers.length < _playerCount) {
      _nameControllers.add(TextEditingController(
        text: 'Player ${_nameControllers.length + 1}',
      ));
      _focusNodes.add(FocusNode());
    }
    while (_nameControllers.length > _playerCount) {
      _nameControllers.removeLast().dispose();
      _focusNodes.removeLast().dispose();
    }
  }

  @override
  void dispose() {
    for (final c in _nameControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startGame() {
    final names = _nameControllers
        .map((c) => c.text.trim().isEmpty ? 'Player ${_nameControllers.indexOf(c) + 1}' : c.text.trim())
        .toList();
    if (names.length < minPlayers) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Need at least $minPlayers players'),
          backgroundColor: Colors.red.shade400,
        ),
      );
      return;
    }
    final game = GameState.startGame(names);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => RoleDistributionFlowScreen(gameState: game),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                  _setupBg.withValues(alpha: _setupBgOpacity),
                  const Color(0xFFC5EFFF).withValues(alpha: _setupBgOpacity),
                  const Color(0xFFD8F4FF).withValues(alpha: _setupBgOpacity),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _SetupGridPatternPainter(),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _SetupScatteredPatternPainter(),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: _SetupShapePatternPainter(),
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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
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
                          child: const Icon(Icons.arrow_back_rounded, color: Color(0xFF555555), size: 22),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Spacer(),
                      Text(
                        'Player Setup',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.headerColor,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.7),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 18, color: AppTheme.primaryBlueDark.withValues(alpha: 0.9)),
                        const SizedBox(width: 8),
                        Text(
                          'Add $minPlayers–$maxPlayers players to start',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBlueDark.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Number of players card – column layout to avoid overflow
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.9),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      Icons.groups_rounded,
                                      color: AppTheme.primaryBlue,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Number of players',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.headerColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _CountButton(
                                    icon: Icons.remove_rounded,
                                    onPressed: _playerCount > minPlayers
                                        ? () {
                                            setState(() {
                                              _playerCount--;
                                              _syncControllers();
                                            });
                                          }
                                        : null,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: Text(
                                      '$_playerCount',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.primaryBlueDark,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ),
                                  _CountButton(
                                    icon: Icons.add_rounded,
                                    onPressed: _playerCount < maxPlayers
                                        ? () {
                                            setState(() {
                                              _playerCount++;
                                              _syncControllers();
                                            });
                                          }
                                        : null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Container(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.badge_rounded,
                                  color: AppTheme.primaryBlue,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Player names',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.headerColor,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '• Tap to edit',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(_playerCount, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _nameControllers[i],
                                focusNode: _focusNodes[i],
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(left: 14, right: 12),
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                                      child: Icon(
                                        Icons.person_rounded,
                                        color: AppTheme.primaryBlue.withValues(alpha: 0.85),
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: Icon(
                                      Icons.edit_rounded,
                                      size: 20,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  hintText: 'Player ${i + 1}',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: AppTheme.primaryBlue.withValues(alpha: 0.25),
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: AppTheme.primaryBlue.withValues(alpha: 0.6),
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                ),
                                textCapitalization: TextCapitalization.words,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 28),
                        // Start Game button (with subtle dot pattern overlay)
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primaryBlue,
                                AppTheme.primaryBlueDark,
                              ],
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
                                    painter: _ButtonDotsPainter(),
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _startGame,
                                    borderRadius: BorderRadius.circular(18),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                                          SizedBox(width: 10),
                                          Text(
                                            'START ROUND 🚀',
                                            style: TextStyle(
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
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupGridPatternPainter extends CustomPainter {
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

class _SetupScatteredPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rnd = _SeededRandom(12345);
    final paint = Paint()
      ..style = PaintingStyle.fill;
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

class _SetupShapePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

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

class _ButtonDotsPainter extends CustomPainter {
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

class _CountButton extends StatelessWidget {
  const _CountButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onPressed != null
          ? AppTheme.primaryBlue.withValues(alpha: 0.2)
          : AppTheme.primaryBlue.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: onPressed != null ? AppTheme.primaryBlue : Colors.grey.shade400, size: 24),
        ),
      ),
    );
  }
}
