import 'package:flutter/material.dart';

import 'package:start_invest/models/scheme_model.dart';
import 'package:start_invest/modules/home/widgets/schemes/scheme_card.dart';

class SchemesWidget extends StatelessWidget {
  SchemesWidget({super.key});

  final List<Scheme> schemes = [
    Scheme(
      name: "Startup Udaan",
      agencyName: "Ministry of Commerce and Industry",
      description:
          "Funding support and mentorship for early-stage startups focusing on innovation and employment generation.",
      isEligible: true,
      link: "https://startupindia.gov.in/udaan",
    ),
    Scheme(
      name: "TechBoost India",
      agencyName: "Department of Science and Technology",
      description:
          "Grants for tech startups working on AI, blockchain, and green energy solutions.",
      isEligible: false,
      link: "https://dst.gov.in/techboost",
    ),
    Scheme(
      name: "Women Entrepreneurs Program",
      agencyName: "Ministry of Women and Child Development",
      description:
          "Financial aid and incubation support exclusively for women-led startups.",
      isEligible: true,
      link: "https://wcd.nic.in/womenstartups",
    ),
    Scheme(
      name: "AgriNext Innovation Fund",
      agencyName: "Ministry of Agriculture & Farmers Welfare",
      description:
          "Seed funding for startups innovating in agriculture, farming technologies, and rural supply chains.",
      isEligible: true,
      link: "https://agrinnovateindia.co.in/agrinext",
    ),
    Scheme(
      name: "Green Energy Catalyst",
      agencyName: "Ministry of New and Renewable Energy",
      description:
          "Subsidies and tax benefits for startups in renewable energy, electric vehicles, and sustainable tech.",
      isEligible: false,
      link: "https://mnre.gov.in/greencatalyst",
    ),
    Scheme(
      name: "Digital Bharat Accelerator",
      agencyName: "Ministry of Electronics and Information Technology",
      description:
          "Support for startups building digital products that enhance rural internet penetration and e-governance.",
      isEligible: true,
      link: "https://meity.gov.in/digitalbharat",
    ),
    Scheme(
      name: "Healthcare Innovators Grant",
      agencyName: "Ministry of Health and Family Welfare",
      description:
          "Funding and clinical trial support for startups building medical devices, diagnostics, and telemedicine platforms.",
      isEligible: true,
      link: "https://mohfw.gov.in/healthinnovators",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Find schemes to apply for",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                itemCount: schemes.length,
                itemBuilder: (context, index) {
                  return SchemeCard(schemes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
