part of 'formation_crud_bloc.dart';

@immutable
abstract class FormationCrudState extends Equatable {}

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

class FrameRetrieved extends FormationCrudState {
  final List<SNFormation> frame;
  FrameRetrieved(this.frame);
  @override
  String toString() => 'FrameRetrieved';
  @override
  List<Object> get props => [frame];
}

class CharacterFormationRetrieved extends FormationCrudState {
  final List<SNFormation> formations;
  CharacterFormationRetrieved(this.formations);
  @override
  String toString() => 'CharacterFormationRetrieved';
  @override
  List<Object> get props => [formations];
}
