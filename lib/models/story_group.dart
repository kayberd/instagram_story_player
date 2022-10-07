import 'package:instagram_story_player/models/story.dart';

class StoryGroup {
  List<Story> stories;
  int lastWatchedIndex = -1;

  StoryGroup({required this.stories}) {}

  forward() {
    if (lastWatchedIndex < stories.length - 1) {
      lastWatchedIndex++;
    }
  }

  backward() {
    if (lastWatchedIndex > -1) {
      lastWatchedIndex--;
    }
  }
}
