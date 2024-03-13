import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackerkernel/screens/login_page.dart';
import 'package:hackerkernel/screens/producst/add_product.dart';
import 'package:hackerkernel/services/auth_service.dart';
import 'package:hackerkernel/widgets/custom_text.dart';
import 'package:hackerkernel/widgets/icon_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> products = [];
  late TextEditingController searchController;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _searchProducts(String query) {
    return products.where((product) {
      final productName = product['name'].toString().toLowerCase();
      return productName.contains(query.toLowerCase());
    }).toList();
  }

  void _toggleSearch() {
    setState(() {
      isSearching = !isSearching;
      if (!isSearching) {
        searchController.clear();
        products = _searchProducts('');
      }
    });
  }

  Future<void> _loadProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? productsJson = prefs.getStringList('products');
    if (productsJson != null) {
      setState(() {
        products = productsJson
            .map((productJson) => jsonDecode(productJson))
            .cast<Map<String, dynamic>>()
            .toList();
      });
    }
  }

  Future<void> _deleteProduct(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      products.removeAt(index);
    });
    List<String> updatedProductsJson =
        products.map((product) => jsonEncode(product)).toList();
    await prefs.setStringList('products', updatedProductsJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: <Widget>[
          isSearching
              ? SizedBox(
                  width: 200,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        products = _searchProducts(value);
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : IconButton(
                  onPressed: _toggleSearch,
                  icon: const Icon(Icons.search),
                ),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: StyledIconButton(
              onPressed: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
                await AuthenticationApi.logout();
              },
              icon: Icons.login_outlined,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: "HI-FI Shop & Services",
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            const CustomText(
              text: "Audio shop on Rustaveli Ave 57.",
              color: Colors.grey,
              fontSize: 18,
            ),
            const SizedBox(height: 10),
            const CustomText(
              text: "This shop offers both products & services",
              color: Colors.grey,
              fontSize: 18,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CustomText(
                      text: "Products",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    CustomText(
                      text: products.length.toString(),
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ],
                ),
                const Row(
                  children: [
                    CustomText(
                      text: "Show All",
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            products.isEmpty
                ? const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : Expanded(
                    child: SizedBox(
                      height: 300,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          products.length,
                          (index) {
                            final product = products[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color:
                                            Color.fromARGB(54, 162, 162, 223),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(8),
                                                    ),
                                                    child: Image.memory(
                                                      base64Decode(
                                                          product['image']),
                                                      width: 200,
                                                      height: 150,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                CustomText(
                                                  text: product['name'],
                                                  fontSize: 20,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .only(
                                                    top: 4,
                                                  ),
                                                  child: CustomText(
                                                    text: product['price']
                                                        .toString(),
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 2,
                                        child: IconButton(
                                          onPressed: () {
                                            _deleteProduct(index);
                                          },
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CustomText(
                      text: "Accessories",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    CustomText(
                      text: products.length.toString(),
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ],
                ),
                const Row(
                  children: [
                    CustomText(
                      text: "Show All",
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            products.isEmpty
                ? const Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : Expanded(
                    child: SizedBox(
                      height: 300,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          products.length,
                          (index) {
                            final product = products[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color:
                                            Color.fromARGB(54, 162, 162, 223),
                                        offset: Offset(0, 2),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(8),
                                                    ),
                                                    child: Image.memory(
                                                      base64Decode(
                                                          product['image']),
                                                      width: 200,
                                                      height: 150,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                CustomText(
                                                  text: product['name'],
                                                  fontSize: 20,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 2),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .only(
                                                    top: 4,
                                                  ),
                                                  child: CustomText(
                                                    text: product['price']
                                                        .toString(),
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 2,
                                        child: IconButton(
                                          onPressed: () {
                                            _deleteProduct(index);
                                          },
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            size: 30,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
