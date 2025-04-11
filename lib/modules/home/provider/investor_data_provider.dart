import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:start_invest/models/investor_model.dart';
import 'package:start_invest/utils/database_helper.dart';

// Provider to fetch the list of investors from the database
final investorListProvider = FutureProvider<List<InvestorModel>>((ref) async {
  return DatabaseHelper().getAllInvestors();
});
