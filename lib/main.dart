import 'package:flutter/material.dart';
import 'package:instagram_story_player/assets/media_data.dart';
import 'package:instagram_story_player/screens/story_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StoryScreen(stories: stories),
    );
  }
}

