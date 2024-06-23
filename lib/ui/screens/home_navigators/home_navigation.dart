import 'package:eff_task/ui/components/app_bars/common_app_bar.dart';
import 'package:eff_task/ui/components/app_bars/explore_screen_app_bar.dart';
import 'package:eff_task/ui/components/bottom_navigation.dart';
import 'package:eff_task/ui/screens/cart/cart.dart';
import 'package:eff_task/ui/screens/explore/explore.dart';
import 'package:flutter/material.dart';

class HomeNavigatorScreen extends StatefulWidget {
  const HomeNavigatorScreen({
    super.key,
  });

  @override
  State<HomeNavigatorScreen> createState() => _HomeNavigatorScreenState();
}

class _HomeNavigatorScreenState extends State<HomeNavigatorScreen> {
  int currentIndex = 0;

  // onTap function
  void handleNavigators(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<Widget> screens = [
    const ExploreScreen(),
    const CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentIndex == 0
          ? const ExploreScreenAppBar()
          : const AppBarScreen(),
      body: screens[currentIndex],
      bottomNavigationBar: CommonBottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) => handleNavigators(index),
      ),
    );
  }
}
