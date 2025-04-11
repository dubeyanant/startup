import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoginProvider = StateProvider<bool>((ref) => false);

// Provider to store the email of the currently logged-in user
final loggedInUserEmailProvider = StateProvider<String?>((ref) => null);
