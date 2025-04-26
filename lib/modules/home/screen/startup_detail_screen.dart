import 'package:flutter/material.dart';

import 'package:start_invest/modules/home/widgets/profile/startup_profile_card.dart';
import 'package:start_invest/models/startup_model.dart';

class StartupDetailScreen extends StatelessWidget {
  const StartupDetailScreen(this.startup, {super.key});

  final Startup startup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Startup Details')),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: StartupProfileCard(startup: startup),
        ),
      ),
    );
  }
}
