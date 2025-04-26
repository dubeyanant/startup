import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:start_invest/models/bank_model.dart';
import 'package:start_invest/modules/home/widgets/loans/steps_widget.dart';

class LoansWidget extends StatelessWidget {
  const LoansWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Text(
            "Find loans to apply for",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const HorizontalCards(),
          Expanded(child: Steps()),
        ],
      ),
    );
  }
}

class HorizontalCards extends StatelessWidget {
  const HorizontalCards({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Bank> banks = [
      Bank(
        name: "Bank of Maharastra",
        logo: "assets/svgs/bom.svg",
        interestRate: "5.0%",
      ),
      Bank(
        name: "AU Small Finance Bank",
        logo: "assets/svgs/ausfb.svg",
        interestRate: "5.2%",
      ),
      Bank(name: "Axis bank", logo: "assets/svgs/ab.svg", interestRate: "5.3%"),
      Bank(
        name: "Bandhan Bank",
        logo: "assets/svgs/bb.svg",
        interestRate: "5.8%",
      ),
      Bank(
        name: "Bank of Baroda",
        logo: "assets/svgs/bob.svg",
        interestRate: "6.4%",
      ),
      Bank(
        name: "Bank of India",
        logo: "assets/svgs/boi.svg",
        interestRate: "7.2%",
      ),
      Bank(
        name: "Canara Bank",
        logo: "assets/svgs/cb.svg",
        interestRate: "9.0%",
      ),
      Bank(
        name: "Dhanlaxmi Bank",
        logo: "assets/svgs/db.svg",
        interestRate: "9.8%",
      ),
    ];

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: banks.length,
        itemBuilder: (context, index) {
          final bank = banks[index];
          return Container(
            width: 160, // Width of each card
            margin: const EdgeInsets.only(right: 16, bottom: 16, left: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(bank.logo, fit: BoxFit.contain, height: 60),
                  const SizedBox(height: 8),
                  Text(
                    bank.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rate: ${bank.interestRate}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
