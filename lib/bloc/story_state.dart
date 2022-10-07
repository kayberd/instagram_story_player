part of 'story_bloc.dart';

abstract class StoryState extends Equatable {
  final List<StoryGroup> storyGroups;
  final int lastStoryGroupIndex;

  StoryState(this.storyGroups, this.lastStoryGroupIndex);

  copyWith({List<StoryGroup>? storyGroup, int? lastStoryGroupIndex});

  @override
  List<Object> get props => [storyGroups, lastStoryGroupIndex];
}

class StoryInitial extends StoryState {
  StoryInitial() : super(storyGroups, 0);

  @override
  copyWith({List<StoryGroup>? storyGroup, int? lastStoryGroupIndex}) {}
}

class StoryUpdated extends StoryState {
  StoryUpdated(super.storyGroup, super.lastStoryGroupIndex);

  @override
  StoryUpdated copyWith({List<StoryGroup>? storyGroup, int? lastStoryGroupIndex}) {
    return StoryUpdated(storyGroup ?? this.storyGroups, lastStoryGroupIndex ?? this.lastStoryGroupIndex);
  }
}
