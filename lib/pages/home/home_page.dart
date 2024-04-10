import 'package:projectmobile/pages/home/widgets/timetable.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _handleClickButton(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildPageBody() {
      switch (_selectedIndex) {
        case 0:
          return const TimeTable();
        default:
          return const TimeTable();
      }
    }

    return Scaffold(
      body: buildPageBody(),
    );
  }
}
