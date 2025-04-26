import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:start_invest/modules/home/widgets/loans/loans_widget.dart';
import 'package:start_invest/modules/home/widgets/overview/overview_widget.dart';
import 'package:start_invest/modules/home/widgets/profile/profile_widget.dart';
import 'package:start_invest/modules/home/widgets/schemes/schemes_widget.dart';
import 'package:start_invest/modules/login/provider/user_type_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userType = ref.watch(userTypeProvider);

    final List<Widget> widgetOptions = <Widget>[
      OverviewWidget(),
      if (userType == UserType.startup) SchemesWidget(),
      if (userType == UserType.startup) LoansWidget(),
      ProfileWidget(),
    ];

    // Update selectedIndex if it's out of bounds after a user type change
    if (_selectedIndex >= widgetOptions.length) {
      _selectedIndex = 0;
    }

    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    // Create navigation items based on user type
    final navigationItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: 'Overview',
      ),
      if (userType == UserType.startup)
        const BottomNavigationBarItem(
          icon: Icon(Icons.drive_file_rename_outline),
          label: 'Schemes',
        ),
      if (userType == UserType.startup)
        const BottomNavigationBarItem(
          icon: Icon(Icons.paypal_outlined),
          label: 'Loans',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        label: 'Profile',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("VentureNexus")),
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: navigationItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: onItemTapped,
      ),
    );
  }
}
