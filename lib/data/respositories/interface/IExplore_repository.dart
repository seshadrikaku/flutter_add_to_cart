import 'package:eff_task/data/models/explore_api_response.dart';

abstract class IExploreRepository {
  Future<List<ExploreApiResponseMOdel>> getExploreProducts();
}
