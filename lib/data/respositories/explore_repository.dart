import 'dart:convert';

import 'package:eff_task/constants/env.dart';
import 'package:eff_task/data/models/explore_api_response.dart';
import 'package:eff_task/data/respositories/interface/IExplore_repository.dart';
import 'package:http/http.dart' as http;

class ExploreRepository implements IExploreRepository {
  @override
  Future<List<ExploreApiResponseMOdel>> getExploreProducts() async {
    try {
      final response = await http.get(Uri.parse(itemsApiUrl));
      if (response != null && response.statusCode == 200) {
        final List<dynamic> exploreProducts = json.decode(response.body);
        final List<ExploreApiResponseMOdel> products = exploreProducts
            .map((product) => ExploreApiResponseMOdel.fromJson(product))
            .toList();
        return products;
      }
    } catch (error) {
      throw Exception(error.toString());
    }
    return [];
  }
}
