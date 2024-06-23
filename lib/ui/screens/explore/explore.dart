import 'package:eff_task/providers/explore_product_provider.dart';
import 'package:eff_task/providers/explore_product_state.dart';
import 'package:eff_task/ui/screens/explore/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(exploreStateNotifierProvider.notifier).getExploreDetails();
  }

  @override
  Widget build(BuildContext context) {
    final exploreStates = ref.watch(exploreStateNotifierProvider);

    return Scaffold(
        body: _buildListOfExploreItems(exploreStates: exploreStates));
  }

  Widget _buildListOfExploreItems(
      {required ExploreProductsState exploreStates}) {
    if (exploreStates.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (exploreStates.error != null) {
      return const Center(
        child: Text("Some thing went wrong"),
      );
    } else {
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 30.0,
        children: List.generate(exploreStates.exploreApiResponseMOdel.length,
            (index) {
          return SingleProductWidget(
              exploreStates: exploreStates.exploreApiResponseMOdel[index]);
        }),
      );
    }
  }
}
