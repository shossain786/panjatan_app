import '../models/sawal_model.dart';
import '../services/api_service.dart';
import '../db/local_db.dart';

class SawalRepository {
  final ApiService apiService;
  final LocalDB localDB;

  SawalRepository({
    required this.apiService,
    required this.localDB,
  });

  /// Fetch data from the local database
  Future<List<SawalModel>> fetchFromLocalDB() async {
    try {
      final sawals = await localDB.fetchAllSawals();
      return sawals;
    } catch (e) {
      throw Exception("Failed to fetch data from the local database: $e");
    }
  }

  /// Fetch data from the API and store it in the local database
  Future<void> syncData() async {
    try {
      final apiSawals = await apiService.fetchSawals();

      // Fetch existing data from the local database
      final localSawals = await localDB.fetchAllSawals();
      final localSawalIds = localSawals.map((s) => s.id).toSet();

      // Filter new data to avoid duplicates
      final newSawals = apiSawals.where((s) => !localSawalIds.contains(s.id)).toList();

      // Insert only new data
      for (var sawal in newSawals) {
        await localDB.insertSawal(sawal);
      }
    } catch (e) {
      throw Exception("Failed to sync data from the API: $e");
    }
  }
}
