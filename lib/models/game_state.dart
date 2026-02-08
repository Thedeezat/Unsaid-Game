import 'dart:math';
import '../core/word_pairs.dart';
import 'player.dart';

enum GamePhase {
  setup,
  roleDistribution,
  describing,
  voting,
  ended,
}

class GameState {
  GameState({
    this.players = const [],
    this.phase = GamePhase.setup,
    this.currentPlayerIndex = 0,
    this.currentRound = 1,
    this.votes = const {},
    this.winnerRole,
  });

  final List<Player> players;
  final GamePhase phase;
  final int currentPlayerIndex;
  final int currentRound;
  final Map<String, String> votes; // voterId -> votedPlayerId
  final Role? winnerRole;

  List<Player> get activePlayers =>
      players.where((p) => !p.isEliminated).toList();

  Player? get currentPlayer {
    final active = activePlayers;
    if (active.isEmpty) return null;
    final idx = currentPlayerIndex % active.length;
    return active[idx];
  }

  int get undercoverCount => activePlayers.where((p) => p.role == Role.undercover).length;
  int get citizenCount => activePlayers.where((p) => p.role == Role.citizen).length;

  /// Check win: Citizens win if Undercover eliminated; Undercover wins if only 2 remain (1 undercover + 1 citizen).
  Role? checkWinCondition() {
    final undercover = undercoverCount;
    final citizens = citizenCount;
    if (undercover == 0) return Role.citizen;
    if (citizens <= 1 && undercover >= 1) return Role.undercover;
    return null;
  }

  GameState copyWith({
    List<Player>? players,
    GamePhase? phase,
    int? currentPlayerIndex,
    int? currentRound,
    Map<String, String>? votes,
    Role? winnerRole,
  }) {
    return GameState(
      players: players ?? this.players,
      phase: phase ?? this.phase,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      currentRound: currentRound ?? this.currentRound,
      votes: votes ?? this.votes,
      winnerRole: winnerRole ?? this.winnerRole,
    );
  }

  /// Create a new game from player names: assign 1 Undercover, rest Citizens, random word pair.
  static GameState startGame(List<String> playerNames) {
    if (playerNames.length < 3 || playerNames.length > 12) {
      throw ArgumentError('Players must be between 3 and 12');
    }
    final rnd = Random();
    final pair = wordPairs[rnd.nextInt(wordPairs.length)];
    final undercoverIndex = rnd.nextInt(playerNames.length);
    final players = <Player>[];
    for (var i = 0; i < playerNames.length; i++) {
      final isUndercover = i == undercoverIndex;
      players.add(Player(
        id: 'p_$i',
        name: playerNames[i],
        role: isUndercover ? Role.undercover : Role.citizen,
        word: isUndercover ? pair.undercoverWord : pair.citizenWord,
      ));
    }
    return GameState(
      players: players,
      phase: GamePhase.roleDistribution,
      currentPlayerIndex: 0,
      currentRound: 1,
    );
  }
}
