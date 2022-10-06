import 'package:instagram_story_player/models/story.dart' show MediaType, Story;
import 'package:instagram_story_player/models/story_group.dart';

final List<Story> _stories = [
   Story(
    url:
        'https://images.unsplash.com/photo-1534103362078-d07e750bd0c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
    media: MediaType.image,
    duration: Duration(seconds: 10),
  ),
   Story(
    url: 'https://media.giphy.com/media/moyzrwjUIkdNe/giphy.gif',
    media: MediaType.image,
    duration: Duration(seconds: 7),
  ),
   Story(
    url:
        'https://images.unsplash.com/photo-1531694611353-d4758f86fa6d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=564&q=80',
    media: MediaType.image,
    duration: Duration(seconds: 5),
  ),
   Story(
    url: 'https://static.videezy.com/system/resources/previews/000/007/536/original/rockybeach.mp4',
    media: MediaType.video,
    duration: Duration(seconds: 0),
  ),
   Story(
    url: 'https://media2.giphy.com/media/M8PxVICV5KlezP1pGE/giphy.gif',
    media: MediaType.image,
    duration: Duration(seconds: 8),
  ),
];
final List<StoryGroup> storyGroups = [
  StoryGroup(stories: [_stories[0],_stories[1]], user: 0),
  StoryGroup(stories: [_stories[2],_stories[3]], user: 0),
  StoryGroup(stories: [_stories[4],_stories[2]], user: 0),
  // StoryGroup(stories: [stories[0],stories[1]], user: 0),
  // StoryGroup(stories: [stories[0],stories[1]], user: 0),
];
