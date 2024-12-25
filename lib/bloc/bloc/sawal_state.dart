
import 'package:panjatan_app/models/sawal_model.dart';

abstract class SawalState {
  const SawalState();

  @override
  List<Object?> get props => [];
}

class SawalInitial extends SawalState {}

class SawalLoading extends SawalState {}

class SawalLoaded extends SawalState {
  final List<SawalModel> sawals;

  const SawalLoaded(this.sawals);

  @override
  List<Object?> get props => [sawals];
}

class SawalEmpty extends SawalState {
  final String message;

  const SawalEmpty(this.message);

  @override
  List<Object?> get props => [message];
}

class SawalError extends SawalState {
  final String message;

  const SawalError(this.message);

  @override
  List<Object?> get props => [message];
}
