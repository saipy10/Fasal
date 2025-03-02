import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/chatbot_page.dart';
import 'pages/price_prediction_page.dart';
import 'pages/govt_scheme_page.dart';
import 'widgets/bottom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fasal',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: _themeMode,
      home: MainScreen(toggleTheme: _toggleTheme, themeMode: _themeMode),
    );
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  const MainScreen({
    super.key,
    required this.toggleTheme,
    required this.themeMode,
  });

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // In MainScreen class
  final List<Widget> _pages = [
    HomePage(),
    ChatbotPage(), // No themeMode parameter needed
    PricePredictionPage(),
    GovtSchemePage(),
  ];

  final List<String> _titles = [
    "Fasal",
    "Saathi",
    "Prediction",
    "Govt Schemes",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50, // Reduced height
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png', // Replace with your actual asset path
              height: 43, // Adjust size as needed
            ),
            const SizedBox(width: 8), // Space between logo and text
            Text(
              _titles[_selectedIndex],
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w600,
                color:
                    Theme.of(
                      context,
                    ).textTheme.bodyLarge!.color, // Adaptive text color
              ),
            ),
          ],
        ),
        actions: [
          // Dark mode toggle button
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: widget.toggleTheme,
          ),
          SizedBox(width: 2),
          // Profile avatar
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                // Handle profile section click
              },
              child: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.green[300], // Adjust color as needed
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
