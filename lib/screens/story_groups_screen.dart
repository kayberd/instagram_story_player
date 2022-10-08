import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:instagram_story_player/bloc/story_bloc.dart';
import 'package:instagram_story_player/models/story_group.dart';
import 'package:instagram_story_player/screens/story_group_screen.dart';

int SWIPE_SENSITIVITY = 10;

class StoryGroupsScreen extends StatefulWidget {
  const StoryGroupsScreen({Key? key}) : super(key: key);

  @override
  State<StoryGroupsScreen> createState() => _StoryGroupsScreenState();
}

class _StoryGroupsScreenState extends State<StoryGroupsScreen> {
  late CarouselSliderController _controller;
  late List<StoryGroup> _storyGroups;
  late StoryBloc _storyBloc;
  late StreamSubscription<StoryState> sub;
  int lastStoryGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    _storyBloc = context.read<StoryBloc>();
    _controller = CarouselSliderController();
    _storyGroups = _storyBloc.state.storyGroups;

    sub = _storyBloc.stream.listen((event) {
      final newIndex = event.lastStoryGroupIndex;
      if (newIndex < lastStoryGroupIndex) {
        _controller.previousPage();
      } else {
        _controller.nextPage();
      }
      lastStoryGroupIndex = newIndex;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragUpdate: _swipeHandler,
        child: CarouselSlider.builder(
          slideBuilder: (index) => StoryGroupScreen(storyGroup: _storyGroups[index]),
          itemCount: _storyGroups.length,
          scrollPhysics: NeverScrollableScrollPhysics(),
          slideTransform: CubeTransform(),
          slideIndicator: CircularSlideIndicator(),
        ),
      ),
    );
  }

  void _swipeHandler(DragUpdateDetails details) {
    if (details.delta.dx > SWIPE_SENSITIVITY) {
      // SWIPE RIGHT
      _storyBloc.add(SwipeRightEvent());
    } else if (details.delta.dx < -SWIPE_SENSITIVITY) {
      // SWIPE LEFT
      _storyBloc.add(SwipeLeftEvent());
    }
  }
}
