import 'package:eff_task/utils/generic_text.dart';
import 'package:flutter/material.dart';

class ExploreScreenAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const ExploreScreenAppBar({
    super.key,
  });

  @override
  State<ExploreScreenAppBar> createState() => _ExploreScreenAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ExploreScreenAppBarState extends State<ExploreScreenAppBar> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8)),
              child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: const Icon(
                        Icons.search,
                        size: 25,
                      ),
                    ),
                    hintText: searchText,
                  )),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          const SizedBox(
            child: Icon(Icons.filter_list),
          )
        ],
      ),
    );
  }
}
