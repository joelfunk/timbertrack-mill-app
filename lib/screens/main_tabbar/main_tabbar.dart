import 'package:flutter/material.dart';

import 'package:timbertrack_mill_app/shared/constants.dart';
import 'package:timbertrack_mill_app/screens/home/home.dart';

class MainTabbar extends StatelessWidget {
  const MainTabbar({super.key});

  static const _mainTabs = [
    HomeScreen(),
  ];

  static final _selectedIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _selectedIndex,
      builder: (context, int selectedIndex, child) {
        return Scaffold(
          body: IndexedStack(
            index: selectedIndex,
            children: _mainTabs,
          ),
          floatingActionButton: Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: () {},
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 2,
            color: AppTheme.bottomAppBarColor,
            child: Container(
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _selectedIndex.value = 0,
                    child: SizedBox(
                      height: 26,
                      child: Icon(
                        Icons.home,
                        size: 30,
                        color:
                            selectedIndex == 0 ? AppTheme.bottomAppBarIconActiveColor : AppTheme.bottomAppBarIconColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectedIndex.value = 1,
                    child: SizedBox(
                      height: 26,
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color:
                            selectedIndex == 1 ? AppTheme.bottomAppBarIconActiveColor : AppTheme.bottomAppBarIconColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectedIndex.value = 2,
                    child: SizedBox(
                      height: 26,
                      child: Icon(
                        Icons.event_note,
                        size: 30,
                        color:
                            selectedIndex == 2 ? AppTheme.bottomAppBarIconActiveColor : AppTheme.bottomAppBarIconColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectedIndex.value = 3,
                    child: SizedBox(
                      height: 26,
                      child: Icon(
                        Icons.people_alt,
                        size: 30,
                        color:
                            selectedIndex == 3 ? AppTheme.bottomAppBarIconActiveColor : AppTheme.bottomAppBarIconColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
