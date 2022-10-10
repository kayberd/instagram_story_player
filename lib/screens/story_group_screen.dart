import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
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
  Timer? _timer;

  // late VideoPlayerController _videoPlayerController;
  late int currStoryIndex;
  late int currStoryGroup;
  int timerCount = 0;
  late double percentWatched;
  bool isStopped = false;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<StoryBloc>();
    _stories = storyGroups[widget.index].stories;
    currStoryIndex = _bloc.state.currStoryIndexes[widget.index];
    currStoryGroup = _bloc.state.currGroupIndex;
    _pageController = PageController(initialPage: currStoryIndex);
    _sub = _bloc.stream.listen((state) {
      setState(() {
        currStoryIndex = state.currStoryIndexes[widget.index];
        currStoryGroup = state.currGroupIndex;
      });
    });
    _startWatching();
  }

  @override
  void dispose() {
    _sub.cancel();
    _pageController.dispose();
    _clearTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPressDown: _holdHandler,
        onLongPressUp: _releaseHandler,
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
                Center(child: media),
                Container(
                  padding: EdgeInsets.only(top: 28.0),
                  height: 16.0,
                  child: StoryBars(currStoryIndex: currStoryIndex, totalBarCount: _stories.length, currWatchedPercent: percentWatched),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _startWatching([int? index]) {
    setState(() {
      percentWatched = 0.0;
    });
    _clearTimer();
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      _onTick(timer);
    });
  }

  void _tapHandler(TapDownDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;
    if (dx < screenWidth / 4) {
      _backward();
    } else if (dx > (screenWidth * 3) / 4) {
      _forward();
    }
  }

  _forward() {
    _bloc.add(TapRightEvent(widget.index));
    setState(() {
      currStoryIndex++;
    });
    _pageController.nextPage(duration: Duration(milliseconds: 1), curve: Curves.linear);
    _startWatching();
  }

  _backward() {
    _bloc.add(TapLeftEvent(widget.index));
    if (currStoryIndex != 0) {
      setState(() {
        currStoryIndex--;
      });
    }
    _pageController.previousPage(duration: Duration(milliseconds: 1), curve: Curves.linear);
    _startWatching();
  }

  void _releaseHandler() {
    isStopped = false;
  }

  void _holdHandler(LongPressDownDetails details) {
    isStopped = false;
  }

  void _onTick(Timer timer) {
    if (isStopped) return;
    print("TIMER: ${widget.index} - IS_MOUNTED: ${mounted} - CURR_GROUP_INDEX: ${currStoryGroup} - percentWatched: $percentWatched");

    if (mounted && currStoryGroup == widget.index) {
      if (percentWatched + 0.01 < 1) {
        setState(() => percentWatched += 0.1);
      } else {
        _forward();
      }
    }
  }

  void _clearTimer() {
    if(_timer?.isActive ?? false) _timer!.cancel();
  }
}
