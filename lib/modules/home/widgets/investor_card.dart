import 'package:flutter/material.dart';

import 'package:start_invest/models/investor_model.dart';
import 'package:start_invest/modules/home/screen/investor_detail_screen.dart';
import 'package:start_invest/modules/home/widgets/info_pill.dart';
import 'package:start_invest/utils/currency_conversion.dart';

class InvestorCard extends StatelessWidget {
  const InvestorCard(this.investor, {super.key});

  final InvestorModel investor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvestorDetailScreen(investor),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16),
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
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              leading: CircleAvatar(
                backgroundColor: Colors.purple[50],
                child: Text(
                  "${investor.name[0].toUpperCase()}${investor.name[1]}",
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              title: Text(
                investor.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(investor.tagline),
            ),
            Text(investor.bio),
            const SizedBox(height: 8),
            Row(
              children:
                  investor.investmentFocus.map((focus) {
                    return InfoPill(
                      info: focus,
                      color: Colors.blue,
                      backgroundColor: Colors.blue[50]!,
                    );
                  }).toList(),
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
                      investor.location,
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
                      Icons.trending_up_outlined,
                      color: Colors.grey,
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      "${CurrencyConversion.formatCurrency(investor.minInvestment)}-${CurrencyConversion.formatCurrency(investor.maxInvestment)}",
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
          ],
        ),
      ),
    );
  }
}
