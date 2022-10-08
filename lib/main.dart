import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_story_player/bloc/story_bloc.dart';
import 'package:instagram_story_player/screens/story_groups_screen.dart';

void main() {
  BlocOverrides.runZoned(() => runApp(const MyApp()), blocObserver: StoryBlocObserver());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider<StoryBloc>(
      create: (_) => StoryBloc(),
      child: StoryGroupsScreen(),
    ));
  }
}

class StoryBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('Bloc: $bloc');
    super.onTransition(bloc, transition);
  }

  @override
  void onCreate(BlocBase bloc) {
    print('Bloc Created');
    super.onCreate(bloc);
  }
}
