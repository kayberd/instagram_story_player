import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_story_player/bloc/story_bloc.dart';
import 'package:instagram_story_player/models/story.dart';
import 'package:instagram_story_player/models/story_group.dart';
import 'package:instagram_story_player/screens/components/story_bars.dart';
import 'package:video_player/video_player.dart';

class StoryGroupScreen extends StatefulWidget {
  final StoryGroup storyGroup;

  StoryGroupScreen({required this.storyGroup});

  @override
  State<StoryGroupScreen> createState() => _StoryGroupScreenState();
}

class _StoryGroupScreenState extends State<StoryGroupScreen> {
  late PageController _pageController;
  late StoryBloc _bloc;
  late StreamSubscription<StoryState> sub;
  late List<Story> _stories;

  // late VideoPlayerController _videoPlayerController;
  int lastStoryIndex = -1;
  double percentWatched = 0.0;
  bool isStopped = false;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<StoryBloc>();
    _stories = widget.storyGroup.stories;
    _pageController = PageController();
    sub = _bloc.stream.listen((event) {
      final newIndex = event.storyGroups[event.lastStoryGroupIndex].lastWatchedIndex;
      if (lastStoryIndex < newIndex) {
        _pageController.nextPage(duration: Duration(), curve: Curves.linear);
      } else if (lastStoryIndex > newIndex) {
        _pageController.previousPage(duration: Duration(), curve: Curves.linear);
      }
      setState(() {
        lastStoryIndex = newIndex;
        percentWatched = 0.0;
      });
    });
    _startWatching();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPress: _holdHandler,
        onLongPressUp: _relaseHandler,
        onTapDown: _tapHandler,
        child: PageView.builder(
          controller: _pageController,
          itemCount: _stories.length,
          itemBuilder: (context, index) {
            var media;
            final story = _stories[index];
            switch (story.media) {
              case MediaType.image:
                media = CachedNetworkImage(imageUrl: story.url, fit: BoxFit.cover);
                break;
              case MediaType.video:
                // media = _videoPlayerController.value.isInitialized
                //     ? FittedBox(
                //   fit: BoxFit.cover,
                //   child: SizedBox(
                //     width: _videoPlayerController.value.size.width,
                //     height: _videoPlayerController.value.size.height,
                //     child: VideoPlayer(_videoPlayerController),
                //   ),
                // )
                //     : ErrorWidget(Exception("Video error"));
                media = ErrorWidget(Exception("It is a video"));
                break;
            }
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 4, right: 4),
                  child: StoryBars(
                    lastWatchedIndex: lastStoryIndex,
                    currWatchedPercent: percentWatched,
                    totalBarCount: _stories.length,
                  ),
                ),
                media
              ],
            );
          },
        ),
      ),
    );
  }

  void _startWatching() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        if (!isStopped) {
          if (percentWatched + 0.01 < 1  ) {
            percentWatched += 0.1;
          } else {
            _bloc.add(TapRightEvent());
            timer.cancel();
          }
        }
      });
    });
  }

  void _tapHandler(TapDownDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;
    if (dx < screenWidth / 4) {
      _bloc.add(TapLeftEvent());
    } else if (dx < (screenWidth * 3) / 4) {
      // TODO: Forward
      _bloc.add(TapRightEvent());
    }
  }

  void _holdHandler() {
    setState(() {
      isStopped = true;
    });
  }

  void _relaseHandler() {
    setState(() {
      isStopped = false;
    });
  }
}
