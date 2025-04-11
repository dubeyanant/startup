import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:start_invest/modules/home/provider/startup_data_provider.dart';
import 'package:start_invest/modules/home/widgets/startup_card.dart';

class OverviewWidget extends ConsumerWidget {
  const OverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startupListAsync = ref.watch(startupListProvider);

    return Scaffold(
      body: startupListAsync.when(
        data: (startups) {
          if (startups.isEmpty) {
            return const Center(child: Text("No startups found!"));
          }
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Find startups to invest in',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  ListView.builder(
                    itemCount: startups.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder:
                        (context, index) => StartupCard(startups[index]),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) =>
                Center(child: Text("Error loading data: $error")),
      ),
    );
  }
}
