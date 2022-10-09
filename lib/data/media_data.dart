import 'package:instagram_story_player/models/story.dart' show MediaType, Story;
import 'package:instagram_story_player/models/story_group.dart';

final List<Story> _stories = [
   Story(
    url:
        'https://cdn.pixabay.com/vimeo/147169807/Mercedes%20Glk%20-%201406.mp4?width=480&expiry=1665358558&hash=c9a13901d93662d4a66f7e21197c2db0a8646e8c',
    media: MediaType.video,
    duration: Duration(seconds: 10),
  ),
   Story(
    url: 'https://twitter.com/i/status/1578911410809364480',
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

