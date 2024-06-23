import 'package:eff_task/data/models/explore_api_response.dart';

class ExploreProductsState {
  final List<ExploreApiResponseMOdel> exploreApiResponseMOdel;
  final bool isLoading;
  final dynamic error;

  const ExploreProductsState(
      {required this.error,
      required this.exploreApiResponseMOdel,
      required this.isLoading});

  factory ExploreProductsState.loading() => const ExploreProductsState(
      exploreApiResponseMOdel: [], error: null, isLoading: true);

  factory ExploreProductsState.loaded(
          List<ExploreApiResponseMOdel> exploreApiResponseMOdel) =>
      ExploreProductsState(
          exploreApiResponseMOdel: exploreApiResponseMOdel,
          error: null,
          isLoading: false);

  factory ExploreProductsState.error(dynamic error) => ExploreProductsState(
      exploreApiResponseMOdel: [], error: error, isLoading: false);
}
