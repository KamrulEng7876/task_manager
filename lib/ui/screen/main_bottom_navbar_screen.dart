import 'package:flutter/material.dart';
import 'package:task_manager/ui/screen/cancelled_task_screen.dart';
import 'package:task_manager/ui/screen/completed_task_screen.dart';
import 'package:task_manager/ui/screen/new_task_screen.dart';
import 'package:task_manager/ui/screen/progress_task_screen.dart';
import 'package:task_manager/ui/utils/app_color.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';


class MainBottomNavbarScreen extends StatefulWidget {
  const MainBottomNavbarScreen({super.key});

  @override
  State<MainBottomNavbarScreen> createState() => _MainBottomNavbarScreenState();
}

class _MainBottomNavbarScreenState extends State<MainBottomNavbarScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screen = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
    ProgressTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: _screen[_selectedIndex],
      bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            _selectedIndex = index;
            setState(() {});
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.new_label), label: 'New'),
            NavigationDestination(
                icon: Icon(Icons.check_box), label: 'Completed'),
            NavigationDestination(icon: Icon(Icons.close), label: 'Cancelled'),
            NavigationDestination(
                icon: Icon(Icons.access_time_outlined), label: 'Progress'),
          ]),
    );
  }
}



