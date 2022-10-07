import 'package:flutter/material.dart';
import 'package:instagram_story_player/screens/components/story_bar.dart';

class StoryBars extends StatelessWidget {
   int lastWatchedIndex;
   int totalBarCount;
   double currWatchedPercent;
   StoryBars({required this.lastWatchedIndex, required this.totalBarCount, required this.currWatchedPercent});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      itemCount: totalBarCount,
      itemBuilder: (context, index) {
        return index <= lastWatchedIndex ? StoryBar(percentWatched: 1) : StoryBar(percentWatched: currWatchedPercent);
      },
    );
  }
}
