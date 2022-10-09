part of 'story_bloc.dart';

enum ACTION { init, nextStory, prevStory, nextGroup, prevGroup }

abstract class StoryState extends Equatable {
  final List<int> currStoryIndexes;
  final int currGroupIndex;
  final ACTION action;

  StoryState(this.currStoryIndexes, this.currGroupIndex, this.action);

  StoryUpdated copyWith({List<int>? currStoryIndexes, int? currGroupIndex, ACTION? action}) {
    return StoryUpdated(currStoryIndexes ?? this.currStoryIndexes, currGroupIndex ?? this.currGroupIndex, action!);
  }

  @override
  List<Object> get props => [currStoryIndexes, currGroupIndex];
}

class StoryInitial extends StoryState {
  StoryInitial() : super(initStoryIndexes, 0, ACTION.init);
}

class StoryUpdated extends StoryState {
  StoryUpdated(super.storyGroup, super.currGroupIndex, super.action);
}
