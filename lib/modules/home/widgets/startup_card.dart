import 'package:flutter/material.dart';

import 'package:start_invest/models/startup_model.dart';
import 'package:start_invest/modules/home/widgets/info_pill.dart';

class StartupCard extends StatelessWidget {
  const StartupCard(this.startup, {super.key});

  final StartupModel startup;

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
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "${startup.name[0].toUpperCase()}${startup.name[1]}",
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    startup.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    startup.tagline,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
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
          const SizedBox(height: 24),
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
          const SizedBox(height: 12),
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
              Text(
                startup.date,
                style: TextStyle(fontSize: 13, color: Colors.grey, height: 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
