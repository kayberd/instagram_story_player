import 'package:flutter/material.dart';
import 'package:instagram_story_player/screens/components/story_bar.dart';

class StoryBars extends StatelessWidget {
  final int currStoryIndex;
  final int totalBarCount;
  final double currWatchedPercent;

  StoryBars({required this.currStoryIndex, required this.totalBarCount, required this.currWatchedPercent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemCount: totalBarCount,
        itemBuilder: (context, index) {
          final barWidth = MediaQuery.of(context).size.width / totalBarCount;
          if (index < currStoryIndex) {
            return StoryBar(percentWatched: 1, width: barWidth);
          } else if (index == currStoryIndex) {
            return StoryBar(percentWatched: currWatchedPercent, width: barWidth);
          } else {
            return StoryBar(percentWatched: 0, width: barWidth);
          }
        },
      ),
    );
  }
}
