import 'package:flutter/material.dart';
import 'package:vibemix/screens/about_screen.dart';
import 'package:vibemix/screens/home_screen.dart';
import 'package:vibemix/screens/library/library_screen.dart';
import 'package:vibemix/screens/settings/settings_screen.dart';
import 'package:vibemix/utils/color_notifier.dart';
import '../customs/global.dart';

class NavBar extends StatefulWidget {
  bool reset = false;
  NavBar({super.key, required this.reset});
  @override
  State<NavBar> createState() => _NavBarState();
}

List<Widget> data = [
  const HomeScreen(),
  const LibraryScreen(),
  const SettingScreen(),
  const AboutScreen()
];
int index = 0;

class _NavBarState extends State<NavBar> {
  @override
  void initState() {
    AccentNotifier().notifier.addListener(updateAccent);
    if (widget.reset) {
      index = 0;
    }
    super.initState();
  }

  @override
  void dispose() {
    AccentNotifier().notifier.removeListener(updateAccent);
    super.dispose();
  }

  void updateAccent() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data[index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: foreground, width: 2))),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_music_outlined),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info_outline_rounded),
              label: 'About',
            ),
          ],
          currentIndex: index,
          backgroundColor: textPink,
          useLegacyColorScheme: false,
          elevation: 2,
          unselectedLabelStyle: TextStyle(color: background, fontSize: 12),
          unselectedIconTheme: IconThemeData(color: background, size: 20),
          selectedIconTheme: IconThemeData(color: foreground, size: 22),
          selectedLabelStyle: TextStyle(
              color: foreground, fontSize: 12, fontWeight: FontWeight.bold),
          selectedItemColor: foreground,
          unselectedItemColor: background,
          type: BottomNavigationBarType.fixed,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
        ),
      ),
    );
  }
}
