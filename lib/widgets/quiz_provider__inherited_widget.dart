import 'package:flutter/material.dart';
import 'package:quiz_app/view_model/quiz_provider.dart';

class QuizProviderWidget extends InheritedWidget {
  final QuizProvider quizProvider;

  const QuizProviderWidget({
    super.key,
    required this.quizProvider,
    required super.child,
  });

  static QuizProvider of(BuildContext context) {
    final QuizProviderWidget? result =
        context.dependOnInheritedWidgetOfExactType<QuizProviderWidget>();
    assert(result != null, 'No QuizProviderWidget found in context');
    return result!.quizProvider;
  }

  @override
  bool updateShouldNotify(QuizProviderWidget oldWidget) {
    return true;
  }
}
