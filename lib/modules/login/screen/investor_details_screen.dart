import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:start_invest/modules/home/screen/home_screen.dart';

import 'package:start_invest/utils/database_helper.dart'; // Use correct DatabaseHelper
import 'package:start_invest/modules/login/provider/login_provider.dart'; // Import login provider

// TODO: Import database helper

class InvestorDetailsScreen extends ConsumerStatefulWidget {
  final String email;
  final String password; // Remember to hash this before saving!

  const InvestorDetailsScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<InvestorDetailsScreen> createState() =>
      _InvestorDetailsScreenState();
}

class _InvestorDetailsScreenState extends ConsumerState<InvestorDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper(); // Correct instantiation

  // Controllers for the form fields
  final _nameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _locationController = TextEditingController();
  final _minInvestmentController = TextEditingController();
  final _maxInvestmentController = TextEditingController();
  final _bioController = TextEditingController();
  final _investmentFocusController =
      TextEditingController(); // Simple comma-separated for now
  final _pastInvestmentsController =
      TextEditingController(); // Simple comma-separated for now
  final _activeSinceController =
      TextEditingController(); // Could use a DatePicker later

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    _locationController.dispose();
    _minInvestmentController.dispose();
    _maxInvestmentController.dispose();
    _bioController.dispose();
    _investmentFocusController.dispose();
    _pastInvestmentsController.dispose();
    _activeSinceController.dispose();
    super.dispose();
  }

  Future<void> _submitInvestorDetails() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with saving data
      final name = _nameController.text;
      final tagline = _taglineController.text;
      final location = _locationController.text;
      final minInvestment = int.tryParse(_minInvestmentController.text) ?? 0;
      final maxInvestment = int.tryParse(_maxInvestmentController.text) ?? 0;
      final bio = _bioController.text;
      // Split comma-separated strings into lists
      final investmentFocus =
          _investmentFocusController.text
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
      final pastInvestments =
          _pastInvestmentsController.text
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
      final activeSince =
          _activeSinceController.text; // Consider parsing as DateTime if needed

      // Prepare data map for insertion
      final investorData = {
        'email': widget.email,
        'password': widget.password, // Pass plain password
        'name': name,
        'tagline': tagline,
        'location': location,
        'minInvestment': minInvestment,
        'maxInvestment': maxInvestment,
        'bio': bio,
        'investmentFocus':
            investmentFocus, // Will be JSON encoded by insertNewInvestor
        'pastInvestments':
            pastInvestments, // Will be JSON encoded by insertNewInvestor
        'activeSince': activeSince,
      };

      try {
        // Use the new insert method
        final id = await _dbHelper.insertNewInvestor(investorData);
        print('Investor inserted with ID: $id');

        // Navigate to Home Screen after successful insertion
        if (mounted) {
          // Set the logged-in user email
          ref.read(loggedInUserEmailProvider.notifier).state = widget.email;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sign up successful!')));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (e) {
        print('Error inserting investor: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving details: ${e.toString()}')),
          );
        }
        // Handle error (e.g., show error message)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Investor Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            // Use ListView for scrollable content
            children: [
              Text('Email: ${widget.email}'), // Display email
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name / Company Name',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a name'
                            : null,
              ),
              TextFormField(
                controller: _taglineController,
                decoration: const InputDecoration(labelText: 'Tagline'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a tagline'
                            : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (e.g., City, Country)',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a location'
                            : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _minInvestmentController,
                      decoration: const InputDecoration(
                        labelText: 'Min Investment (\$)',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (int.tryParse(value) == null)
                          return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _maxInvestmentController,
                      decoration: const InputDecoration(
                        labelText: 'Max Investment (\$)',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final maxVal = int.tryParse(value);
                        if (maxVal == null) return 'Invalid number';
                        final minVal = int.tryParse(
                          _minInvestmentController.text,
                        );
                        if (minVal != null && maxVal < minVal) {
                          return 'Max must be >= Min';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: 'Bio / Investment Thesis',
                ),
                maxLines: 3,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a bio'
                            : null,
              ),
              TextFormField(
                controller: _investmentFocusController,
                decoration: const InputDecoration(
                  labelText:
                      'Investment Focus (comma-separated sectors/stages)',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please list focus areas'
                            : null,
              ),
              TextFormField(
                controller: _pastInvestmentsController,
                decoration: const InputDecoration(
                  labelText: 'Past Investments (comma-separated company names)',
                ),
                // Optional field, no validator needed unless required
              ),
              TextFormField(
                controller: _activeSinceController,
                decoration: const InputDecoration(
                  labelText: 'Active Since (e.g., YYYY or MM/YYYY)',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter when you started'
                            : null,
                // TODO: Add date validation or use a DatePicker
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitInvestorDetails,
                child: const Text('Complete Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
