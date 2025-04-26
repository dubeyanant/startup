import 'package:flutter/material.dart';

import 'package:start_invest/models/scheme_model.dart';
import 'package:start_invest/modules/home/widgets/info_pill.dart';
import 'package:url_launcher/url_launcher.dart';

class SchemeCard extends StatelessWidget {
  const SchemeCard(this.scheme, {super.key});

  final Scheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                scheme.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                scheme.agencyName,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            scheme.description,
            style: TextStyle(
              fontSize: 14,
              height: 1.2,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              scheme.isEligible
                  ? InfoPill(
                    info: "Eligible",
                    color: Colors.green,
                    backgroundColor: Colors.green[50]!,
                  )
                  : InfoPill(
                    info: "Ineligible",
                    color: Colors.red,
                    backgroundColor: Colors.red[50]!,
                  ),
              if (scheme.isEligible)
                GestureDetector(
                  onTap: () {
                    final Uri url = Uri.parse(scheme.link);
                    launchUrl(url, mode: LaunchMode.externalApplication);
                  },
                  child: Text(
                    "Click here to apply",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
