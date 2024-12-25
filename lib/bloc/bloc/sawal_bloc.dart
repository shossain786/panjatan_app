import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panjatan_app/repositories/sawal_repository.dart';
import 'sawal_event.dart';
import 'sawal_state.dart';

class SawalBloc extends Bloc<SawalEvent, SawalState> {
  final SawalRepository sawalRepository;

  SawalBloc(this.sawalRepository) : super(SawalInitial()) {
    on<FetchSawals>(_onFetchSawals);
    on<SyncSawals>(_onSyncSawals);
  }

Future<void> _onFetchSawals(FetchSawals event, Emitter<SawalState> emit) async {
  emit(SawalLoading());
  try {
    final sawals = await sawalRepository.fetchFromLocalDB();
    if (sawals.isEmpty) {
      emit(SawalEmpty('No data found. Please sync to fetch new data.'));
    } else {
      emit(SawalLoaded(sawals));
    }
  } catch (e) {
    emit(SawalError('Failed to load data: ${e.toString()}'));
  }
}

  /// Handles syncing data from the API and updating the local database
  Future<void> _onSyncSawals(SyncSawals event, Emitter<SawalState> emit) async {
    emit(SawalLoading());
    try {
      await sawalRepository.syncData();
      final updatedSawals = await sawalRepository.fetchFromLocalDB();
      emit(SawalLoaded(updatedSawals)); // Emit updated state
    } catch (e) {
      emit(SawalError('Failed to sync data: ${e.toString()}'));
    }
  }
}
