import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_story_player/models/story.dart';
import 'package:video_player/video_player.dart';

class StoryScreen extends StatefulWidget {
  final List<Story> stories;

  StoryScreen({required this.stories});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  late PageController _pageController;
  late VideoPlayerController _videoPlayerController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _videoPlayerController = VideoPlayerController.network(widget.stories[2].url)..initialize().then((value) => setState(() {}));
    _videoPlayerController.play();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
          controller: _pageController,
        itemCount: widget.stories.length,
        itemBuilder: (context, index) {
            final story = widget.stories[index];
            switch(story.media) {
              case MediaType.image:
                return CachedNetworkImage(imageUrl: story.url, fit: BoxFit.cover);
              case MediaType.video:
                if(_videoPlayerController.value.isInitialized) {
                  return FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _videoPlayerController.value.size.width,
                      height: _videoPlayerController.value.size.height,
                      child: VideoPlayer(_videoPlayerController),
                    ),
                  );
                } else return SizedBox.shrink();
            }
        },
      ),
    );
  }
}
