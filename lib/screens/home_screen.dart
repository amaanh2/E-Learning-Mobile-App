import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _promptController = TextEditingController();

  void _navigateToChatbot(BuildContext context) {
    final prompt = _promptController.text.trim();
    if (prompt.isNotEmpty) {
      Navigator.pushNamed(context, '/chatbot', arguments: prompt);
      _promptController.clear(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200), 
        child: AppBar(
          backgroundColor: Colors.blue[700], 
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30, 
                      backgroundImage: NetworkImage(
                        'https://media.istockphoto.com/id/1298261537/vector/blank-man-profile-head-icon-placeholder.jpg?s=2048x2048&w=is&k=20&c=arvyysiz2VuiQBB2DRZY0eXRu3169OlNJiSlqhupWF0=',
                      ),
                    ),
                    const SizedBox(width: 15), 
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold, 
                        color: Colors.white, 
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _promptController,
                        decoration: InputDecoration(
                          hintText: 'Enter a prompt...',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: Icon(Icons.arrow_forward, color: Colors.white),
                      onPressed: () => _navigateToChatbot(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[200], 
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            _buildSectionCard(context, 'Quizzes', Icons.question_answer, '/quizzes'),
            _buildSectionCard(context, 'Courses', Icons.school, '/courses'),
            _buildSectionCard(context, 'Study Notes', Icons.note, '/study_notes'),
            _buildSectionCard(context, 'Upcoming Tasks', Icons.calendar_today, '/tasks'),
            _buildSectionCard(context, 'Progress Tracker', Icons.trending_up, '/progress_tracker'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, IconData icon, String route) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Icon(icon, color: Colors.blue[900]),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}
