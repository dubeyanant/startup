import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:start_invest/models/investor_model.dart';
import 'package:start_invest/utils/database_helper.dart';
import 'package:start_invest/modules/login/provider/login_provider.dart';

// Provider to fetch the profile data for the currently logged-in investor
final currentInvestorProvider = FutureProvider.autoDispose<InvestorModel?>((
  ref,
) async {
  final dbHelper = DatabaseHelper();
  // Watch the logged-in user email provider
  final loggedInEmail = ref.watch(loggedInUserEmailProvider);

  if (loggedInEmail != null) {
    // If an email exists, fetch the investor by email
    return await dbHelper.fetchInvestorByEmail(loggedInEmail);
  } else {
    // If no email (not logged in), return null
    // You could also fetch a default profile or handle this state differently
    // For now, just returning null to match the previous behavior
    // when getFirstInvestor returned null.
    // Alternatively, fetch the first investor as before if you want a fallback:
    // return await dbHelper.getFirstInvestor();
    return null;
  }
});
