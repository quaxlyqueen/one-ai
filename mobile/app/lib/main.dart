import 'package:app/components/conversation_widget.dart';
import 'package:app/components/settings_widget.dart';
import 'package:app/components/conversations_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

import 'package:app/theme.dart';

final _selectedIndex = ValueNotifier<int>(0);

class MyState with ChangeNotifier {
  int get selectedIndex => _selectedIndex.value;

  set selectedIndex(int value) {
    _selectedIndex.value = value;
    notifyListeners();
  }
}

// This function creates a BottomNavigationBarItem for each page
BottomNavigationBarItem _buildNavigationItem(int index) {
  String label = "";
  IconData iconData = Icons.error;
  switch (index) {
    case 0:
      label = 'Settings';
      iconData = Icons.settings;
      break;
    case 1:
      label = 'Chats';
      iconData = Icons.chat;
      break;
  }
  return BottomNavigationBarItem(
    icon: Icon(iconData),
    label: label,
    backgroundColor: AppTheme.lightest,

  );
}

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final selectedIndexProvider = StateProvider<int>((_) => 1); // Initial state

  // This list holds the pages to navigate between
  static final List<Widget> _pages = [
    const Center(child: SettingsWidget()),
    const Center(child: ConversationsListWidget()),
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    return MaterialApp(
      title: 'One AI',
      home: Scaffold(
        backgroundColor: AppTheme.medium,
        body: _pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppTheme.darkest,
          selectedItemColor: AppTheme.lightest,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          iconSize: 30,

          // Set the number of items to the length of the pages list
          items: List.generate(_pages.length, (index) => _buildNavigationItem(index)),
          currentIndex: selectedIndex,
          onTap: (index) => ref.read(selectedIndexProvider.notifier).state = index,
        ),
      ),
    );
  }
}
