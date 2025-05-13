import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/model/quiz_answer.dart';
import 'package:quiz_app/model/quiz_question.dart';
import 'package:quiz_app/utils/app_colors.dart';
import 'package:quiz_app/view_model/quiz_provider.dart';

class CreateQuizScreen extends StatefulWidget {
  final String category;
  CreateQuizScreen({super.key, required this.category});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final List<TextEditingController> _answerControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  int _correctAnswerIndex = 0;

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<QuizProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        actions: [
          IconButton(
            onPressed: () => _showDeleteCategoryDialog(context),
            icon: Icon(Icons.delete_outline_rounded),
            tooltip: 'Delete category',
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            children: [
              _buildQuestionSection(theme),
              SizedBox(height: 32),
              _buildAnswersSection(theme),
              SizedBox(height: 40),
              _buildSaveButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text('Question', style: theme.textTheme.titleLarge),
        ),
        TextFormField(
          controller: _questionController,
          decoration: InputDecoration(
            hintText: 'Enter your question here',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 1),
            ),
            contentPadding: EdgeInsets.all(20),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a question';
            }
            return null;
          },
          maxLines: 3,
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildAnswersSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text('Answers', style: theme.textTheme.titleLarge),
        ),
        Text(
          'Select the correct answer',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 16),
        ..._buildAnswerFields(theme),
      ],
    );
  }

  List<Widget> _buildAnswerFields(ThemeData theme) {
    return List.generate(4, (index) {
      return Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: _correctAnswerIndex == index ? 2 : 1,
            color:
                _correctAnswerIndex == index
                    ? theme.colorScheme.primary
                    : theme.dividerColor,
          ),
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              _correctAnswerIndex = index;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Row(
              children: [
                Radio<int>(
                  value: index,
                  groupValue: _correctAnswerIndex,
                  onChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        _correctAnswerIndex = value;
                      });
                    }
                  },
                ),
                Expanded(
                  child: TextFormField(
                    controller: _answerControllers[index],
                    decoration: InputDecoration(
                      hintText: 'Answer option ${index + 1}',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an answer';
                      }
                      return null;
                    },
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSaveButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _saveQuestion,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
        ),
        child: Text('Save Question'),
      ),
    );
  }

  void _showDeleteCategoryDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Category'),
            content: Text(
              'Are you sure you want to delete all questions in "${widget.category}"?',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => _deleteCategory(context),
                child: Text('Delete'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
              ),
            ],
          ),
    );
  }

  void _deleteCategory(BuildContext context) async {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    await quizProvider.deleteCategory(widget.category);

    if (!mounted) return;

    Navigator.pop(context);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          'All questions in "${widget.category}" have been deleted',
        ),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  void _saveQuestion() async {
    if (_formKey.currentState!.validate()) {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);

      final answers = List.generate(4, (index) {
        return QuizAnswer(
          id: 'answer_${DateTime.now().millisecondsSinceEpoch}_$index',
          text: _answerControllers[index].text,
          isCorrect: index == _correctAnswerIndex,
        );
      });

      final newQuestion = QuizQuestion(
        id: 'question_${DateTime.now().millisecondsSinceEpoch}',
        question: _questionController.text,
        answers: answers,
        category: widget.category,
      );

      await quizProvider.saveQuestion(newQuestion);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.appColor,

          content: Text(
            'Question saved successfully!',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

      Navigator.pop(context);
    }
  }
}
