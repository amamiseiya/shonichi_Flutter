part of 'formation_bloc.dart';

abstract class FormationEvent extends Equatable {
  const FormationEvent();
}

class FirstLoadFormation extends FormationEvent {
  @override
  String toString() => 'FirstLoadFormation';
  @override
  List<Object> get props => [];
}

class ReloadFormation extends FormationEvent {
  @override
  String toString() => 'ReloadFormation';
  @override
  List<Object> get props => [];
}

class FinishFetchingFormation extends FormationEvent {
  final List<Formation> formations;
  final List<Character> characters;
  FinishFetchingFormation(this.formations, this.characters);
  @override
  String toString() => 'FinishFetchingFormation';
  @override
  List<Object> get props => [formations, characters];
}

class PressAddFormation extends FormationEvent {
  @override
  String toString() => 'PressAddFormation';
  @override
  List<Object> get props => [];
}

class PressDeleteFormation extends FormationEvent {
  @override
  String toString() => 'PressDeleteFormation';
  @override
  List<Object> get props => [];
}

class ChangeSliderValue extends FormationEvent {
  final double sliderValue;
  ChangeSliderValue(this.sliderValue);
  @override
  String toString() => 'ChangeSliderValue';
  @override
  List<Object> get props => [sliderValue];
}

class ChangeCharacter extends FormationEvent {
  final Character character;
  ChangeCharacter(this.character);
  @override
  String toString() => 'ChangeCharacter';
  @override
  List<Object> get props => [character];
}

class ChangeTime extends FormationEvent {
  final Duration startTime;
  ChangeTime(this.startTime);
  @override
  String toString() => 'ChangeTime';
  @override
  List<Object> get props => [startTime];
}

class ChangeKCurveType extends FormationEvent {
  final KCurveType kCurveType;
  ChangeKCurveType(this.kCurveType);
  @override
  String toString() => 'ChangeKCurveType';
  @override
  List<Object> get props => [kCurveType];
}

class OnPanDownProgram extends FormationEvent {
  final DragDownDetails details;
  final List<Formation> frame;
  final BuildContext context;
  OnPanDownProgram(this.details, this.frame, this.context);
  @override
  String toString() => 'OnPanDownProgram';
  @override
  List<Object> get props => [details, frame, context];
}

class OnPanUpdateProgram extends FormationEvent {
  final DragUpdateDetails details;
  final List<Formation> frame;
  final BuildContext context;
  OnPanUpdateProgram(this.details, this.frame, this.context);
  @override
  String toString() => 'OnPanDownProgram';
  @override
  List<Object> get props => [details, frame, context];
}

class OnPanEndProgram extends FormationEvent {
  final DragEndDetails details;
  final List<Formation> frame;
  final BuildContext context;
  OnPanEndProgram(this.details, this.frame, this.context);
  @override
  String toString() => 'OnPanUpdateProgram';
  @override
  List<Object> get props => [details, frame, context];
}

class OnPanDownKCurve extends FormationEvent {
  final DragDownDetails details;
  final List<Offset> editingKCurve;
  final BuildContext context;
  OnPanDownKCurve(this.details, this.editingKCurve, this.context);
  @override
  String toString() => 'OnPanDownKCurve';
  @override
  List<Object> get props => [details, editingKCurve, context];
}

class OnPanUpdateKCurve extends FormationEvent {
  final DragUpdateDetails details;
  final List<Offset> editingKCurve;
  final BuildContext context;
  OnPanUpdateKCurve(this.details, this.editingKCurve, this.context);
  @override
  String toString() => 'OnPanDownKCurve';
  @override
  List<Object> get props => [details, editingKCurve, context];
}

class OnPanEndKCurve extends FormationEvent {
  final DragEndDetails details;
  final List<Offset> editingKCurve;
  final BuildContext context;
  OnPanEndKCurve(this.details, this.editingKCurve, this.context);
  @override
  String toString() => 'OnPanUpdateKCurve';
  @override
  List<Object> get props => [details, editingKCurve, context];
}
