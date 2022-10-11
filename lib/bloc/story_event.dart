part of 'story_bloc.dart';

abstract class StoryEvent extends Equatable {
  final sender;

  const StoryEvent(this.sender) : super();

  List<Object?> get props => [sender];
}

class TapLeftEvent extends StoryEvent {
  TapLeftEvent(super.sender);
}

class TapRightEvent extends StoryEvent {
  TapRightEvent(super.sender);
}

class SwipeLeftEvent extends StoryEvent {
  SwipeLeftEvent(super.sender);
}

class SwipeRightEvent extends StoryEvent {
  SwipeRightEvent(super.sender);
}
