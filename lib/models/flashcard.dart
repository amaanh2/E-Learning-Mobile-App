import 'package:cloud_firestore/cloud_firestore.dart';

class Flashcard {
  String? id;
  String question;
  String answer;
  String category;

  Flashcard({
    this.id,
    required this.question,
    required this.answer,
    this.category = 'general',
  });

  factory Flashcard.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Flashcard(
      id: doc.id,
      question: data['question'] ?? '',
      answer: data['answer'] ?? '',
      category: data['category'] ?? 'general',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'category': category,
    };
  }

  static Future<void> create(Flashcard flashcard) async {
    await FirebaseFirestore.instance.collection('flashcards').add(flashcard.toMap());
  }

  static Future<Flashcard?> getById(String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('flashcards').doc(id).get();
    return doc.exists ? Flashcard.fromDocument(doc) : null;
  }

  static Future<void> update(Flashcard flashcard) async {
    if (flashcard.id == null) return;
    await FirebaseFirestore.instance.collection('flashcards').doc(flashcard.id).update(flashcard.toMap());
  }

  static Future<void> delete(String id) async {
    await FirebaseFirestore.instance.collection('flashcards').doc(id).delete();
  }

  static Future<List<Flashcard>> getAll() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('flashcards').get();
    return snapshot.docs.map((doc) => Flashcard.fromDocument(doc)).toList();
  }
}
