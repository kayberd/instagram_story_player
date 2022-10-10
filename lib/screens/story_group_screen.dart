import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/gestures/long_press.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_story_player/bloc/story_bloc.dart';
import 'package:instagram_story_player/data/media_data.dart';
import 'package:instagram_story_player/models/story.dart';
import 'package:instagram_story_player/models/story_group.dart';
import 'package:instagram_story_player/screens/components/story_bars.dart';
import 'package:video_player/video_player.dart';

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

  late VideoPlayerController _videoPlayerController;
  Future<void>? _initializeVideoPlayerFuture;

  late int currStoryIndex;
  late int currStoryGroup;
  int timerCount = 0;
  double percentWatched = 0.0;
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

  Future<void> _initVideoPlayer(String url) async {
    _videoPlayerController = VideoPlayerController.network(url);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
  }

  @override
  void dispose() {
    _sub.cancel();
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
    _videoPlayerController.dispose();
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
                _initVideoPlayer(story.url);
                media = FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.done) {
                      _videoPlayerController.play();
                      return Center(
                          child: AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController),
                      ));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                );
                break;
            }
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Center(
                  child: media,
                ),
                Container(
                  padding: EdgeInsets.only(top: 16.0),
                  height: 50,
                  child: StoryBars(currStoryIndex: currStoryIndex, totalBarCount: _stories.length, currWatchedPercent: percentWatched),
                ),
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

  void _startWatching([int? index]) {
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
    _timer?.cancel();
    percentWatched = 0.0;
    _bloc.add(TapRightEvent(widget.index));
    setState(() {
      currStoryIndex++;
    });
    _pageController.nextPage(duration: Duration(milliseconds: 1), curve: Curves.linear);
    _startWatching();
  }

  _backward() {
    _timer?.cancel();
    percentWatched = 0.0;
    _bloc.add(TapLeftEvent(widget.index));
    setState(() {
      currStoryIndex--;
    });
    _pageController.previousPage(duration: Duration(milliseconds: 1), curve: Curves.linear);
    _startWatching();
  }

  void _releaseHandler() {
    isStopped = false;
  }

  void _holdHandler(LongPressDownDetails details) {
    isStopped = true;
  }

  void _onTick(Timer timer) {
    print("TIMER: ${widget.index} - percentWatched: $percentWatched");
    if (isStopped) return;
    if (mounted && currStoryGroup == widget.index) {
      if (percentWatched + 0.01 < 1) {
        setState(() => percentWatched += 0.1);
      } else {
        timer.cancel();
        _timer?.cancel();
        _forward();
      }
    } else {
      percentWatched = 0.0;
      timer.cancel();
      _timer?.cancel();
    }
  }
}
