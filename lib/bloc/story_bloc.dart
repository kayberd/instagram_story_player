import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_story_player/data/media_data.dart';
import 'package:instagram_story_player/models/story_group.dart';

part 'story_event.dart';

part 'story_state.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  StoryBloc() : super(StoryInitial()) {
    on((event, emit) {
      var newState;
      final storyGroups = state.storyGroups;
      var lastGroupIndex = state.lastStoryGroupIndex;
      var lastStoryIndex = storyGroups[lastGroupIndex].lastWatchedIndex;

      if (event is TapLeftEvent) {
        // GERİ GİDEMEZ AMA BAŞA SARAR
        if (lastStoryIndex == -1 && lastGroupIndex == 0) {
          // DO NOTHING RETURN SAME STATE
          newState = state;
        } else if (lastStoryIndex != 0) {
          // GERİ GİDEBİLİR GRUP INDEXİ DEĞİŞMEZ STORY İNDEXİ 1 AZALIR
          state.storyGroups[lastGroupIndex].backward();
          newState = state;
        } else if (lastStoryIndex == -1 && lastGroupIndex != 0) {
          // GERİ GİDEBİLİR GRUP INDEXİ DEĞİŞİR
          newState = state.copyWith(lastStoryGroupIndex: lastGroupIndex - 1);
        }
      } else if (event is SwipeRightEvent) {
        if (lastGroupIndex == 0) {
          // DO NOTHING
          newState = state;
        } else {
          newState = state.copyWith(lastStoryGroupIndex: lastGroupIndex - 1);
        }
      } else if (event is TapRightEvent) {
        if (lastStoryIndex == storyGroups[lastGroupIndex].stories.length - 1 && lastGroupIndex == storyGroups.length - 1) {
          // SON GRUBUN SON HİKAYESİ İSE DO NOTHING
          newState = state;
        } else if (lastStoryIndex == storyGroups[lastGroupIndex].stories.length - 1 && lastGroupIndex != storyGroups.length - 1) {
          // SONDA OLMAYAN BİR GRUBUN SON HİKAYESİ
          newState = state.copyWith(lastStoryGroupIndex: lastGroupIndex + 1);
        } else {
          // SONDA OLMAYA BİR GRUBUN SONDA OLMAYAN BİR HİKAYESİ
          state.storyGroups[lastGroupIndex].forward();
          newState = state;
        }
      } else if (event is SwipeLeftEvent) {
        if( lastGroupIndex == state.storyGroups.length - 1){
          newState = state;
        } else {
          newState = state.copyWith(lastStoryGroupIndex: lastGroupIndex + 1);
        }
      }

      emit(newState);
      return;
    });
  }
}
