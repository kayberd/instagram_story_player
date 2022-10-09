import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_story_player/bloc/story_bloc.dart';
import 'package:instagram_story_player/data/media_data.dart';
import 'package:instagram_story_player/models/story.dart';
import 'package:instagram_story_player/models/story_group.dart';
import 'package:instagram_story_player/screens/components/story_bars.dart';

class StoryGroupScreen extends StatefulWidget {
  final int index;

  StoryGroupScreen({required this.index});

  @override
  State<StoryGroupScreen> createState() => _StoryGroupScreenState();
}

class _StoryGroupScreenState extends State<StoryGroupScreen> {
  late PageController _pageController;
  late StoryBloc _bloc;
  late StreamSubscription<StoryState> _sub;

  late List<Story> _stories;
  late Timer _timer;

  // late VideoPlayerController _videoPlayerController;
  int currStoryIndex = 0;
  double percentWatched = 0.0;
  bool isStopped = false;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<StoryBloc>();
    _stories = storyGroups[widget.index].stories;
    _pageController = PageController(initialPage: currStoryIndex);
    _sub = _bloc.stream.listen((state) {
      print("INDEX: ${widget.index}");
      switch (state.action) {
        case ACTION.init:
          break;
        case ACTION.nextStory:
          _forward();
          break;
        case ACTION.prevStory:
          _backward();
          break;
        case ACTION.nextGroup:
          _terminate();
          break;
        case ACTION.prevGroup:
          _terminate();
          break;
      }
    });
    _startWatching();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _terminate();
    _pageController.dispose();
    super.dispose();
  }

  _terminate() {
    _timer.cancel();
    _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: _tapHandler,
        child: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
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
                media,
                StoryBars(currStoryIndex: currStoryIndex, totalBarCount: _stories.length, currWatchedPercent: percentWatched),

                // Padding(
                //   padding: const EdgeInsets.only(top: 16, left: 4, right: 4),
                //   child: Text(
                //     '${_bloc.state.lastStoryGroupIndex} - ${currStoryIndex}',
                //     style: TextStyle(fontSize: 25, color: Colors.red),
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _startWatching() {
    percentWatched = 0.0;
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      print("TIMER: ${widget.index}");
      if (!isStopped) {
        if (percentWatched + 0.01 < 1) {
          setState(() => percentWatched += 0.1);
        } else {
          _timer.cancel();
          _bloc.add(TapRightEvent(widget.index));
        }
      }
    });
  }

  void _tapHandler(TapDownDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;
    if (dx < screenWidth / 4) {
      _bloc.add(TapLeftEvent(widget.index));

    } else if (dx > (screenWidth * 3) / 4) {
      _bloc.add(TapRightEvent(widget.index));
    }
  }

  _forward() {
    setState(() {
      currStoryIndex++;
    });
    _pageController.nextPage(duration: Duration(milliseconds: 1), curve: Curves.linear);
    _startWatching();
  }

  _backward() {
    setState(() {
      currStoryIndex--;
    });
    _pageController.previousPage(duration: Duration(milliseconds: 1), curve: Curves.linear);
    _startWatching();
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
