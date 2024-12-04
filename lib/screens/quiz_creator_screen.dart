import 'package:flutter/material.dart';
import '../models/quiz.dart';

class QuizCreatorScreen extends StatefulWidget {
  final Quiz? quiz;

  const QuizCreatorScreen({Key? key, this.quiz}) : super(key: key);

  @override
  State<QuizCreatorScreen> createState() => _QuizCreatorScreenState();
}

class _QuizCreatorScreenState extends State<QuizCreatorScreen> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController scoreController = TextEditingController();
  final List<TextEditingController> optionControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  String? selectedAnswer;
  final List<String> dropdownValues = [
    'Answer 1',
    'Answer 2',
    'Answer 3',
    'Answer 4'
  ];

  @override
  void initState() {
    super.initState();

    if (widget.quiz != null) {
      questionController.text = widget.quiz!.question;
      scoreController.text = widget.quiz!.score.toString();
      for (int i = 0; i < widget.quiz!.options.length; i++) {
        optionControllers[i].text = widget.quiz!.options[i];
      }
      selectedAnswer = dropdownValues[
          widget.quiz!.options.indexOf(widget.quiz!.correctAnswer)];
    }
  }

  void _saveQuiz() {
    if (questionController.text.isEmpty ||
        selectedAnswer == null ||
        scoreController.text.isEmpty ||
        optionControllers.any((controller) => controller.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final score = int.tryParse(scoreController.text);
    if (score == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Score must be a valid number')),
      );
      return;
    }

    final quiz = Quiz(
      id: widget.quiz?.id,
      question: questionController.text,
      options: optionControllers.map((controller) => controller.text).toList(),
      correctAnswer:
          optionControllers[dropdownValues.indexOf(selectedAnswer!)].text,
      score: score,
    );

    if (widget.quiz == null) {
      Quiz.create(quiz);
    } else {
      Quiz.update(quiz);
    }

    Navigator.pop(context, true); // Successful save
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                widget.quiz == null ? 'Create Quiz' : 'Edit Quiz',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.quiz == null
                    ? 'Fill in the fields below to create a new quiz.'
                    : 'Edit the fields below to update the quiz.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveQuiz,
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCardSection(
                title: 'Question',
                child: TextField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    hintText: 'Enter the quiz question',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildCardSection(
                title: 'Options',
                child: Column(
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        controller: optionControllers[index],
                        decoration: InputDecoration(
                          hintText: 'Option ${index + 1}',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),
              _buildCardSection(
                title: 'Correct Answer',
                child: DropdownButtonFormField<String>(
                  value: selectedAnswer,
                  items: dropdownValues.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAnswer = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildCardSection(
                title: 'Score',
                child: TextField(
                  controller: scoreController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter the score for this quiz',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection({required String title, required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
