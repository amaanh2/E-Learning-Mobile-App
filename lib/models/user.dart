import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? id;
  String username;
  String email;
  String profileImageUrl;

  User({
    this.id,
    required this.username,
    required this.email,
    this.profileImageUrl = '',
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
    };
  }

  static Future<void> create(User user) async {
    await FirebaseFirestore.instance.collection('users').add(user.toMap());
  }

  static Future<User?> getById(String id) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(id).get();
    return doc.exists ? User.fromDocument(doc) : null;
  }

  static Future<void> update(User user) async {
    if (user.id == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user.id).update(user.toMap());
  }

  static Future<void> delete(String id) async {
    await FirebaseFirestore.instance.collection('users').doc(id).delete();
  }

  static Future<User?> getByEmail(String email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return User.fromDocument(snapshot.docs.first);
    }
    return null;
  }
}
