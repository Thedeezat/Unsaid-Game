enum Role { citizen, undercover }

class Player {
  Player({
    required this.id,
    required this.name,
    required this.role,
    required this.word,
    this.isEliminated = false,
  });

  final String id;
  final String name;
  final Role role;
  final String word;
  final bool isEliminated;

  Player copyWith({
    String? id,
    String? name,
    Role? role,
    String? word,
    bool? isEliminated,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      word: word ?? this.word,
      isEliminated: isEliminated ?? this.isEliminated,
    );
  }

  String get displayRole => role == Role.undercover ? 'Undercover' : 'Citizen';
}
