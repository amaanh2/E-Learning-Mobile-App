import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz.dart';
import 'quiz_creator_screen.dart';
import 'quiz_taker_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final CollectionReference quizzesCollection =
      FirebaseFirestore.instance.collection('quizzes');

  Future<void> _navigateToQuizCreator({Quiz? quiz}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizCreatorScreen(quiz: quiz),
      ),
    );

    if (result == true) {
      setState(() {});
    }
  }

  Future<void> _navigateToQuizTaker({List<Quiz>? quizzes, Quiz? quiz}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizTakerScreen(
          quizzes: quizzes ?? [quiz!],
        ),
      ),
    );
  }

  Future<void> _deleteQuiz(String id) async {
    await Quiz.delete(id);
    setState(() {});
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
              const Text(
                'Quiz Manager',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'View, create, and manage your quizzes below.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () async {
              final snapshot = await quizzesCollection.get();
              final quizzes = snapshot.docs.map((doc) => Quiz.fromDocument(doc)).toList();
              if (quizzes.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No quizzes to play.')),
                );
                return;
              }
              _navigateToQuizTaker(quizzes: quizzes);
            },
            color: Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToQuizCreator(),
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: quizzesCollection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading quizzes'));
            }

            final quizzes = snapshot.data?.docs.map((doc) {
              return Quiz.fromDocument(doc);
            }).toList();

            if (quizzes == null || quizzes.isEmpty) {
              return const Center(child: Text('No quizzes found.'));
            }

            return ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                final quiz = quizzes[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      quiz.question,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Options: ${quiz.options.join(', ')}\nScore: ${quiz.score}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.play_arrow, color: Colors.green),
                          onPressed: () => _navigateToQuizTaker(quiz: quiz),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteQuiz(quiz.id!),
                        ),
                      ],
                    ),
                    onTap: () => _navigateToQuizCreator(quiz: quiz),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
