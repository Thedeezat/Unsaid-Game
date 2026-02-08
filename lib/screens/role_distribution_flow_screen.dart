import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../widgets/game_screen_background.dart';
import 'game_rounds_screen.dart';

class RoleDistributionFlowScreen extends StatefulWidget {
  const RoleDistributionFlowScreen({super.key, required this.gameState});

  final GameState gameState;

  @override
  State<RoleDistributionFlowScreen> createState() =>
      _RoleDistributionFlowScreenState();
}

class _RoleDistributionFlowScreenState extends State<RoleDistributionFlowScreen> {
  int _currentIndex = 0;

  List<Player> get _players => widget.gameState.players;

  void _onNext() {
    if (_currentIndex >= _players.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => GameRoundsScreen(
            gameState: widget.gameState.copyWith(
              phase: GamePhase.describing,
            ),
          ),
        ),
      );
      return;
    }
    setState(() => _currentIndex++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image – makes this screen distinct (use assets/words.jpg or background3.jpg)
          Positioned.fill(
            child: Image.asset(
              'assets/words.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFE8F4FF),
              ),
            ),
          ),
          // Scrim so content stays readable
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFB2E9FF).withValues(alpha: 0.75),
                    const Color(0xFFC5EFFF).withValues(alpha: 0.82),
                    const Color(0xFFD8F4FF).withValues(alpha: 0.88),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          GameScreenBackground(
            backgroundOpacity: 0.55,
            child: SafeArea(
              child: Column(
                children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    gameScreenIconButton(
                      icon: Icons.arrow_back_rounded,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    Text(
                      'Get your word',
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
              const SizedBox(height: 40),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.phone_android_rounded,
                          size: 106,
                          color: AppTheme.primaryBlue.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Pass the phone to',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _players[_currentIndex].name,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryBlueDark.withValues(alpha: 0.98),
                        ),
                      ),
                      const SizedBox(height: 28),
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
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.help_outline_rounded,
                              size: 48,
                              color: AppTheme.primaryBlue.withValues(alpha: 0.8),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Tap the button below to see your role and secret word. Don\'t let others see!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.4,
                                color: AppTheme.primaryBlueDark.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: gameScreenPrimaryButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => _PrivateWordRevealScreen(
                                  player: _players[_currentIndex],
                                  onDone: () {
                                    Navigator.of(context).pop();
                                    _onNext();
                                  },
                                ),
                              ),
                            );
                          },
                          icon: Icons.visibility_rounded,
                          label: 'PICK MY CARD',
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _players.length,
                          (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: i == _currentIndex ? 10 : 8,
                            height: i == _currentIndex ? 10 : 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i == _currentIndex
                                  ? AppTheme.primaryBlue
                                  : Colors.grey.shade400,
                              border: i == _currentIndex
                                  ? Border.all(
                                      color: const Color(0xFFB2E9FF),
                                      width: 1,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivateWordRevealScreen extends StatelessWidget {
  const _PrivateWordRevealScreen({
    required this.player,
    required this.onDone,
  });

  final Player player;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final isUndercover = player.role == Role.undercover;
    final roleColor = isUndercover ? AppTheme.undercoverColor : AppTheme.primaryBlue;
    final textColor = isUndercover ? const Color(0xFF1A1A1A) : AppTheme.citizenColor;
    final labelColor = isUndercover ? Colors.grey.shade700 : AppTheme.primaryBlue.withValues(alpha: 0.9);

    return Scaffold(
      body: GameScreenBackground(
        backgroundOpacity: 0.9,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8),
                    child: gameScreenIconButton(
                      icon: Icons.close_rounded,
                      onPressed: onDone,
                      iconColor: const Color(0xFF555555),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              CircleAvatar(
                radius: 48,
                backgroundColor: roleColor.withValues(alpha: 0.2),
                child: Text(
                  player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 55,
                    fontWeight: FontWeight.w800,
                    color: roleColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                player.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: isUndercover ? const Color(0xFF1A1A1A) : AppTheme.primaryBlueDark.withValues(alpha: 0.98),
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
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
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isUndercover
                                ? Icons.visibility_off_rounded
                                : Icons.people_rounded,
                            color: roleColor,
                            size: 30,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            player.displayRole,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: roleColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Your secret word is',
                        style: TextStyle(
                          fontSize: 16,
                          color: labelColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: roleColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: roleColor.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          player.word.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_rounded,
                      size: 18,
                      color: isUndercover ? Colors.grey.shade700 : AppTheme.primaryBlueDark.withValues(alpha: 0.85),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Only you should see this — don\'t show to anyone',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isUndercover ? Colors.grey.shade700 : AppTheme.primaryBlueDark.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: textColor,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text('GOT IT!'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
