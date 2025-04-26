import 'package:flutter/material.dart';

import 'package:start_invest/modules/home/widgets/loans/loans_widget.dart';
import 'package:start_invest/modules/home/widgets/overview/overview_widget.dart';
import 'package:start_invest/modules/home/widgets/profile/profile_widget.dart';
import 'package:start_invest/modules/home/widgets/schemes/schemes_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    OverviewWidget(),
    SchemesWidget(),
    LoansWidget(),
    ProfileWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VentureNexus")),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_file_rename_outline),
            label: 'Schemes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.paypal_outlined),
            label: 'Loans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
