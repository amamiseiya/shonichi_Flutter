part of 'migrator_bloc.dart';

@immutable
abstract class MigratorEvent extends Equatable {
  const MigratorEvent();
}

class ImportMarkdown extends MigratorEvent {
  final String key;
  ImportMarkdown(this.key);
  @override
  String toString() => 'ImportMarkdown';
  @override
  List<Object> get props => [key];
}

class ConfirmImportMarkdown extends MigratorEvent {
  @override
  String toString() => 'ConfirmImportMarkdown';
  @override
  List<Object> get props => [];
}

class PreviewMarkdown extends MigratorEvent {
  @override
  String toString() => 'PreviewMarkdown';
  @override
  List<Object> get props => [];
}

class ExportMarkdown extends MigratorEvent {
  final String key;
  ExportMarkdown(this.key);
  @override
  String toString() => 'ExportMarkdown';
  @override
  List<Object> get props => [key];
}
