class QuizAnswer {
  final String id;
  final String text;
  final bool isCorrect;

  QuizAnswer({required this.id, required this.text, required this.isCorrect});

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      id: json['id'],
      text: json['text'],
      isCorrect: json['isCorrect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'text': text, 'isCorrect': isCorrect};
  }
}
