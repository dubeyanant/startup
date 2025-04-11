import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:start_invest/models/startup_model.dart';
import 'package:start_invest/utils/database_helper.dart';

// Remove the _loadStartupData function as it's replaced by DatabaseHelper
/*
Future<List<Startup>> _loadStartupData() async {
  final String jsonString = await rootBundle.loadString(
    'assets/startup_data.json',
  );
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((json) => Startup.fromJson(json)).toList();
}
*/

// Rename the provider to reflect its purpose (e.g., startupListProvider)
// Update the provider to fetch data using DatabaseHelper
final startupListProvider = FutureProvider<List<Startup>>((ref) async {
  // Fetch data from the SQLite database via DatabaseHelper
  return DatabaseHelper().getAllStartups();
});
