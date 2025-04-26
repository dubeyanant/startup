import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:start_invest/modules/home/provider/investor_data_provider.dart';
import 'package:start_invest/modules/home/provider/startup_data_provider.dart';
import 'package:start_invest/modules/home/widgets/overview/investor_card.dart';
import 'package:start_invest/modules/home/widgets/overview/startup_card.dart';
import 'package:start_invest/modules/login/provider/user_type_provider.dart';

class OverviewWidget extends ConsumerWidget {
  const OverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userType = ref.watch(userTypeProvider);

    // Determine the title based on user type
    final String title =
        userType == UserType.investor
            ? 'Find startups to invest in'
            : 'Find investors to fund your startup';

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16), // Add some spacing
            Expanded(
              // Make the list take available space
              child:
                  userType == UserType.investor
                      ? _buildStartupList(ref)
                      : _buildInvestorList(ref),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build the startup list
  Widget _buildStartupList(WidgetRef ref) {
    final startupListAsync = ref.watch(startupListProvider);
    return startupListAsync.when(
      data: (startups) {
        if (startups.isEmpty) {
          return const Center(child: Text("No startups found!"));
        }
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          itemCount: startups.length,
          itemBuilder: (context, index) => StartupCard(startups[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text("Error: $error")),
    );
  }

  // Helper widget to build the investor list
  Widget _buildInvestorList(WidgetRef ref) {
    final investorListAsync = ref.watch(investorListProvider);
    return investorListAsync.when(
      data: (investors) {
        if (investors.isEmpty) {
          return const Center(child: Text("No investors found!"));
        }
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          itemCount: investors.length,
          // Pass the investor object to the InvestorCard
          itemBuilder: (context, index) => InvestorCard(investors[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text("Error: $error")),
    );
  }
}
