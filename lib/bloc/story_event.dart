part of 'story_bloc.dart';

abstract class StoryEvent extends Equatable {
  const StoryEvent() : super();

  List<Object?> get props => [];
}

class TapLeftEvent extends StoryEvent {}

class TapRightEvent extends StoryEvent {}

class SwipeLeftEvent extends StoryEvent {}

class SwipeRightEvent extends StoryEvent {}
