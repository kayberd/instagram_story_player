part of 'story_bloc.dart';

abstract class StoryState extends Equatable {
  final List<StoryGroup> storyGroups;
  final int currStoryIndex;
  final int currStoryGroupIndex;

  StoryState(this.storyGroups, this.currStoryGroupIndex, this.currStoryIndex);

  copyWith({List<StoryGroup>? storyGroup, int? currStoryIndex, int? currStoryGroupIndex});

  @override
  List<Object> get props => [storyGroups, currStoryIndex, currStoryGroupIndex];
}

class StoryInitial extends StoryState {
  StoryInitial() : super(storyGroups, 0, 0);

  @override
  copyWith({List<StoryGroup>? storyGroup, int? currStoryIndex, int? currStoryGroupIndex}) {}
}

class StoryUpdated extends StoryState {
  StoryUpdated(
    super.storyGroup,
    super.currStoryGroupIndex,
    super.currStoryIndex,
  );

  @override
  StoryUpdated copyWith({List<StoryGroup>? storyGroup, int? currStoryIndex, int? currStoryGroupIndex}) {
    return StoryUpdated(storyGroup ?? this.storyGroups, currStoryIndex ?? this.currStoryIndex, currStoryGroupIndex ?? this.currStoryGroupIndex);
  }
}
