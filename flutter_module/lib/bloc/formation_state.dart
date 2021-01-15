part of 'formation_bloc.dart';

abstract class FormationState extends Equatable {
  const FormationState();
}

class FormationUninitialized extends FormationState {
  @override
  String toString() => 'FormationUninitialized';
  @override
  List<Object> get props => [];
}

class FetchingFormation extends FormationState {
  @override
  String toString() => 'FetchingFormation';
  @override
  List<Object> get props => [];
}

class FormationFetched extends FormationState {
  final List<Formation> formations;
  final List<Character> characters;
  FormationFetched(this.formations, this.characters);
  @override
  String toString() => 'FormationFetched';
  @override
  List<Object> get props => [formations, characters];
}

class FrameLoaded extends FormationState {
  final List<Formation> frame;
  FrameLoaded(this.frame);
  @override
  String toString() => 'FrameLoaded';
  @override
  List<Object> get props => [frame];
}

class CharacterFormationLoaded extends FormationState {
  final List<Formation> formations;
  CharacterFormationLoaded(this.formations);
  @override
  String toString() => 'CharacterFormationLoaded';
  @override
  List<Object> get props => [formations];
}
