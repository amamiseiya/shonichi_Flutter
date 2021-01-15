import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  CharacterBloc(CharacterState initialState) : super(initialState);

  @override
  CharacterState get initialState => CharacterUninitialized();

  @override
  Stream<CharacterState> mapEventToState(
    CharacterEvent event,
  ) async* {
    if (event is ReloadResources) {
      // yield* mapReloadResourcesToState();
    }
  }
}
