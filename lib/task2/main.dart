import 'package:flutter/material.dart';

void main() {
  runApp(const BmiCalculatorApp());
}

/// Root widget for Task 2.
///
/// This is a StatelessWidget because the application itself does not need
/// to store changing values. The changing BMI form values live inside
/// [BmiCalculatorPage].
class BmiCalculatorApp extends StatelessWidget {
  const BmiCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(
        // The reference application uses a dark blue/purple visual style.
        scaffoldBackgroundColor: const Color(0xFF17244D),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF72007D),
          brightness: Brightness.dark,
        ),
        useMaterial3: false,
      ),
      home: const BmiCalculatorPage(),
    );
  }
}

/// The calculator is Stateful because gender, height, weight and age can all
/// change while the user is interacting with the screen.
class BmiCalculatorPage extends StatefulWidget {
  const BmiCalculatorPage({super.key});

  @override
  State<BmiCalculatorPage> createState() => _BmiCalculatorPageState();
}

class _BmiCalculatorPageState extends State<BmiCalculatorPage> {
  // The selected gender is stored as an enum instead of a magic number.
  Gender _selectedGender = Gender.male;

  // Height is represented as centimeters, matching the reference screen.
  double _height = 176;

  int _weight = 60;
  int _age = 23;

  /// Calculates BMI from weight in kilograms and height in meters.
  double get _bmi => _weight / ((_height / 100) * (_height / 100));

  /// Opens a small result dialog when CALCULATE is pressed.
  void _calculateBmi() {
    final bmi = _bmi;

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('BMI RESULT'),
          content: Text(
            'Your BMI is ${bmi.toStringAsFixed(1)}.',
            style: const TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar is the top purple area containing the screen title.
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'BMI CALCULATOR',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF72007D),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Expanded makes the calculator area consume the available
            // vertical space while keeping the CALCULATE button at the bottom.
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    _buildGenderRow(),
                    const SizedBox(height: 8),
                    _buildHeightCard(),
                    const SizedBox(height: 8),
                    _buildWeightAgeRow(),
                  ],
                ),
              ),
            ),

            // A separate button section matches the large purple button in
            // the reference image.
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _calculateBmi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF72007D),
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text(
                  'CALCULATE',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the MALE and FEMALE selection cards.
  ///
  /// Row is used because the two cards need to sit beside each other.
  Widget _buildGenderRow() {
    return Row(
      children: [
        Expanded(
          child: _GenderCard(
            icon: Icons.male,
            label: 'MALE',
            selected: _selectedGender == Gender.male,
            onTap: () {
              setState(() {
                _selectedGender = Gender.male;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _GenderCard(
            icon: Icons.female,
            label: 'FEMALE',
            selected: _selectedGender == Gender.female,
            onTap: () {
              setState(() {
                _selectedGender = Gender.female;
              });
            },
          ),
        ),
      ],
    );
  }

  /// Builds the height section containing the value and Slider.
  Widget _buildHeightCard() {
    return _CalculatorCard(
      child: Column(
        children: [
          const Text(
            'HEIGHT',
            style: TextStyle(fontSize: 10),
          ),
          Text(
            '${_height.round()} cm',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Slider(
            min: 100,
            max: 220,
            value: _height,
            activeColor: const Color(0xFFE91E63),
            inactiveColor: Colors.white54,
            onChanged: (value) {
              // Slider gives us a new value continuously. setState rebuilds
              // the Text above so the displayed height changes immediately.
              setState(() {
                _height = value;
              });
            },
          ),
        ],
      ),
    );
  }

  /// Builds the WEIGHT and AGE cards side by side.
  Widget _buildWeightAgeRow() {
    return Row(
      children: [
        Expanded(
          child: _NumberCard(
            title: 'WEIGHT',
            value: _weight,
            onDecrease: () {
              setState(() {
                if (_weight > 1) _weight--;
              });
            },
            onIncrease: () {
              setState(() {
                _weight++;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _NumberCard(
            title: 'AGE',
            value: _age,
            onDecrease: () {
              setState(() {
                if (_age > 1) _age--;
              });
            },
            onIncrease: () {
              setState(() {
                _age++;
              });
            },
          ),
        ),
      ],
    );
  }
}

enum Gender { male, female }

/// Reusable card used for MALE and FEMALE.
class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // GestureDetector turns the whole card into a tappable area.
      onTap: onTap,
      child: _CalculatorCard(
        selected: selected,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 44, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable card for numeric values such as weight and age.
class _NumberCard extends StatelessWidget {
  const _NumberCard({
    required this.title,
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
  });

  final String title;
  final int value;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return _CalculatorCard(
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 10),
          ),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _RoundButton(
                icon: Icons.remove,
                onPressed: onDecrease,
              ),
              const SizedBox(width: 8),
              _RoundButton(
                icon: Icons.add,
                onPressed: onIncrease,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small circular +/- button reused by weight and age.
class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF30427A),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }
}

/// Shared visual container for calculator sections.
class _CalculatorCard extends StatelessWidget {
  const _CalculatorCard({
    required this.child,
    this.selected = false,
  });

  final Widget child;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF243461)
            : const Color(0xFF202F61),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(child: child),
    );
  }
}
