import 'package:eff_task/ui/screens/explore/shimmers.dart';
import 'package:eff_task/utils/generic_text.dart';
import 'package:flutter/material.dart';
import 'package:eff_task/providers/explore_product_provider.dart';
import 'package:eff_task/providers/explore_product_state.dart';
import 'package:eff_task/ui/screens/explore/widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  late TextEditingController _searchController;
  String _searchText = "";

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    ref.read(exploreStateNotifierProvider.notifier).getExploreDetails();
  }

  void _onSearchChanged() {
    setState(() {
      _searchText = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final exploreStates = ref.watch(exploreStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
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
      ),
      body: _buildListOfExploreItems(exploreStates: exploreStates),
    );
  }

  Widget _buildListOfExploreItems(
      {required ExploreProductsState exploreStates}) {
    if (exploreStates.isLoading) {
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 30.0,
        crossAxisSpacing: 20,
        padding: const EdgeInsets.all(10),
        children: List.generate(10, (index) {
          return buildShimmer();
        }),
      );
    } else if (exploreStates.error != null) {
      return const Center(
        child: Text(somethingWentWrontText),
      );
    } else {
      final filteredProducts = _searchText.isEmpty
          ? exploreStates.exploreApiResponseMOdel
          : exploreStates.exploreApiResponseMOdel
              .where((product) => product.title
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()))
              .toList();

      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        padding: const EdgeInsets.all(10),
        mainAxisSpacing: 30.0,
        children: List.generate(filteredProducts.length, (index) {
          return SingleProductWidget(exploreStates: filteredProducts[index]);
        }),
      );
    }
  }
}
