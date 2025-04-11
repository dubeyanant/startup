import 'package:flutter/material.dart';

import 'package:start_invest/modules/home/widgets/investor_profile_card.dart';
import 'package:start_invest/modules/login/screen/login_screen.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              InvestorProfileCard(isFromProfile: true),
              const SizedBox(height: 16),
              _BottomButton(
                text: "Sign Out",
                icon: Icons.output,
                color: Colors.white,
                textColor: Colors.red,
                onTap: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                border: Border.all(color: Colors.red, width: 0.4),
              ),
              const SizedBox(height: 16),
              _BottomButton(
                text: "Delete Account",
                icon: Icons.output,
                color: Colors.red,
                textColor: Colors.white,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    this.onTap,
    required this.text,
    required this.icon,
    required this.color,
    required this.textColor,
    this.border,
  });

  final void Function()? onTap;
  final String text;
  final IconData icon;
  final Color color;
  final Color textColor;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: border,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 15),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
