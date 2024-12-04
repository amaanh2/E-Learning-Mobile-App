import 'package:elearning_group_project/firebase_options.dart';
import 'package:elearning_group_project/tabs/home_tab.dart';
import 'package:elearning_group_project/tabs/profile_tab.dart';
import 'package:elearning_group_project/tabs/camera_tab.dart';
import 'package:elearning_group_project/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 1; // Default to Home Tab

  final List<Widget> _tabs = [
    const CameraTab(), //Camera Tab is its own screen
    const HomeTab(), //Home Tab contains Home Screen
    const SizedBox(),

  ];

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  ProfileScreen(), 
              ),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
