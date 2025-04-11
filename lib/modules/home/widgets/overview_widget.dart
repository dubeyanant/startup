import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:start_invest/models/startup_model.dart';
import 'package:start_invest/modules/home/widgets/startup_card.dart';

class OverviewWidget extends StatelessWidget {
  const OverviewWidget({super.key});

  Future<List<StartupModel>> loadStartupData() async {
    final String jsonString = await rootBundle.loadString(
      'assets/startup_data.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => StartupModel.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<StartupModel>>(
        future: loadStartupData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No startups found"));
          }

          final startups = snapshot.data!;

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
      ),
    );
  }
}
