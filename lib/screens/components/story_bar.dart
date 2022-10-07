import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StoryBar extends StatelessWidget {
  double percentWatched = 0.0;
  StoryBar({required this.percentWatched});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      lineHeight: 15,
      percent: percentWatched,
      progressColor: Colors.grey[400],
      backgroundColor: Colors.grey[600],
    );
  }
}
