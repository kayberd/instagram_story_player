import 'package:cube_transition_plus/cube_transition_plus.dart';
import 'package:flutter/material.dart';
import 'package:instagram_story_player/data/media_data.dart';

class Sample2 extends StatefulWidget {
  @override
  State<Sample2> createState() => _Sample2State();
}

class _Sample2State extends State<Sample2> {
  late PageController _controller;

  initState(){
    super.initState();
    _controller = PageController();
  }

  fun(){
    _controller.nextPage(duration: Duration(milliseconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CubePageView(
        controller: _controller,
        children: stories
            .map(
              (item) => Center(
                child: Image.network(
                  item.url,
                  fit: BoxFit.fitHeight,
                ),
              ),
            )
            .toList(),
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fun,
      ),
    );
  }
}
