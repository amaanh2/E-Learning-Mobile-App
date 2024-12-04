import 'package:cloud_firestore/cloud_firestore.dart';

class Quiz {
  String? id; // Nullable until assigned from Firestore
  int score;
  String question;
  List<String> options;
  String correctAnswer;


  Quiz({
    this.id,
    required this.score,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  // Converts a Firestore document to a Quiz object
  factory Quiz.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Quiz(
      id: doc.id,
      score: data['score'] ?? 0,
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
    );
  }

  // Converts a Quiz object to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }

  // Creates a new Quiz document in Firestore
  static Future<void> create(Quiz quiz) async {
    try {
      await FirebaseFirestore.instance.collection('quizzes').add(quiz.toMap());
    } catch (e) {
      print("Error creating quiz: $e");
    }
  }

  //Fetches a Quiz document by its ID
  static Future<Quiz?> getById(String id) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('quizzes').doc(id).get();
      if (doc.exists) {
        return Quiz.fromDocument(doc);
      }
    } catch (e) {
      print("Error fetching quiz: $e");
    }
    return null;
  }


  // Updates an existing Quiz document in Firestore
  static Future<void> update(Quiz quiz) async {
    if (quiz.id == null) {
      print("Error: Cannot update a quiz without an ID");
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('quizzes').doc(quiz.id).update(quiz.toMap());
    } catch (e) {
      print("Error updating quiz: $e");
    }
  }

  // Deletes a Quiz document in Firestore by ID
  static Future<void> delete(String id) async {
    try {
      await FirebaseFirestore.instance.collection('quizzes').doc(id).delete();
    } catch (e) {
      print("Error deleting quiz: $e");
    }
  }

  // Fetches all quizzes as a list of Quiz objects
  static Future<List<Quiz>> getAll() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('quizzes').get();
      return snapshot.docs.map((doc) => Quiz.fromDocument(doc)).toList();
    } catch (e) {
      print("Error fetching quizzes: $e");
      return [];
    }
  }
}
