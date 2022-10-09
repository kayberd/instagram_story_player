import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_story_player/data/media_data.dart';
import 'package:instagram_story_player/models/story_group.dart';

part 'story_event.dart';

part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  StoryBloc() : super(StoryInitial()) {
    on<StoryEvent>((event, emit) {
      StoryUpdated? newState;
      var currGroupIndex = state.currGroupIndex;
      var currStoryIndex = state.currStoryIndexes[currGroupIndex];

      if (event is TapLeftEvent) {
        // GERİ GİDEMEZ AMA BAŞA SARAR
        if (currStoryIndex == 0 && currGroupIndex == 0) {
          // DO NOTHING RETURN SAME STATE
          // newState = state.copyWith();
        } else if (currStoryIndex != 0) {
          // GERİ GİDEBİLİR GRUP INDEXİ DEĞİŞMEZ STORY İNDEXİ 1 AZALIR
          state.currStoryIndexes[currGroupIndex]--;
          newState = state.copyWith(action: ACTION.prevStory);
        } else if (currStoryIndex == 0 && currGroupIndex != 0) {
          // GERİ GİDEBİLİR GRUP INDEXİ DEĞİŞİR
          newState = state.copyWith(currGroupIndex: currGroupIndex - 1, action: ACTION.prevGroup);
        } else {
          throw Exception("TAP-LEFT NOT HANDLED CASE");
        }
      } else if (event is SwipeRightEvent) {
        if (currGroupIndex == 0) {
          // DO NOTHING
          // newState = state.copyWith();
        } else {
          newState = state.copyWith(currGroupIndex: currGroupIndex - 1, action: ACTION.prevGroup);
        }
      } else if (event is TapRightEvent) {
        if (currStoryIndex == storyGroups[currGroupIndex].stories.length - 1 && currGroupIndex == storyGroups.length - 1) {
          // SON GRUBUN SON HİKAYESİ İSE DO NOTHING
          // newState = state.copyWith();
        } else if (currStoryIndex == storyGroups[currGroupIndex].stories.length - 1 && currGroupIndex != storyGroups.length - 1) {
          // SONDA OLMAYAN BİR GRUBUN SON HİKAYESİ
          newState = state.copyWith(currGroupIndex: currGroupIndex + 1, action: ACTION.nextGroup);
        } else if (currStoryIndex != storyGroups[currGroupIndex].stories.length - 1) {
          // SONDA OLMAYA BİR GRUBUN SONDA OLMAYAN BİR HİKAYESİ
          state.currStoryIndexes[currGroupIndex]++;
          newState = state.copyWith(action: ACTION.nextStory);
        } else {
          throw Exception("TAP-RIGHT NOT HANDLED CASE");
        }
      } else if (event is SwipeLeftEvent) {
        if (currGroupIndex == storyGroups.length - 1) {
          //newState = state.copyWith();
        } else {
          newState = state.copyWith(currGroupIndex: currGroupIndex + 1, action: ACTION.nextGroup);
        }
      } else {
        throw Exception("UNRECOGNIZED EVENT ERROR");
      }

      if (newState != null) {
        emit(newState);
      }
      return;
    });
  }
}
