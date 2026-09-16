import 'package:flutter/material.dart';

void main() {
  runApp(const Flutter101App());
}

class Flutter101App extends StatelessWidget {
  const Flutter101App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 101',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'Flutter Fundamentals',
    'Common Widgets',
    'Dart Basics',
  ];

  static const List<Widget> _pages = [
    FundamentalsPage(),
    CommonWidgetsPage(),
    DartBasicsPage(),
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
        title: Text(_titles[_selectedIndex]),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.flutter_dash),
            label: 'Flutter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets_outlined),
            label: 'Widgets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.code),
            label: 'Dart',
          ),
        ],
      ),
    );
  }
}

class FundamentalsPage extends StatelessWidget {
  const FundamentalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        InfoCard(
          title: 'What is Flutter?',
          icon: Icons.flutter_dash,
          description:
              'Flutter is an open-source framework for building beautiful, natively compiled, multi-platform applications from a single codebase. Flutter apps are powered by Dart.',
        ),
        SizedBox(height: 12),
        InfoCard(
          title: 'Widget-based UI',
          icon: Icons.account_tree_outlined,
          description:
              'A widget is a building block for the user interface. Widgets compose together to form a widget tree.',
        ),
        SizedBox(height: 12),
        InfoCard(
          title: 'Stateless vs Stateful',
          icon: Icons.sync,
          description:
              'StatelessWidget describes UI that does not change. StatefulWidget keeps mutable state in a separate State object and can rebuild after setState().',
        ),
        SizedBox(height: 12),
        InfoCard(
          title: 'Hot Reload',
          icon: Icons.flash_on,
          description:
              'Hot reload applies code and UI changes while preserving application state, making UI experimentation and debugging faster.',
        ),
      ],
    );
  }
}

class CommonWidgetsPage extends StatefulWidget {
  const CommonWidgetsPage({super.key});

  @override
  State<CommonWidgetsPage> createState() => _CommonWidgetsPageState();
}

class _CommonWidgetsPageState extends State<CommonWidgetsPage> {
  bool _isFavorited = false;
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Display widgets',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.favorite, size: 30),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Text and Icon widgets'),
                ),
                IconButton(
                  icon: Icon(
                    _isFavorited ? Icons.favorite : Icons.favorite_border,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorited = !_isFavorited;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Layout widgets',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Container + Padding + Column'),
              SizedBox(height: 8),
              Text('Row can arrange children horizontally.'),
              Text('Column can arrange children vertically.'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Stack example',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.layers, size: 45),
                  Text('Widgets can overlap in a Stack'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Stateful interaction',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Card(
          child: ListTile(
            title: Text('Counter: $_counter'),
            subtitle: const Text('Uses setState() to rebuild the UI.'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _counter++;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('GestureDetector: tapped!')),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(),
            ),
            child: const Center(
              child: Text('Tap this Container — GestureDetector example'),
            ),
          ),
        ),
      ],
    );
  }
}

class DartBasicsPage extends StatelessWidget {
  const DartBasicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shapes = ['Circle', 'Rectangle', 'Triangle'];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const InfoCard(
          title: 'Variables and type inference',
          icon: Icons.data_object,
          description:
              "Dart is type-safe. Variables can often use var because Dart can infer their types from assigned values.",
        ),
        const SizedBox(height: 12),
        const InfoCard(
          title: 'Null safety',
          icon: Icons.shield_outlined,
          description:
              'A non-nullable value cannot be null unless its type explicitly allows null, such as int?.',
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Loops',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                for (final shape in shapes)
                  ListTile(
                    dense: true,
                    leading: const Icon(Icons.circle_outlined),
                    title: Text(shape),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const InfoCard(
          title: 'Functions',
          icon: Icons.functions,
          description:
              'Dart functions can declare parameter and return types. A single-statement function can use arrow syntax, for example: int add(int x, int y) => x + y;',
        ),
        const SizedBox(height: 12),
        const InfoCard(
          title: 'Async / await',
          icon: Icons.hourglass_empty,
          description:
              'Future, async and await support asynchronous programming and help keep asynchronous code readable.',
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.title,
    required this.description,
    required this.icon,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
