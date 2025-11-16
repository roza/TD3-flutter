import 'package:flutter/material.dart';
import 'package:td3/UI/card1.dart';
import 'package:td3/UI/card2.dart';
import 'package:td3/UI/card3.dart';
import 'package:td3/UI/ecran_four.dart';
import 'package:td3/UI/task_form.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> pages = <Widget>[Ecran1(), Ecran2(), Ecran3(), Ecran4()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TD3 App',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TaskForm(), // Mode création
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : const SizedBox.shrink(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).textSelectionTheme.selectionColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Card1'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Card2'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Card3'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
