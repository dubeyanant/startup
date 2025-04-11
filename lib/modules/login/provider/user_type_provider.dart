import 'package:flutter_riverpod/flutter_riverpod.dart';

final userTypeProvider = StateProvider<UserType>((ref) => UserType.startup);

enum UserType { startup, investor }
