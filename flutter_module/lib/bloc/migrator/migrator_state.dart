part of 'migrator_bloc.dart';

abstract class MigratorState extends Equatable {
  const MigratorState();
}

class MigratorInitial extends MigratorState {
  @override
  List<Object> get props => [];
}

class MarkdownPreviewGenerated extends MigratorState {
  final String markdownText;
  MarkdownPreviewGenerated(this.markdownText);
  @override
  String toString() => 'MarkdownPreviewGenerated';
  @override
  List<Object> get props => [markdownText];
}

class MarkdownExported extends MigratorState {
  @override
  String toString() => 'MarkdownExported';
  @override
  List<Object> get props => [];
}
