// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:surplus/views/add_post/add_screen.dart';

import 'package:surplus/views/home/home_screen.dart';
import 'package:surplus/views/chat/message_screen.dart';
import 'package:surplus/views/profile/profile_screen.dart';
import 'package:surplus/views/search/search_screen.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationState();
}

class _NavigationState extends State<NavigationPage> {
  int currentPageIndex = 0;

  final _pages = const [
    Home(),
    Search(),
    Add(),
    MessageScreen(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: Colors.amber[800],
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add),
            icon: Icon(Icons.add_box_outlined),
            label: 'Add',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.comment),
            icon: Icon(Icons.comment_outlined),
            label: 'Message',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_2),
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: _pages.elementAt(currentPageIndex),
    );
  }
}
