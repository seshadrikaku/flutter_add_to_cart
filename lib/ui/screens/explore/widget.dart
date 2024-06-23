import 'dart:convert';

import 'package:eff_task/data/models/explore_api_response.dart';
import 'package:eff_task/services/storage.dart';
import 'package:eff_task/ui/components/toast_utils.dart';
import 'package:eff_task/utils/generic_text.dart';
import 'package:flutter/material.dart';

class SingleProductWidget extends StatefulWidget {
  final ExploreApiResponseMOdel exploreStates;
  const SingleProductWidget({super.key, required this.exploreStates});

  @override
  State<SingleProductWidget> createState() => _SingleProductWidgetState();
}

class _SingleProductWidgetState extends State<SingleProductWidget> {
  final SharedPref _pref = SharedPref();

// handleToStore method
  Future<void> handleToStore(String imageUrl, String title, String type,
      int price, int productId) async {
    try {
      List<dynamic> productList = [];

      final existingProductsJson = await _pref.read(cartProductsText);

      if (existingProductsJson != null && existingProductsJson.isNotEmpty) {
        try {
          var decodedJson = json.decode(existingProductsJson);

          if (decodedJson is List) {
            productList = decodedJson;
          } else {
            productList = [decodedJson];
          }
        } catch (e) {
          throw Exception('Failed to decode JSON: $e');
        }
      }
      final newProduct = {
        "productId": productId,
        'imageUrl': imageUrl,
        'title': title,
        'type': type,
        'price': price,
      };
      productList.add(newProduct);
      await _pref.save(cartProductsText, productList);
      ShowToastUtil.showToast(msg: "Added to cart");
    } catch (e) {
      print(e);
      ShowToastUtil.showToast(msg: "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1)),
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                height: 80,
                child: Image.network(
                  widget.exploreStates.image,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Text(
                widget.exploreStates.title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              widget.exploreStates.category,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  widget.exploreStates.price.toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.green[300],
                      borderRadius: BorderRadius.circular(15)),
                  child: GestureDetector(
                      onTap: () => handleToStore(
                          widget.exploreStates.image,
                          widget.exploreStates.title,
                          widget.exploreStates.category,
                          widget.exploreStates.price,
                          widget.exploreStates.id),
                      child: const Icon(
                        Icons.add,
                        size: 25,
                        color: Colors.white,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
