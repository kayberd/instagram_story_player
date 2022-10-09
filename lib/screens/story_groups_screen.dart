import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:instagram_story_player/bloc/story_bloc.dart';
import 'package:instagram_story_player/data/media_data.dart';
import 'package:instagram_story_player/models/story_group.dart';
import 'package:instagram_story_player/screens/story_group_screen.dart';

class StoryGroupsScreen extends StatefulWidget {
  const StoryGroupsScreen({Key? key}) : super(key: key);

  @override
  State<StoryGroupsScreen> createState() => _StoryGroupsScreenState();
}

class _StoryGroupsScreenState extends State<StoryGroupsScreen> {
  late List<StoryGroup> _storyGroups = storyGroups;
  late CarouselSliderController _controller;
  late StoryBloc _storyBloc;
  late StreamSubscription<StoryState> sub;
  int currGroupIndex = 0;
  bool allowEvent = true;

  @override
  void initState() {
    super.initState();
    _storyBloc = context.read<StoryBloc>();
    _controller = CarouselSliderController();
    sub = _storyBloc.stream.listen((state) {
      if (currGroupIndex != state.currGroupIndex) {
        if (state.action == ACTION.nextGroup) {
          _controller.nextPage(Duration(seconds: 1));
        } else if (state.action == ACTION.prevGroup) {
          _controller.previousPage(Duration(seconds: 1));
        }
        currGroupIndex = state.currGroupIndex;
      }
    });
  }

  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider.builder(
        controller: _controller,
        onSlideChanged: _slideChangedHandler,
        slideBuilder: (index) => StoryGroupScreen(index: index),
        itemCount: _storyGroups.length,
        slideTransform: CubeTransform(),
      ),
    );
  }

  void _slideChangedHandler(int newIndex) {
    if (newIndex < currGroupIndex) {
      // SWIPE RIGHT
      _storyBloc.add(SwipeRightEvent(-2));
    } else if (newIndex > currGroupIndex) {
      // SWIPE LEFT
      _storyBloc.add(SwipeLeftEvent(-2));
    } else {
      // INDEX NOT CHANGED
    }
    currGroupIndex = newIndex;
  }

// _simulateSwipeRight() async {
//   GestureBinding.instance.handlePointerEvent(PointerDownEvent(
//     position: Offset(200, 300),
//   ));
//   await Future.delayed(Duration(milliseconds: 500));
//   GestureBinding.instance.handlePointerEvent(Pointer)
//   GestureBinding.instance.handlePointerEvent(PointerUpEvent(
//     position: Offset(200, 300),
//   ));
// }

}
