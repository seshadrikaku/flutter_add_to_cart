import 'dart:convert';

import 'package:eff_task/ui/screens/commo_widgets/common_button.dart';
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

  bool isAddedCart = false;
  int quantity = 0;

  @override
  void initState() {
    super.initState();
    checkIfInCart();
  }

  // Check if the product is already in the cart
  Future<void> checkIfInCart() async {
    final existingProductsJson = await _pref.read(cartProductsText);
    if (existingProductsJson != null && existingProductsJson.isNotEmpty) {
      try {
        var decodedJson = json.decode(existingProductsJson);

        if (decodedJson is List) {
          for (var product in decodedJson) {
            if (product['productId'] == widget.exploreStates.id) {
              setState(() {
                isAddedCart = true;
                quantity = product['quantity'];
              });
              break;
            }
          }
        }
      } catch (e) {
        print('Failed to decode JSON: $e');
      }
    }
  }

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

      // Check if the product is already in the cart
      bool productFound = false;
      for (var product in productList) {
        if (product['productId'] == productId) {
          product['quantity'] += 1; // Increase quantity if found
          productFound = true;
          setState(() {
            quantity = product['quantity'];
          });
          break;
        }
      }
      if (!productFound) {
        // Add new product to cart
        final newProduct = {
          "productId": productId,
          'imageUrl': imageUrl,
          'title': title,
          'type': type,
          'price': price,
          'quantity': 1, // Initial quantity when adding new product
        };
        productList.add(newProduct);
        setState(() {
          isAddedCart = true;
          quantity = 1; // Set quantity to 1 for new product
        });
      }
      await _pref.save(cartProductsText, productList);
      ShowToastUtil.showToast(msg: addedToCartText);
    } catch (e) {
      print(e);
      ShowToastUtil.showToast(msg: somethingWentWrontText);
    }
  }

  //Decrease product quantity
  Future<void> deleteQuantity() async {
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

      // Remove the product from the cart
      productList.removeWhere(
          (product) => product['productId'] == widget.exploreStates.id);

      await _pref.save(cartProductsText, productList);
      setState(() {
        isAddedCart = false;
        quantity = 0;
      });
      ShowToastUtil.showToast(msg: removedToCartText);
    } catch (e) {
      print(e);
      ShowToastUtil.showToast(msg: somethingWentWrontText);
    }
  }

  // Decrease local quantity
  void decreaseQuantity() {
    setState(() {
      quantity -= 1;
    });
    updateQuantityInPref(quantity); // Update quantity in SharedPref
  }

  void increaseQuantity() {
    setState(() {
      quantity += 1;
    });
    updateQuantityInPref(quantity); // Update quantity in SharedPref
  }

  // Update quantity in SharedPref
  Future<void> updateQuantityInPref(int newQuantity) async {
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

      for (var product in productList) {
        if (product['productId'] == widget.exploreStates.id) {
          product['quantity'] = newQuantity; // Update quantity
          break;
        }
      }
      await _pref.save(cartProductsText, productList);
    } catch (e) {
      print(e);
      ShowToastUtil.showToast(msg: somethingWentWrontText);
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
                if (!isAddedCart)
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
                        widget.exploreStates.id,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (isAddedCart)
                  Row(
                    children: [
                      quantity == 1
                          ? QuantityButton(
                              icon: Icons.delete,
                              iconColor: Colors.grey,
                              onTap: () {
                                deleteQuantity();
                              })
                          : QuantityButton(
                              icon: Icons.remove,
                              iconColor: Colors.grey,
                              onTap: () {
                                decreaseQuantity();
                              }),
                      const SizedBox(width: 10),
                      Text(quantity.toString()),
                      const SizedBox(width: 10),
                      QuantityButton(
                          icon: Icons.add,
                          iconColor: Colors.green,
                          onTap: () {
                            increaseQuantity();
                          }),
                    ],
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
