part of 'summaries_bloc.dart';

class SummariesState extends Equatable {
  const SummariesState();
  
  @override
  List<Object> get props => [];
}

class SummariesInitial extends SummariesState {}

class SummariesLoading extends SummariesState {}

class SummariesLoadSuccess extends SummariesState {
  final Summaries summaries;

  const SummariesLoadSuccess(this.summaries);
}

class SummariesLoadFailure extends SummariesState {
  final String error;

  const SummariesLoadFailure({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return 'Failed to load summaries {error: $error}';
  }
}