part of 'formation_crud_bloc.dart';

abstract class FormationCrudState extends Equatable {
  const FormationCrudState();
}

class FormationUninitialized extends FormationCrudState {
  @override
  String toString() => 'FormationUninitialized';
  @override
  List<Object> get props => [];
}

class RetrievingFormation extends FormationCrudState {
  @override
  String toString() => 'RetrievingFormation';
  @override
  List<Object> get props => [];
}

class FormationRetrieved extends FormationCrudState {
  final List<SNFormation> formations;
  final List<SNCharacter> characters;
  FormationRetrieved(this.formations, this.characters);
  @override
  String toString() => 'FormationRetrieved';
  @override
  List<Object> get props => [formations, characters];
}

class FrameLoaded extends FormationCrudState {
  final List<SNFormation> frame;
  FrameLoaded(this.frame);
  @override
  String toString() => 'FrameLoaded';
  @override
  List<Object> get props => [frame];
}

class CharacterFormationLoaded extends FormationCrudState {
  final List<SNFormation> formations;
  CharacterFormationLoaded(this.formations);
  @override
  String toString() => 'CharacterFormationLoaded';
  @override
  List<Object> get props => [formations];
}
