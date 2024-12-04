import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  // Convert Firestore document to Notification
  factory Notification.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Notification(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }

  // Convert Notification to a Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
    };
  }

  // Create a new notification in Firestore
  static Future<void> createNotification(Notification notification) async {
    await FirebaseFirestore.instance.collection('notifications').add(notification.toFirestore());
  }

  // Update an existing notification in Firestore
  static Future<void> updateNotification(String id, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('notifications').doc(id).update(data);
  }

  // Mark notification as read
  static Future<void> markAsRead(String id) async {
    await FirebaseFirestore.instance.collection('notifications').doc(id).update({'isRead': true});
  }

  // Delete notification from Firestore
  static Future<void> deleteNotification(String id) async {
    await FirebaseFirestore.instance.collection('notifications').doc(id).delete();
  }

  // Get a stream of notifications
  static Stream<List<Notification>> getNotifications() {
    return FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((query) =>
        query.docs.map((doc) => Notification.fromFirestore(doc)).toList());
  }
}
