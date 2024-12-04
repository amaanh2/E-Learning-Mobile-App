import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressTracker {
  String? id;
  String userId;
  Map<String, dynamic> progressData;

  ProgressTracker({
    this.id,
    required this.userId,
    required this.progressData,
  });

  factory ProgressTracker.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProgressTracker(
      id: doc.id,
      userId: data['userId'] ?? '',
      progressData: Map<String, dynamic>.from(data['progressData'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'progressData': progressData,
    };
  }

  static Future<void> create(ProgressTracker tracker) async {
    await FirebaseFirestore.instance.collection('progress_tracker').add(tracker.toMap());
  }

  static Future<ProgressTracker?> getByUserId(String userId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('progress_tracker')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return ProgressTracker.fromDocument(snapshot.docs.first);
    }
    return null;
  }

  static Future<void> update(ProgressTracker tracker) async {
    if (tracker.id == null) return;
    await FirebaseFirestore.instance.collection('progress_tracker').doc(tracker.id).update(tracker.toMap());
  }

  static Future<void> delete(String id) async {
    await FirebaseFirestore.instance.collection('progress_tracker').doc(id).delete();
  }
}
