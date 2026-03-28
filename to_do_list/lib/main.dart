import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      // ✅ NOW it updates
      home: HomePage(changeTheme: changeTheme),
    );
  }
}

class HomePage extends StatelessWidget {
  final Function(ThemeMode) changeTheme;

  const HomePage({super.key, required this.changeTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Switcher')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => changeTheme(ThemeMode.light),
              child: const Text('Light'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => changeTheme(ThemeMode.dark),
              child: const Text('Dark'),
            ),
          ],
        ),
      ),
    );
  }
}
