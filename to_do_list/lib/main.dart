import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/db_helper.dart';
import 'AppColors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatefulWidget {
  final SharedPreferences? prefs;

  const MyApp({super.key, this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late SharedPreferences prefs;
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode mode) async {
    await widget.prefs?.setString('theme', mode.name);

    setState(() {
      _themeMode = mode;
    });
  }

  @override
  void initState() {
    super.initState();

    String? savedTheme = widget.prefs?.getString('theme');

    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.name == savedTheme,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Theme Demo',
      //current theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,

        // ✅ Primary color of app
        primaryColor: AppColors.primary,

        // ✅ App-wide color scheme (IMPORTANT in Material 3)
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary, // your main brand color
          brightness: Brightness.light,
        ),

        // ✅ AppBar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
        ),

        // ✅ Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.background,
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: _themeMode,
      // pass change theme function
      home: HomePage(changeTheme: changeTheme),
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(ThemeMode) changeTheme;

  const HomePage({super.key, required this.changeTheme});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> toDo = [];
  DBHelper? dbRef;
  final TextEditingController listItem = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    toDo = await dbRef!.getAllNotes();
    setState(() {

    });
  }

  void addItem(String item) {
    dbRef!.addNote(mTitle: item, isDone: false);
    setState(() {
      listItem.text = "";
    });
    getNotes();
  }

  void removeItem(index) {
    setState(() {
      toDo.removeAt(index);
    });
    print(toDo);
    getNotes();
  }

  void editItem(index, item, isDone) {
    // setState(() {
    //   toDo[index]["text"] = item;
    // });
    dbRef!.updateNote(sNo: index, mTitle: item, isDone: isDone);
    print(toDo);
    getNotes();
  }

  // Function to open the small form dialog
  void _openFormDialog(index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Details"),
          content: TextField(
            controller: listItem,
            decoration: const InputDecoration(
              labelText: "Enter List Item",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate input
                if (listItem.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }
                index < 0
                    ? addItem(listItem.text)
                    : editItem(toDo[index][dbRef!.COLUMN_NOTE_SNO], listItem.text, toDo[index][dbRef!.COLUMN_NOTE_isDone] ==1 ? true : false);

                Navigator.pop(context); // Close dialog
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List App')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: toDo.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      spacing: 5,
                      children: [
                        Checkbox(
                          value: toDo[index]["isDone"] == 1 ? true : false,
                          onChanged: (value) {
                            // setState(() {
                            //   toDo[index]["isDone"] = value;
                            // });
                            editItem(toDo[index][dbRef!.COLUMN_NOTE_SNO], toDo[index][dbRef!.COLUMN_NOTE_TITLE], value!);
                          },
                        ),
                        Text(toDo[index][dbRef!.COLUMN_NOTE_TITLE]),
                        Spacer(),
                        InkWell(
                          child: Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.red.shade900,
                          ),
                          onTap: () {
                            dbRef!.deleteNote(sNo: toDo[index][dbRef!.COLUMN_NOTE_SNO]);
                            getNotes();
                          },
                        ),
                        InkWell(
                          child: Icon(Icons.edit),
                          onTap: () {
                            listItem.text = toDo[index][dbRef!.COLUMN_NOTE_TITLE];
                            _openFormDialog(index);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          listItem.text = "";
          _openFormDialog(-1);
        },
        child: Icon(Icons.add),
      ),
      drawer: Container(
        color: Colors.white,
        width: 150,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => widget.changeTheme(ThemeMode.light),
              child: const Text('Light'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => widget.changeTheme(ThemeMode.dark),
              child: const Text('Dark'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => widget.changeTheme(ThemeMode.system),
              child: const Text('System'),
            ),
          ],
        ),
      ),
    );
  }
}
