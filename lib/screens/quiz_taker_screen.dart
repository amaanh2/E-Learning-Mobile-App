import 'package:flutter/material.dart';
import '../models/quiz.dart';

class QuizTakerScreen extends StatefulWidget {
  final List<Quiz> quizzes;

  const QuizTakerScreen({Key? key, required this.quizzes}) : super(key: key);

  @override
  State<QuizTakerScreen> createState() => _QuizTakerScreenState();
}

class _QuizTakerScreenState extends State<QuizTakerScreen> {
  int currentQuizIndex = 0;
  int totalScore = 0;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    totalScore = 0;
    currentQuizIndex = 0;
  }

  void _submitAnswer() async {
    if (selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an option')),
      );
      return;
    }

    final currentQuiz = widget.quizzes[currentQuizIndex];

    if (selectedOption == currentQuiz.correctAnswer) {
      totalScore += 1;
      currentQuiz.score = 1;
    } else {
      currentQuiz.score = 0;
    }

    try {
      await Quiz.update(currentQuiz);
    } catch (e) {
      print('Failed to update quiz: $e');
    }

    if (currentQuizIndex < widget.quizzes.length - 1) {
      setState(() {
        selectedOption = null;
        currentQuizIndex++;
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quiz Completed'),
          content: Text('Your total score is $totalScore.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).maybePop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuiz = widget.quizzes[currentQuizIndex];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 150,
        flexibleSpace: Container(
          color: Colors.blue[700],
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Take Quiz',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Answer the following questions to the best of your ability.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuizIndex + 1} of ${widget.quizzes.length}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              currentQuiz.question,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...currentQuiz.options.map((option) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                  },
                ),
              );
            }).toList(),
            const Spacer(),
            ElevatedButton(
              onPressed: _submitAnswer,
              child: const Text('Submit Answer'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32), backgroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
