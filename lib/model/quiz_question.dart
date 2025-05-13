import 'package:quiz_app/model/quiz_answer.dart';

class QuizQuestion {
  final String id;
  final String question;
  final List<QuizAnswer> answers;
  final String category;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.answers,
    required this.category,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      question: json['question'],
      answers:
          (json['answers'] as List)
              .map((answer) => QuizAnswer.fromJson(answer))
              .toList(),
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answers': answers.map((answer) => answer.toJson()).toList(),
      'category': category,
    };
  }
}
