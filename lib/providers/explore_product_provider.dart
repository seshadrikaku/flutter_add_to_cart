//ExploreStateNotifier
import 'package:eff_task/data/models/explore_api_response.dart';
import 'package:eff_task/data/respositories/interface/IExplore_repository.dart';
import 'package:eff_task/main.dart';
import 'package:eff_task/providers/explore_product_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExploreStateNotifier extends StateNotifier<ExploreProductsState> {
  final IExploreRepository _exploreRepository;

  ExploreStateNotifier(this._exploreRepository)
      : super(ExploreProductsState.loading());

//Method to Get DashBoard Ihages
  Future<void> getExploreDetails() async {
    try {
      final List<ExploreApiResponseMOdel> exploreDetails =
          await _exploreRepository.getExploreProducts();
      state = ExploreProductsState.loaded(exploreDetails);
    } catch (error) {
      state = ExploreProductsState.error(error.toString());
    }
  }
}

final exploreStateNotifierProvider =
    StateNotifierProvider<ExploreStateNotifier, ExploreProductsState>((ref) {
  final IExploreRepository exploreProducts = getIt<IExploreRepository>();
  return ExploreStateNotifier(exploreProducts);
});
