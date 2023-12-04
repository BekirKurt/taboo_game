class TabuWords {
  final String mainWord;
  final List<String> tabooWords;

  TabuWords({required this.mainWord, required this.tabooWords});

  factory TabuWords.fromJson(Map<String, dynamic> json) {
    return TabuWords(
      mainWord: json['word'],
      tabooWords: List<String>.from(json['tabuWords']),
    );
  }
}
