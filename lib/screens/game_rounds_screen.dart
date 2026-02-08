import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../widgets/game_screen_background.dart';
import 'voting_screen.dart';
import 'win_screen.dart';

class GameRoundsScreen extends StatefulWidget {
  const GameRoundsScreen({super.key, required this.gameState});

  final GameState gameState;

  @override
  State<GameRoundsScreen> createState() => _GameRoundsScreenState();
}

class _GameRoundsScreenState extends State<GameRoundsScreen> {
  late GameState _game;
  int _describeIndex = 0;

  @override
  void initState() {
    super.initState();
    _game = widget.gameState;
  }

  List<Player> get _activePlayers => _game.activePlayers;

  void _goToVoting() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => VotingScreen(gameState: _game),
      ),
    );
  }

  void _onWin(Role winner) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) => WinScreen(winnerRole: winner, gameState: _game),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final win = _game.checkWinCondition();
    if (win != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _onWin(win));
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: GameScreenBackground(
        backgroundOpacity: 0.8,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    gameScreenIconButton(
                      icon: Icons.info_outline_rounded,
                      onPressed: () => _showRoundInfo(context),
                    ),
                    const Spacer(),
                    Text(
                      'Round ${_game.currentRound}',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.headerColor,
                      ),
                    ),
                    const Spacer(),
                    gameScreenIconButton(
                      icon: Icons.how_to_vote_rounded,
                      onPressed: _goToVoting,
                    ),
                  ],
                ),
              ),
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
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: AppTheme.primaryBlue,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Discussion time',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.headerColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Describe your word without saying it. Then vote.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Now describing',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _activePlayers[_describeIndex].name,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryBlueDark.withValues(alpha: 0.98),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.visibility_off_rounded,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Don\'t show this screen to anyone',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    ..._activePlayers.asMap().entries.map((e) {
                      final i = e.key;
                      final p = e.value;
                      final isCurrent = i == _describeIndex;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? AppTheme.primaryBlue.withValues(alpha: 0.12)
                                : Colors.white.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isCurrent
                                  ? AppTheme.primaryBlue.withValues(alpha: 0.5)
                                  : Colors.white.withValues(alpha: 0.85),
                              width: isCurrent ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: isCurrent
                                    ? AppTheme.primaryBlue
                                    : AppTheme.primaryBlue.withValues(alpha: 0.2),
                                child: Icon(
                                  Icons.person_rounded,
                                  color: isCurrent
                                      ? Colors.white
                                      : AppTheme.primaryBlue.withValues(alpha: 0.85),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  p.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isCurrent
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: AppTheme.primaryBlueDark.withValues(
                                        alpha: isCurrent ? 0.95 : 0.8),
                                  ),
                                ),
                              ),
                              if (isCurrent)
                                Icon(
                                  Icons.mic_rounded,
                                  color: AppTheme.primaryBlue,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: gameScreenPrimaryButton(
                    onPressed: () {
                      if (_describeIndex >= _activePlayers.length - 1) {
                        _goToVoting();
                      } else {
                        setState(() => _describeIndex++);
                      }
                    },
                    icon: _describeIndex >= _activePlayers.length - 1
                        ? Icons.how_to_vote_rounded
                        : Icons.arrow_forward_rounded,
                    label: _describeIndex >= _activePlayers.length - 1
                        ? 'Go to vote'
                        : 'NEXT SPEAKER',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRoundInfo(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lightbulb_outline_rounded, color: AppTheme.accentOrange),
            SizedBox(width: 8),
            Text('Round rules'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Text(
            'Each player describes their secret word without saying it. '
            'After everyone has spoken, vote for who you think is the Undercover. '
            'The player with the most votes is eliminated. On a tie, no one is eliminated.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('GOT IT'),
          ),
        ],
      ),
    );
  }
}
