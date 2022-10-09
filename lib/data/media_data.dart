import 'package:instagram_story_player/models/story.dart' show MediaType, Story;
import 'package:instagram_story_player/models/story_group.dart';

final List<Story> _stories = [
   Story(
    url:
        'https://w7.pngwing.com/pngs/876/886/png-transparent-brand-circle-design-pattern-number-text-number-download-with-transparent-background-thumbnail.png',
    media: MediaType.image,
    duration: Duration(seconds: 10),
  ),
   Story(
    url: 'https://w7.pngwing.com/pngs/701/861/png-transparent-1-text-black-and-white-brand-pattern-number-1-angle-white-rectangle-thumbnail.png',
    media: MediaType.image,
    duration: Duration(seconds: 7),
  ),
   Story(
    url:
        'https://w7.pngwing.com/pngs/664/223/png-transparent-number-2-number-number-2-image-file-formats-text-heart-thumbnail.png',
    media: MediaType.image,
    duration: Duration(seconds: 5),
  ),
   Story(
    url: 'https://w7.pngwing.com/pngs/1004/858/png-transparent-number-3-text-logo-number-thumbnail.png',
    media: MediaType.image,
    duration: Duration(seconds: 0),
  ),
   Story(
    url: 'https://w7.pngwing.com/pngs/62/809/png-transparent-yellow-4-text-4-number-miscellaneous-angle-orange-thumbnail.png',
    media: MediaType.image,
    duration: Duration(seconds: 8),
  ),
  Story(
    url: 'https://w7.pngwing.com/pngs/823/185/png-transparent-gold-colored-5-number-number-5-image-file-formats-text-trademark-thumbnail.png',
    media: MediaType.image,
    duration: Duration(seconds: 8),
  ),

];
// final stories = _stories;
final List<StoryGroup> storyGroups = [
  StoryGroup(stories: [_stories[0],_stories[1]]),
  StoryGroup(stories: [_stories[2],_stories[3]]),
  StoryGroup(stories: [_stories[4],_stories[5]]),
  // StoryGroup(stories: [stories[0],stories[1]], user: 0),
  // StoryGroup(stories: [stories[0],stories[1]], user: 0),
];

final initStoryIndexes = List<int>.filled(storyGroups.length, 0);

