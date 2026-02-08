import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../widgets/game_screen_background.dart';
import 'game_rounds_screen.dart';
import 'win_screen.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key, required this.gameState});

  final GameState gameState;

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  late GameState _game;
  String? _selectedPlayerId;

  @override
  void initState() {
    super.initState();
    _game = widget.gameState;
  }

  List<Player> get _activePlayers => _game.activePlayers;

  void _submitVote({bool isTie = false}) {
    if (!isTie && _selectedPlayerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a player to vote out')),
      );
      return;
    }
    List<Player> newPlayers = _game.players;
    if (!isTie && _selectedPlayerId != null) {
      newPlayers = _game.players.map((p) {
        if (p.id == _selectedPlayerId) return p.copyWith(isEliminated: true);
        return p;
      }).toList();
    }
    var newGame = _game.copyWith(
      players: newPlayers,
      phase: GamePhase.describing,
      currentRound: _game.currentRound + 1,
      votes: {},
    );
    final win = newGame.checkWinCondition();
    if (win != null) {
      newGame = newGame.copyWith(
        phase: GamePhase.ended,
        winnerRole: win,
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (_) => WinScreen(winnerRole: win, gameState: newGame),
        ),
        (_) => false,
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => GameRoundsScreen(
          gameState: newGame.copyWith(
            currentPlayerIndex: 0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      icon: Icons.arrow_back_rounded,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Spacer(),
                    Text(
                      'Vote',
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
                          Icons.how_to_vote_rounded,
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
                                'Who is the Undercover?',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.headerColor,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap a player to vote out, or tap "No elimination" below for a tie.',
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
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _activePlayers.length,
                  itemBuilder: (context, i) {
                    final p = _activePlayers[i];
                    final selected = _selectedPlayerId == p.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => setState(() => _selectedPlayerId = p.id),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppTheme.primaryBlue.withValues(alpha: 0.15)
                                  : Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected
                                    ? AppTheme.primaryBlue.withValues(alpha: 0.6)
                                    : Colors.white.withValues(alpha: 0.85),
                                width: selected ? 2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: selected
                                      ? AppTheme.primaryBlue
                                      : AppTheme.primaryBlue.withValues(alpha: 0.2),
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: selected
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
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: AppTheme.primaryBlueDark
                                          .withValues(alpha: selected ? 0.95 : 0.8),
                                    ),
                                  ),
                                ),
                                if (selected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppTheme.primaryBlue,
                                    size: 26,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: gameScreenPrimaryButton(
                        onPressed: () => _submitVote(),
                        icon: Icons.how_to_vote_rounded,
                        label: 'SUBMIT VOTE',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _submitVote(isTie: true),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.handshake_rounded,
                                size: 20,
                                color: AppTheme.primaryBlueDark.withValues(alpha: 0.9),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'NO ELIMINATION (TIE)',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.headerColor,
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
            ],
          ),
        ),
      ),
    );
  }
}
