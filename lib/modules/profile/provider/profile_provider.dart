import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:start_invest/models/investor_model.dart';
import 'package:start_invest/utils/database_helper.dart';

// Provider to fetch the currently logged-in investor's profile (using first for demo)
final currentInvestorProvider = FutureProvider<InvestorModel?>((ref) async {
  return DatabaseHelper().getFirstInvestor();
});
