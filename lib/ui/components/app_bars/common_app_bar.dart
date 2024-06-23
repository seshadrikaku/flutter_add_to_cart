import 'package:eff_task/utils/generic_text.dart';
import 'package:flutter/material.dart';

class AppBarScreen extends StatefulWidget implements PreferredSizeWidget {
  const AppBarScreen({
    super.key,
  });

  @override
  State<AppBarScreen> createState() => _AppBarScreenState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarScreenState extends State<AppBarScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey[300],
          height: 1.0,
        ),
      ),
      title: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              child: Text(
            myCartScreenAppBarText,
            style: TextStyle(fontWeight: FontWeight.w600),
          )),
        ],
      ),
    );
  }
}
