/// Predefined word pairs for the game.
/// Citizens receive one word, Undercover receives the other.
class WordPair {
  const WordPair({required this.citizenWord, required this.undercoverWord});

  final String citizenWord;
  final String undercoverWord;
}

const List<WordPair> wordPairs = [
  WordPair(citizenWord: 'Cat', undercoverWord: 'Tiger'),
  WordPair(citizenWord: 'Coffee', undercoverWord: 'Tea'),
  WordPair(citizenWord: 'Ship', undercoverWord: 'Boat'),
  WordPair(citizenWord: 'Doctor', undercoverWord: 'Nurse'),
  WordPair(citizenWord: 'Apple', undercoverWord: 'Orange'),
  WordPair(citizenWord: 'Car', undercoverWord: 'Bus'),
  WordPair(citizenWord: 'Book', undercoverWord: 'Magazine'),
  WordPair(citizenWord: 'Dog', undercoverWord: 'Wolf'),
  WordPair(citizenWord: 'Pizza', undercoverWord: 'Burger'),
  WordPair(citizenWord: 'River', undercoverWord: 'Lake'),
  WordPair(citizenWord: 'Mountain', undercoverWord: 'Hill'),
  WordPair(citizenWord: 'Strawberry', undercoverWord: 'Cherry'),
  WordPair(citizenWord: 'Love', undercoverWord: 'Happiness'),
  WordPair(citizenWord: 'Sun', undercoverWord: 'Moon'),
  WordPair(citizenWord: 'Chair', undercoverWord: 'Sofa'),
];
