import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class BottomNavBar extends StatefulWidget {
  final Widget child;
  const BottomNavBar({
    super.key,
    required this.child,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/home.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: widget.child,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: -10,
              blurRadius: 60,
              color: Colors.black.withValues(alpha: .20),
              offset: const Offset(0, 15),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22),
          child: _createBottomNavigationBar(),
        ),
      ),
    );
  }

  Widget _createBottomNavigationBar() {
    return GNav(
      selectedIndex: currentIndex,
      onTabChange: _onTabChangeHandle,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      gap: 5,
      color: Colors.grey[600],
      activeColor: Colors.black,
      rippleColor: Colors.grey[300]!,
      hoverColor: Colors.grey[100]!,
      tabActiveBorder: Border.all(color: Colors.black),
      iconSize: 30,
      textStyle: const TextStyle(fontSize: 20, color: Colors.black),
      tabs: const [
        GButton(
          icon: LineIcons.video,
          text: "Live",
        ),
        GButton(
          icon: LineIcons.photoVideo,
          text: "Gallery",
        ),
        GButton(
          icon: LineIcons.user,
          text: 'Profile',
        )
      ],
    );
  }

  void _onTabChangeHandle(int index) {
    switch (index) {
      case 0:
        context.go(
          "/",
        );
        break;
      case 1:
        context.go(
          "/gallery",
        );
        break;
      case 2:
        context.go(
          "/profile",
        );
        break;
    }
    setState(
      () {
        currentIndex = index;
      },
    );
  }
}
