import 'package:flutter/material.dart';

import 'package:start_invest/modules/home/widgets/info_pill.dart';

class InvestorProfileCard extends StatelessWidget {
  const InvestorProfileCard({super.key, this.isFromProfile = false});

  final bool isFromProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ),
              Positioned(
                top: 30,
                left: 20,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.purple[50],
                    radius: 30,
                    child: Text(
                      "Al",
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  'Alex Taylor',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Managing Partner at Horizon Ventures",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 12),
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
                          "San Francisco, CA",
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
                          "₹25Lk-₹50Lk",
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
                if (isFromProfile) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.mail_outline, color: Colors.grey, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        "alex@greentech.com",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  "Bio",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Early stage investor with a focus on tech startups. Passionate about helping entrepreneurs succeed and building innovative products.",
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.2,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Investment Focus",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    InfoPill(
                      info: "SaaS",
                      color: Colors.blue,
                      backgroundColor: Colors.blue[50]!,
                    ),
                    InfoPill(
                      info: "FinTech",
                      color: Colors.blue,
                      backgroundColor: Colors.blue[50]!,
                    ),
                    InfoPill(
                      info: "AI",
                      color: Colors.blue,
                      backgroundColor: Colors.blue[50]!,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Past Investments",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    InfoPill(
                      info: "Stripe",
                      color: Colors.grey[800]!,
                      backgroundColor: Colors.grey[200]!,
                    ),
                    InfoPill(
                      info: "Notion",
                      color: Colors.grey[800]!,
                      backgroundColor: Colors.grey[200]!,
                    ),
                    InfoPill(
                      info: "Figma",
                      color: Colors.grey[800]!,
                      backgroundColor: Colors.grey[200]!,
                    ),
                  ],
                ),
                if (!isFromProfile) ...[
                  const SizedBox(height: 16),
                  Text(
                    "Active Since",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Almost 3 years ago",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.2,
                      color: Colors.grey[800],
                    ),
                  ),

                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
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
                            "Contact Investor",
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
