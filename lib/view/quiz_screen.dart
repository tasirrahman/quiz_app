import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/utils/app_colors.dart';
import 'package:quiz_app/view/create_quiz_screen.dart';
import 'package:quiz_app/view_model/quiz_provider.dart';

class QuizScreen extends StatefulWidget {
  final String category;

  const QuizScreen({super.key, required this.category});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late final String category;
  late final QuizProvider quizProvider;
  late AnimationController _animationController;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    category = widget.category;
    quizProvider = QuizProvider();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await quizProvider.loadQuestions(category);

      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Error loading questions: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load questions. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuizProvider>.value(
      value: quizProvider,
      child: Scaffold(
        appBar: AppBar(
          title: Text(category),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => CreateQuizScreen(category: category),
                  ),
                ).then((_) => _loadQuestions());
              },
            ),
            IconButton(
              onPressed: () => _showDeleteConfirmationDialog(),
              icon: const Icon(Icons.delete_outline_rounded),
              tooltip: 'Delete category',
            ),
          ],
        ),
        body: SafeArea(child: _buildBody()),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog() async {
    final theme = Theme.of(context);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: Text(
            'Are you sure you want to delete all questions in "$category"?',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
              onPressed: () async {
                try {
                  await quizProvider.deleteCategory(category);

                  if (!mounted) return;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.all(16),
                      content: Text(
                        'All questions in "$category" have been deleted',
                      ),
                    ),
                  );
                } catch (e) {
                  debugPrint('Error deleting category: $e');

                  if (!mounted) return;
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.all(16),
                      content: const Text(
                        'Failed to delete category. Please try again.',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return _buildErrorState();
    }

    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        if (provider.questions.isEmpty) {
          return _buildEmptyState();
        }

        if (provider.isQuizCompleted) {
          return _buildQuizResultScreen();
        }

        return _buildQuizContent();
      },
    );
  }

  Widget _buildErrorState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? 'An error occurred',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _loadQuestions,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: 60,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No questions available for this category.',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder:
                          (context) => CreateQuizScreen(category: category),
                    ),
                  ).then((_) => _loadQuestions());
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
                child: const Text('Add Questions'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizContent() {
    final currentQuestion = quizProvider.currentQuestion;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProgressIndicator(),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildQuestionCard(currentQuestion.question),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
                    child: Text(
                      'Select your answer',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  ..._buildAnswerButtons(currentQuestion.answers),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progress =
        (quizProvider.currentQuestionIndex + 1) / quizProvider.questions.length;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${quizProvider.currentQuestionIndex + 1} of ${quizProvider.questions.length}',
              style: theme.textTheme.titleSmall,
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(String question) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question:',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            question,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnswerButtons(List<dynamic> answers) {
    try {
      return answers.map((answer) {
        final String id = answer.id?.toString() ?? '';
        final String text = answer.text?.toString() ?? 'No answer text';
        final theme = Theme.of(context);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () {
              try {
                _animationController.forward(from: 0).then((_) {
                  quizProvider.answerQuestion(id);
                });
              } catch (e) {
                debugPrint('Error answering question: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.all(16),
                    content: const Text(
                      'Failed to process answer. Please try again.',
                    ),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error building answer buttons: $e');
      return [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Error loading answer options',
            textAlign: TextAlign.center,
          ),
        ),
      ];
    }
  }

  Widget _buildQuizResultScreen() {
    final score = quizProvider.score;
    final total = quizProvider.questions.length;
    final percentage = (score / total) * 100;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildResultIcon(percentage),
          const SizedBox(height: 32),
          Text(
            'Quiz Completed!',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildScoreCard(score, total, percentage),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                try {
                  quizProvider.resetQuiz();
                } catch (e) {
                  debugPrint('Error resetting quiz: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.all(16),
                      content: const Text(
                        'Failed to reset quiz. Please try again.',
                      ),
                      backgroundColor: AppColors.appColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: const Text('Try Again'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Return to Categories'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultIcon(double percentage) {
    IconData iconData;
    Color iconColor;
    final theme = Theme.of(context);

    if (percentage >= 90) {
      iconData = Icons.emoji_events;
      iconColor = Colors.amber;
    } else if (percentage >= 70) {
      iconData = Icons.star;
      iconColor = Colors.amber.shade700;
    } else if (percentage >= 50) {
      iconData = Icons.thumb_up;
      iconColor = theme.colorScheme.primary;
    } else {
      iconData = Icons.sentiment_neutral;
      iconColor = theme.colorScheme.secondary;
    }

    return Icon(iconData, size: 80, color: iconColor);
  }

  Widget _buildScoreCard(int score, int total, double percentage) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildScoreItem('Score', '$score/$total'),
              Container(width: 1, height: 36, color: theme.dividerColor),
              _buildScoreItem('Percentage', '${percentage.toInt()}%'),
            ],
          ),
          Divider(height: 40, color: theme.dividerColor),
          Text(
            _getResultMessage(percentage),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String label, String value) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getResultMessage(double percentage) {
    if (percentage >= 90) return 'Excellent! You\'re a master!';
    if (percentage >= 70) return 'Great job! Well done!';
    if (percentage >= 50) return 'Good effort! Keep learning!';
    return 'Keep practicing to improve!';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
