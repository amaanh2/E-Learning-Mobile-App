import 'package:flutter/material.dart';
import '../screens/chatbot_screen.dart';
import '../screens/courses_screen.dart';
import '../screens/home_screen.dart';
import '../screens/progress_tracker_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/study_notes_screen.dart';
import '../screens/tasks_screen.dart';


class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder = (BuildContext _) => HomeScreen(); //show Home Screen by default
            break;
          case '/quizzes':
            builder = (BuildContext _) => const QuizScreen();
            break;
          case '/courses':
            builder = (BuildContext _) => const CoursesScreen();
            break;
          case '/study_notes':
            builder = (BuildContext _) => StudyNotesScreen();
            break;
          case '/tasks':
            builder = (BuildContext _) => const TasksScreen();
            break;
          case '/progress_tracker':
            builder = (BuildContext _) => const ProgressTrackerScreen();
            break;
          case '/chatbot':
            builder = (BuildContext _) => ChatbotScreen();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}