
import 'package:flutter/material.dart';
import 'package:locumspherelimited/Allocation%20Screen/allocation_screen.dart';
import 'package:locumspherelimited/Home%20Screen/home_screen.dart';
//import 'package:locumspherelimited/Navbar/page2.dart';
import 'package:locumspherelimited/chat/all_chat.dart';
//import 'package:locumspherelimited/Navbar/page3.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int selectedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const [
          Dashboard(),
          AllocationsSccreen(),
          //Page2(),
          AllChat(),
        ][selectedPageIndex],
        bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: selectedPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedPageIndex = index;
            });
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Dashboard',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.calendar_month),
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Allocation',
            ),
            /*NavigationDestination(
              selectedIcon: Icon(Icons.group),
              icon: Icon(Icons.group_outlined),
              label: 'Employees',
            ),*/
            NavigationDestination(
              selectedIcon: Icon(Icons.chat),
              icon: Icon(Icons.chat_outlined),
              label: 'Chat',
            ),
            
          ],
        ),
      
    );
  }
}