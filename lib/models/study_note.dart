// lib/models/study_note.dart
class StudyNote {
  final String id;
  final String title;
  final String content;

  StudyNote({required this.id, required this.title, required this.content});

  // Convert StudyNote to a JSON map
  Map<String, String> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }

  // Create a StudyNote from a JSON map
  factory StudyNote.fromJson(Map<String, dynamic> json) {
    return StudyNote(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
}
