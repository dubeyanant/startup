import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:start_invest/models/startup_model.dart';
import 'package:start_invest/modules/home/widgets/info_pill.dart';
import 'package:start_invest/utils/currency_conversion.dart';

class StartupProfileCard extends StatelessWidget {
  const StartupProfileCard({super.key, required this.startup});

  final Startup startup;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StartupDetailCard(startup: startup),
        const SizedBox(height: 16),
        const Text(
          'Founders',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          itemCount: startup.founders.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final founder = startup.founders[index];
            return Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(40),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purple[50],
                  child: Text(
                    "${founder.name[0].toUpperCase()}${founder.name[1]}",
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                title: Text(
                  founder.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(founder.email),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _StartupDetailCard extends StatelessWidget {
  const _StartupDetailCard({required this.startup});

  final Startup startup;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(40),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                "${startup.name[0].toUpperCase()}${startup.name[1]}",
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  startup.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  startup.tagline,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  spacing: 8,
                  children: [
                    InfoPill(
                      info: startup.sector,
                      color: Colors.green,
                      backgroundColor: Colors.green[50]!,
                    ),
                    InfoPill(
                      info: startup.funding,
                      color: Colors.blue,
                      backgroundColor: Colors.blue[50]!,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 15,
                        ),
                        Text(
                          startup.location,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.grey,
                          size: 15,
                        ),
                        Text(
                          "${CurrencyConversion.formatCurrency(startup.fundingGoal)} funding goal",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    final Uri url = Uri.parse(startup.website);
                    launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.data_usage_sharp,
                        color: Colors.blue,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        startup.website,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "About",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  startup.description,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.2,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Founded",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  startup.date,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.2,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final Uri params = Uri(
                      scheme: 'mailto',
                      path: startup.founders.first.email,
                    );
                    await launchUrl(params);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.message_outlined,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Contact Founder",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
