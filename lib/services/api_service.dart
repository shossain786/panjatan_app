import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:panjatan_app/constants.dart';
import '../models/sawal_model.dart';

class ApiService {
  static const String apiUrl = IRSHADAT_API;

  Future<List<SawalModel>> fetchSawals() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SawalModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
