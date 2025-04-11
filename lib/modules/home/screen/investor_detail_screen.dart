import 'package:flutter/material.dart';

import 'package:start_invest/models/investor_model.dart';
import 'package:start_invest/modules/home/widgets/investor_profile_card.dart';

class InvestorDetailScreen extends StatelessWidget {
  const InvestorDetailScreen(this.investor, {super.key});

  final InvestorModel investor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Startup Details')),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: InvestorProfileCard(investor: investor),
        ),
      ),
    );
  }
}
