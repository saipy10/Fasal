import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy),
          label: 'Chat Desk',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: 'Price Prediction',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance),
          label: 'Govt. Schemes',
        ),
      ],
    );
  }
}
