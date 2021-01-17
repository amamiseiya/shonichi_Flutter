part of 'character_bloc.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();
}

class ReloadResources extends CharacterEvent {
  @override
  String toString() => 'ReloadResources';
  @override
  List<Object> get props => [];
}
