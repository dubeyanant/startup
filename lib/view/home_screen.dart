import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:start_invest/provider/user_type_provider.dart';

final isLoginProvider = StateProvider<bool>((ref) => false);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = ref.watch(isLoginProvider);
    final userType = ref.watch(userTypeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("VentureNexus")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(isLogin ? "Login" : "Sign Up"),
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  // Regex explanation:
                  // (?=.*[a-z]) - Assert position has a lowercase letter
                  // (?=.*[A-Z]) - Assert position has an uppercase letter
                  // (?=.*\\d) - Assert position has a digit
                  // (?=.*[!@#$%^&*(),.?":{}|<>]) - Assert position has a special character
                  if (!RegExp(
                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
                  ).hasMatch(value)) {
                    return 'Password must contain lowercase, uppercase, number, and special symbol';
                  }
                  return null;
                },
              ),
              if (!isLogin)
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    // Check if passwords match
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: UserType.startup.name,
                        groupValue: userType.name,
                        onChanged: (value) {
                          ref.read(userTypeProvider.notifier).state = UserType
                              .values
                              .byName(value!);
                        },
                      ),
                      Text(UserType.startup.name),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: UserType.investor.name,
                        groupValue: userType.name,
                        onChanged: (value) {
                          ref.read(userTypeProvider.notifier).state = UserType
                              .values
                              .byName(value!);
                        },
                      ),
                      Text(UserType.investor.name),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isLogin ? 'Logging In...' : 'Signing Up...',
                        ),
                      ),
                    );
                    // TODO: Implement actual login/signup logic here
                  }
                },
                child: Text(isLogin ? "Login" : "Sign Up"),
              ),
              GestureDetector(
                onTap: () {
                  // Clear form errors when switching modes
                  _formKey.currentState?.reset();
                  _passwordController.clear();
                  _confirmPasswordController.clear();
                  ref.read(isLoginProvider.notifier).state = !isLogin;
                },
                child: Text(
                  isLogin
                      ? "Click here to create an account"
                      : "Click here to log in if you already have an account",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
