import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:start_invest/modules/home/widgets/investor_profile_card.dart';
import 'package:start_invest/modules/login/provider/login_provider.dart';
import 'package:start_invest/modules/login/screen/login_screen.dart';
import 'package:start_invest/modules/profile/provider/profile_provider.dart';
import 'package:start_invest/utils/database_helper.dart';
import 'package:start_invest/modules/home/provider/investor_data_provider.dart';

class ProfileWidget extends ConsumerWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final investorAsync = ref.watch(currentInvestorProvider);
    final dbHelper = DatabaseHelper();

    return Scaffold(
      body: investorAsync.when(
        data: (investor) {
          if (investor == null) {
            return const Center(child: Text('Investor profile not found.'));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  InvestorProfileCard(isFromProfile: true, investor: investor),
                  const SizedBox(height: 16),
                  _BottomButton(
                    text: "Sign Out",
                    icon: Icons.output,
                    color: Colors.white,
                    textColor: Colors.red,
                    onTap: () {
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
                    icon: Icons.delete_outline,
                    color: Colors.red,
                    textColor: Colors.white,
                    onTap: () async {
                      final loggedInEmail = ref.read(loggedInUserEmailProvider);

                      if (loggedInEmail == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error: Not logged in.'),
                          ),
                        );
                        return;
                      }

                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Delete Account?'),
                            content: const Text(
                              'Are you sure you want to permanently delete your account?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed == true) {
                        try {
                          final rowsDeleted = await dbHelper
                              .deleteInvestorByEmail(loggedInEmail);

                          if (rowsDeleted > 0) {
                            ref.read(loggedInUserEmailProvider.notifier).state =
                                null;
                            ref.invalidate(investorListProvider);
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Account deleted successfully.',
                                  ),
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Error: Account not found or could not be deleted.',
                                  ),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          print("Error during account deletion: $e");
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error deleting account: ${e.toString()}',
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) =>
                Center(child: Text('Error loading profile: $error')),
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
