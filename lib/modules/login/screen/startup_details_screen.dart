import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:start_invest/utils/shared_prefs_helper.dart';

import 'package:start_invest/models/founder_model.dart';
import 'package:start_invest/models/startup_model.dart';
import 'package:start_invest/modules/home/screen/home_screen.dart';
import 'package:start_invest/modules/login/provider/login_provider.dart';
import 'package:start_invest/modules/login/provider/user_type_provider.dart';
import 'package:start_invest/utils/database_helper.dart';

class StartupDetailsScreen extends ConsumerStatefulWidget {
  final String email;
  final String password;

  const StartupDetailsScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<StartupDetailsScreen> createState() =>
      _StartupDetailsScreenState();
}

class _StartupDetailsScreenState extends ConsumerState<StartupDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _founderFormKey =
      GlobalKey<FormState>(); // Key for founder input validation
  final _dbHelper = DatabaseHelper();

  // Controllers for Startup details
  late TextEditingController _nameController;
  late TextEditingController _taglineController;
  late TextEditingController _descriptionController;
  late TextEditingController _sectorController;
  late TextEditingController _fundingController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;
  late TextEditingController _websiteController;
  late TextEditingController _fundingGoalController;

  // Controllers for adding new founders
  late TextEditingController _founderNameController;
  late TextEditingController _founderEmailController;

  // State for managing founders list
  List<Founder> _founders = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _taglineController = TextEditingController();
    _descriptionController = TextEditingController();
    _sectorController = TextEditingController();
    _fundingController = TextEditingController();
    _locationController = TextEditingController();
    _dateController = TextEditingController();
    _websiteController = TextEditingController();
    _fundingGoalController = TextEditingController();

    _founderNameController = TextEditingController();
    _founderEmailController = TextEditingController();

    // Initialize with the primary founder (cannot be removed)
    // We need a name for the primary founder, let's add a field for it.
    // For now, let's pre-populate it and make it required.
    // _founders.add(Founder(name: "Primary Founder Name", email: widget.email));
    // We will require the primary founder name input separately.
    _founders = [
      Founder(name: "", email: widget.email),
    ]; // Placeholder, name set via dedicated field
  }

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    _descriptionController.dispose();
    _sectorController.dispose();
    _fundingController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _websiteController.dispose();
    _fundingGoalController.dispose();
    _founderNameController.dispose();
    _founderEmailController.dispose();
    super.dispose();
  }

  void _addFounder() {
    if (!_founderFormKey.currentState!.validate()) {
      return;
    }

    final newName = _founderNameController.text;
    final newEmail = _founderEmailController.text;

    // Check if email already exists
    if (_founders.any((founder) => founder.email == newEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Founder with this email already added.')),
      );
      return;
    }

    setState(() {
      _founders.add(Founder(name: newName, email: newEmail));
      _founderNameController.clear();
      _founderEmailController.clear();
    });
  }

  void _removeFounder(String emailToRemove) {
    // Prevent removing the primary founder
    if (emailToRemove == widget.email) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot remove the primary founder.')),
      );
      return;
    }
    setState(() {
      _founders.removeWhere((founder) => founder.email == emailToRemove);
    });
  }

  Future<void> _signUpStartup() async {
    if (!_formKey.currentState!.validate()) {
      return; // Don't proceed if startup details form is invalid
    }

    // Ensure the primary founder's name has been entered
    if (_founders.first.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the primary founder\'s name.'),
        ),
      );
      return;
    }

    // Ensure founders list isn't empty (shouldn't be, due to primary)
    if (_founders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one founder is required.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create the startup object using the list from state
      final startup = Startup(
        name: _nameController.text,
        tagline: _taglineController.text,
        description: _descriptionController.text,
        sector: _sectorController.text,
        funding: _fundingController.text,
        location: _locationController.text,
        date: _dateController.text,
        website: _websiteController.text,
        fundingGoal: int.tryParse(_fundingGoalController.text) ?? 0,
        founders: _founders, // Use the list from state
      );

      // Insert the startup into the database
      await _dbHelper.insertNewStartup(startup, widget.password);

      await SharedPrefsHelper.instance.saveLoginInfo(
        widget.email,
        UserType.startup,
      );

      // Update logged-in state in Riverpod
      ref.read(loggedInUserEmailProvider.notifier).state = widget.email;
      ref.read(userTypeProvider.notifier).state = UserType.startup;

      // Navigate to home screen on success
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Startup account created successfully!'),
          ),
        );
      }
    } catch (e) {
      // Handle errors (e.g., email already exists)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating startup account: ${e.toString()}'),
          ),
        );
      }
      print("Startup signup error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Startup Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            // Use ListView for scrollable content
            children: [
              Text(
                "Creating account for: ${widget.email}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              // --- Startup Details ---
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Startup Name'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter startup name'
                            : null,
              ),
              TextFormField(
                controller: _taglineController,
                decoration: const InputDecoration(labelText: 'Tagline'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Enter tagline' : null,
              ),
              // --- Primary Founder Name ---
              TextFormField(
                initialValue: _founders.first.name, // Can be empty initially
                decoration: InputDecoration(
                  labelText: 'Your Name (Primary Founder for ${widget.email})',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter primary founder name'
                            : null,
                onChanged: (value) {
                  // Update the name in the state list directly
                  setState(() {
                    _founders[0] = Founder(name: value, email: widget.email);
                  });
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter description'
                            : null,
              ),
              TextFormField(
                controller: _sectorController,
                decoration: const InputDecoration(
                  labelText: 'Sector (e.g., HealthTech)',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Enter sector' : null,
              ),
              TextFormField(
                controller: _fundingController,
                decoration: const InputDecoration(
                  labelText: 'Funding Stage (e.g., Seed)',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter funding stage'
                            : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location (e.g., City, ST)',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter location'
                            : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date Founded (e.g., 1 year ago)',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter founding date approximation'
                            : null,
              ),
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: 'Website (Optional)',
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.isAbsolute) {
                      return 'Enter a valid URL (e.g., https://example.com)';
                    }
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fundingGoalController,
                decoration: const InputDecoration(
                  labelText: 'Funding Goal (INR)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter funding goal';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // --- Founders Section ---
              Text('Founders', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              // Display added founders
              ListView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling within ListView
                itemCount: _founders.length,
                itemBuilder: (context, index) {
                  final founder = _founders[index];
                  final bool isPrimary = founder.email == widget.email;
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        founder.name.isNotEmpty ? founder.name[0] : '?',
                      ),
                    ),
                    title: Text(
                      founder.name.isNotEmpty
                          ? founder.name
                          : "(Primary Founder Name Needed)",
                    ),
                    subtitle: Text(founder.email),
                    trailing:
                        isPrimary
                            ? const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ) // Indicate primary
                            : IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),
                              onPressed: () => _removeFounder(founder.email),
                              tooltip: 'Remove Founder',
                            ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Form to add new founders
              Form(
                key: _founderFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Another Founder',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextFormField(
                      controller: _founderNameController,
                      decoration: const InputDecoration(
                        labelText: 'Founder Name',
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter founder name'
                                  : null,
                    ),
                    TextFormField(
                      controller: _founderEmailController,
                      decoration: const InputDecoration(
                        labelText: 'Founder Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter founder email';
                        }
                        if (!RegExp(
                          r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                        ).hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add, color: Colors.black),
                      label: Text(
                        'Add Founder',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: _addFounder,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 36),
                        backgroundColor: Theme.of(context).primaryColorLight,
                      ), // Make button wider
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // --- Final Submit Button ---
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: _isLoading ? null : _signUpStartup,
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 24, // Make spinner larger
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          'Complete Startup Sign Up',
                          style: TextStyle(
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
