import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StoryBar extends StatelessWidget {
  double percentWatched = 0.0;
  final double width;
  StoryBar({required this.percentWatched, required this.width});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      width: width,
      lineHeight: 15,
      percent: percentWatched,
      progressColor: Colors.grey[400],
      backgroundColor: Colors.grey[600],
    );
  }
}
