part of 'formation_crud_bloc.dart';

abstract class FormationCrudEvent extends Equatable {
  const FormationCrudEvent();
}

class FirstLoadFormation extends FormationCrudEvent {
  @override
  String toString() => 'FirstLoadFormation';
  @override
  List<Object> get props => [];
}

class ReloadFormation extends FormationCrudEvent {
  @override
  String toString() => 'ReloadFormation';
  @override
  List<Object> get props => [];
}

class FinishRetrievingFormation extends FormationCrudEvent {
  final List<SNFormation> formations;
  final List<SNCharacter> characters;
  FinishRetrievingFormation(this.formations, this.characters);
  @override
  String toString() => 'FinishRetrievingFormation';
  @override
  List<Object> get props => [formations, characters];
}

class PressAddFormation extends FormationCrudEvent {
  @override
  String toString() => 'PressAddFormation';
  @override
  List<Object> get props => [];
}

class PressDeleteFormation extends FormationCrudEvent {
  @override
  String toString() => 'PressDeleteFormation';
  @override
  List<Object> get props => [];
}

class ChangeSliderValue extends FormationCrudEvent {
  final double sliderValue;
  ChangeSliderValue(this.sliderValue);
  @override
  String toString() => 'ChangeSliderValue';
  @override
  List<Object> get props => [sliderValue];
}

class ChangeCharacter extends FormationCrudEvent {
  final SNCharacter character;
  ChangeCharacter(this.character);
  @override
  String toString() => 'ChangeCharacter';
  @override
  List<Object> get props => [character];
}

class ChangeTime extends FormationCrudEvent {
  final Duration startTime;
  ChangeTime(this.startTime);
  @override
  String toString() => 'ChangeTime';
  @override
  List<Object> get props => [startTime];
}

class ChangeKCurveType extends FormationCrudEvent {
  final KCurveType kCurveType;
  ChangeKCurveType(this.kCurveType);
  @override
  String toString() => 'ChangeKCurveType';
  @override
  List<Object> get props => [kCurveType];
}

class OnPanDownProgram extends FormationCrudEvent {
  final DragDownDetails details;
  final List<SNFormation> frame;
  final BuildContext context;
  OnPanDownProgram(this.details, this.frame, this.context);
  @override
  String toString() => 'OnPanDownProgram';
  @override
  List<Object> get props => [details, frame, context];
}

class OnPanUpdateProgram extends FormationCrudEvent {
  final DragUpdateDetails details;
  final List<SNFormation> frame;
  final BuildContext context;
  OnPanUpdateProgram(this.details, this.frame, this.context);
  @override
  String toString() => 'OnPanDownProgram';
  @override
  List<Object> get props => [details, frame, context];
}

class OnPanEndProgram extends FormationCrudEvent {
  final DragEndDetails details;
  final List<SNFormation> frame;
  final BuildContext context;
  OnPanEndProgram(this.details, this.frame, this.context);
  @override
  String toString() => 'OnPanUpdateProgram';
  @override
  List<Object> get props => [details, frame, context];
}

class OnPanDownKCurve extends FormationCrudEvent {
  final DragDownDetails details;
  final List<Offset> editingKCurve;
  final BuildContext context;
  OnPanDownKCurve(this.details, this.editingKCurve, this.context);
  @override
  String toString() => 'OnPanDownKCurve';
  @override
  List<Object> get props => [details, editingKCurve, context];
}

class OnPanUpdateKCurve extends FormationCrudEvent {
  final DragUpdateDetails details;
  final List<Offset> editingKCurve;
  final BuildContext context;
  OnPanUpdateKCurve(this.details, this.editingKCurve, this.context);
  @override
  String toString() => 'OnPanDownKCurve';
  @override
  List<Object> get props => [details, editingKCurve, context];
}

class OnPanEndKCurve extends FormationCrudEvent {
  final DragEndDetails details;
  final List<Offset> editingKCurve;
  final BuildContext context;
  OnPanEndKCurve(this.details, this.editingKCurve, this.context);
  @override
  String toString() => 'OnPanUpdateKCurve';
  @override
  List<Object> get props => [details, editingKCurve, context];
}
