import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:start_invest/models/startup_model.dart';
import 'package:start_invest/utils/database_helper.dart';

final startupListProvider = FutureProvider<List<Startup>>((ref) async {
  return DatabaseHelper().getAllStartups();
});
