import 'package:flutter/material.dart';

// The application starts here.
// runApp() places our root widget on the screen.
void main() {
  runApp(const FooderlichApp());
}

// This is the root of the application.
// MaterialApp provides Flutter's Material Design widgets and app-level theme.
class FooderlichApp extends StatelessWidget {
  const FooderlichApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The title is used by the operating system and accessibility tools.
      title: 'Fooderlich',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // The screenshot uses a dark application bar and bottom navigation bar.
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF212121),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        // This controls the color of the selected item in the bottom bar.
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF2D2D2D),
          selectedItemColor: Colors.green,
          unselectedItemColor: Color(0xFFBDBDBD),
          type: BottomNavigationBarType.fixed,
        ),
      ),
      home: const FooderlichHomePage(),
    );
  }
}

// StatefulWidget is used because the selected bottom-navigation item changes.
// When the user taps another item, setState() rebuilds this widget.
class FooderlichHomePage extends StatefulWidget {
  const FooderlichHomePage({super.key});

  @override
  State<FooderlichHomePage> createState() => _FooderlichHomePageState();
}

class _FooderlichHomePageState extends State<FooderlichHomePage> {
  // 0 = Card, 1 = Card2, 2 = Card3.
  // This value tells BottomNavigationBar which item is currently selected.
  int _selectedIndex = 0;

  // Each page represents one screen shown in the screenshot.
  // Keeping the pages in a list makes changing the selected screen simple.
  static const List<Widget> _pages = [
    ColorCardPage(color: Colors.red),
    ColorCardPage(color: Colors.blue),
    ColorCardPage(color: Color(0xFFFFC107)),
  ];

  // These labels appear underneath the navigation icons.
  static const List<String> _labels = [
    'Card',
    'Card2',
    'Card3',
  ];

  // Called whenever the user taps a navigation item.
  void _selectPage(int index) {
    setState(() {
      // Updating _selectedIndex causes build() to run again.
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold provides the standard Material page structure:
      // AppBar at the top, body in the middle, navigation at the bottom.
      appBar: AppBar(
        title: const Text('Fooderlich'),
      ),

      // Display the page that matches the selected navigation item.
      body: _pages[_selectedIndex],

      // Three navigation items reproduce the bottom bar in the reference image.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Card2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Card3',
          ),
        ],
      ),
    );
  }
}

// A reusable page that fills the available body area with one color.
// The same widget is used for all three tabs; only the color changes.
class ColorCardPage extends StatelessWidget {
  const ColorCardPage({required this.color, super.key});

  // final means this value cannot be changed after the widget is created.
  final Color color;

  @override
  Widget build(BuildContext context) {
    // SizedBox.expand makes the colored area fill the body available from
    // Scaffold. No fixed width/height is needed, so it works on different screens.
    return SizedBox.expand(
      child: ColoredBox(
        color: color,
        child: const SizedBox.expand(),
      ),
    );
  }
}
