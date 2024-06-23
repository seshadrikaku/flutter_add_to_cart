import 'dart:convert';
import 'package:eff_task/utils/generic_text.dart';
import 'package:flutter/material.dart';
import 'package:eff_task/services/storage.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final SharedPref _pref = SharedPref();
  List<Map<String, dynamic>> allProductList = [];
  Map<int, int> quantityMap = {};

  @override
  void initState() {
    super.initState();
    _loadProductList();
  }

  Future<void> _loadProductList() async {
    final productList = await readProductList();
    setState(() {
      allProductList = productList;
      quantityMap.clear();
      for (var product in allProductList) {
        quantityMap[product['productId']] = 1;
      }
    });
  }

//Read product list details from sharedPref
  Future<List<Map<String, dynamic>>> readProductList() async {
    final jsonString = await _pref.read(cartProductsText);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        var decodedJson = json.decode(jsonString);
        if (decodedJson is List) {
          List<Map<String, dynamic>> productList = [];
          for (var item in decodedJson) {
            if (item is Map<String, dynamic>) {
              productList.add(item);
            } else {
              print('Invalid JSON structure in list item: $item');
            }
          }
          return productList;
        } else {
          print('Unexpected JSON structure: $decodedJson');
        }
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    }
    return [];
  }

//Increase product quantity
  void increaseQuantity(int productId) {
    setState(() {
      quantityMap[productId] = (quantityMap[productId] ?? 1) + 1;
    });
  }

//Decrease product quantity
  void decreaseQuantity(int productId) {
    setState(() {
      if (quantityMap[productId] != null && quantityMap[productId]! > 1) {
        quantityMap[productId] = quantityMap[productId]! - 1;
      }
    });
  }

//CalculateTotalPrice
  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var product in allProductList) {
      int quantity = quantityMap[product['productId']] ?? 1;
      totalPrice += quantity * product['price'];
    }
    return totalPrice;
  }

//Remove product from list
  Future<void> removeProduct(int productId) async {
    List<Map<String, dynamic>> updatedList = List.from(allProductList);
    updatedList.removeWhere((product) => product['productId'] == productId);
    // Save updated list back to SharedPreferences
    await _pref.save(cartProductsText, updatedList);

    setState(() {
      allProductList = updatedList;
      quantityMap.remove(productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Column(
                      children: [
                        _buildCartSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: _buildBuyButton()),
        ],
      ),
    );
  }

//widget for Cart Section
  Widget _buildCartSection() {
    return Column(
      children: List.generate(allProductList.length, (index) {
        final product = allProductList[index];
        final productId = product['productId'];
        final quantity = quantityMap[productId] ?? 1;
        final totalPrice = quantity * product['price'];

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.3)),
            color: Colors.white30,
          ),
          child: Row(
            children: [
              _buildForImage(product['imageUrl']),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product['title'],
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: const Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            removeProduct(productId);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${product['type']}",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        _buildQuantityButton(Icons.remove, Colors.grey, () {
                          decreaseQuantity(productId);
                        }),
                        const SizedBox(width: 10),
                        Text(quantity.toString()),
                        const SizedBox(width: 10),
                        _buildQuantityButton(Icons.add, Colors.green, () {
                          increaseQuantity(productId);
                        }),
                        const Spacer(),
                        Text("Rs ${totalPrice.toString()}"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  //Widget for Image
  Widget _buildForImage(productImageUrl) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(productImageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

//Widget for Qunatity button
  Widget _buildQuantityButton(
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
      ),
    );
  }

//Widget for BuyButton
  Widget _buildBuyButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.green[300],
        borderRadius: BorderRadius.circular(15),
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text(
            buyButtonText,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(4)),
            child: Text(
              'Rs ${calculateTotalPrice().toString()}',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
