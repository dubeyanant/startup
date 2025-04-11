import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:start_invest/modules/login/provider/login_provider.dart';
import 'package:start_invest/modules/login/provider/user_type_provider.dart';
import 'package:start_invest/modules/home/screen/home_screen.dart';
import 'package:start_invest/modules/login/screen/investor_details_screen.dart';
import 'package:start_invest/modules/login/screen/startup_details_screen.dart';
import 'package:start_invest/utils/database_helper.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DatabaseHelper();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
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
              GestureDetector(
                onTap: () {
                  if (kDebugMode) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  }
                },
                child: Text(isLogin ? "Login" : "Sign Up"),
              ),
              TextFormField(
                controller: _emailController,
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    final isLogin = ref.read(isLoginProvider);
                    final userType = ref.read(userTypeProvider);

                    if (isLogin) {
                      if (userType == UserType.investor) {
                        final investor = await _dbHelper.verifyInvestorLogin(
                          email,
                          password,
                        );
                        if (investor != null) {
                          ref.read(loggedInUserEmailProvider.notifier).state =
                              email;
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          }
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid email or password'),
                              ),
                            );
                          }
                        }
                      } else {
                        final startup = await _dbHelper.verifyStartupLogin(
                          email,
                          password,
                        );
                        if (startup != null) {
                          ref.read(loggedInUserEmailProvider.notifier).state =
                              email;
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          }
                        } else {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid email or password'),
                              ),
                            );
                          }
                        }
                      }
                    } else {
                      if (userType == UserType.investor) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => InvestorDetailsScreen(
                                  email: email,
                                  password: password,
                                ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => StartupDetailsScreen(
                                  email: email,
                                  password: password,
                                ),
                          ),
                        );
                      }
                    }
                  }
                },
                child: Text(isLogin ? "Login" : "Sign Up"),
              ),
              GestureDetector(
                onTap: () {
                  // Clear form errors when switching modes
                  _formKey.currentState?.reset();
                  _emailController.clear();
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
