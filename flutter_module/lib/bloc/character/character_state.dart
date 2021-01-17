part of 'character_bloc.dart';

abstract class CharacterState extends Equatable {
  const CharacterState();
}

class CharacterUninitialized extends CharacterState {
  @override
  String toString() => 'CharacterUninitialized';
  @override
  List<Object> get props => [];
}
