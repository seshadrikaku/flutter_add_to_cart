import 'package:flutter/material.dart';

// Common Bottom navigation
// ignore: must_be_immutable
class CommonBottomNavigation extends StatelessWidget {
  int currentIndex;
  final Function(int index) onTap;
  CommonBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 18,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: currentIndex == 0
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey[200]),
                    child:
                        const Icon(Icons.travel_explore, color: Colors.black),
                  )
                : const Icon(
                    Icons.travel_explore_rounded,
                    color: Colors.grey,
                  ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey[200]),
                    child: const Icon(Icons.shopping_cart, color: Colors.black),
                  )
                : const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.grey,
                  ),
            label: "",
          ),
        ],
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
