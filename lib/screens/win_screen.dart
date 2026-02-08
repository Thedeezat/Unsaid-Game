import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../widgets/game_screen_background.dart';
import 'home_screen.dart';

class WinScreen extends StatefulWidget {
  const WinScreen({
    super.key,
    required this.winnerRole,
    required this.gameState,
  });

  final Role winnerRole;
  final GameState gameState;

  @override
  State<WinScreen> createState() => _WinScreenState();
}

class _WinScreenState extends State<WinScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCitizenWin = widget.winnerRole == Role.citizen;
    final title = isCitizenWin ? 'The Citizens win!' : 'The Undercover wins!';
    final subtitle = isCitizenWin
        ? 'You eliminated the Undercover.'
        : 'The Undercover stayed hidden.';

    const Color subtitleColor = Color(0xFF2D4A7C);

    return Scaffold(
      body: Stack(
        children: [
          GameScreenBackground(
            backgroundOpacity: 0.85,
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.headerColor.withValues(alpha: 0.2),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      isCitizenWin
                          ? Icons.emoji_events_rounded
                          : Icons.visibility_off_rounded,
                      size: 72,
                      color: AppTheme.headerColor,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.headerColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: subtitleColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.9),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.auto_stories_rounded,
                                  color: AppTheme.primaryBlue,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Words revealed',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.headerColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...widget.gameState.players.take(5).map((p) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: p.role == Role.undercover
                                        ? AppTheme.undercoverColor
                                        : AppTheme.primaryBlue,
                                    child: Icon(
                                      p.role == Role.undercover
                                          ? Icons.visibility_off_rounded
                                          : Icons.person_rounded,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      '${p.name}: ${p.word}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: AppTheme.primaryBlueDark
                                            .withValues(alpha: 0.9),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          if (widget.gameState.players.length > 5)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '+ ${widget.gameState.players.length - 5} more',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute<void>(
                                  builder: (_) => const HomeScreen(),
                                ),
                                (_) => false,
                              );
                            },
                            icon: const Icon(Icons.home_rounded, size: 22),
                            label: const Text('Home'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.headerColor,
                              side: BorderSide(
                                color: AppTheme.headerColor.withValues(alpha: 0.6),
                                width: 2,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const HomeScreen(),
                                  ),
                                  (_) => false,
                                );
                              },
                              icon: const Icon(Icons.replay_rounded, size: 24),
                              label: const Text('Play again'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.primaryBlue,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.03,
              numberOfParticles: 18,
              maxBlastForce: 25,
              minBlastForce: 8,
              gravity: 0.15,
              colors: const [
                AppTheme.primaryBlue,
                AppTheme.primaryBlueLight,
                Color(0xFFB2E9FF),
                Colors.white,
                AppTheme.successGreen,
                AppTheme.accentOrange,
              ],
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }
}
