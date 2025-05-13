import 'package:flutter/material.dart';
import 'package:quiz_app/model/quiz_question.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class QuizProvider extends ChangeNotifier {
  List<QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isQuizCompleted = false;

  List<QuizQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get isQuizCompleted => _isQuizCompleted;
  QuizQuestion get currentQuestion => _questions[_currentQuestionIndex];

  Future<void> loadQuestions(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final questionsJson = prefs.getStringList('questions_$category') ?? [];

    _questions =
        questionsJson
            .map((json) => QuizQuestion.fromJson(jsonDecode(json)))
            .toList();

    _currentQuestionIndex = 0;
    _score = 0;
    _isQuizCompleted = false;
    notifyListeners();
  }

  Future<void> saveQuestion(QuizQuestion question) async {
    final prefs = await SharedPreferences.getInstance();

    final questionsJson =
        prefs.getStringList('questions_${question.category}') ?? [];

    questionsJson.add(jsonEncode(question.toJson()));

    await prefs.setStringList('questions_${question.category}', questionsJson);

    await loadQuestions(question.category);
  }

  void answerQuestion(String answerId) {
    if (_isQuizCompleted) return;

    final selectedAnswer = currentQuestion.answers.firstWhere(
      (answer) => answer.id == answerId,
    );
    if (selectedAnswer.isCorrect) {
      _score++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      _isQuizCompleted = true;
    }

    notifyListeners();
  }

  Future<void> deleteCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('questions_$category');

    if (_questions.isNotEmpty && _questions[0].category == category) {
      _questions = [];
      _currentQuestionIndex = 0;
      _score = 0;
      _isQuizCompleted = false;
    }

    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _isQuizCompleted = false;
    notifyListeners();
  }
}
