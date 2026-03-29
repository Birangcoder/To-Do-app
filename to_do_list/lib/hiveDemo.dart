import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // initalize hive
  await Hive.initFlutter();

  // open the box
  await Hive.openBox('MyBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hive Demo",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box("MyBox");

  void writeData() {
    _myBox.put("name","Birang");
  }

  void readData() {
    print(_myBox.get("name").toString());
  }

  void deleteData() {
    _myBox.delete("name");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            ElevatedButton(onPressed: writeData, child: Text("Write")),
            ElevatedButton(onPressed: readData, child: Text("Read")),
            ElevatedButton(onPressed: deleteData, child: Text("Delete")),
          ],
        ),
      ),
    );
  }
}
