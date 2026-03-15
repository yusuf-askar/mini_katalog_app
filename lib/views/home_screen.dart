import 'package:flutter/material.dart';
import 'package:mini_katalog_app/components/product_card.dart';
import 'package:mini_katalog_app/model/product_model.dart';
import 'package:mini_katalog_app/services/api_service.dart';
import 'package:mini_katalog_app/views/cart_screen.dart';
import 'package:mini_katalog_app/views/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  List<ProductModel> cartProducts = [];
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      List<ProductModel> resdata = await apiService.fetchProducts();

      setState(() {
        allProducts = resdata;
        filteredProducts = resdata;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts.where((product) {
          final title = product.title?.toLowerCase() ?? '';
          return title.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Discover",
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CartScreen(cartProducts: cartProducts),
                        ),
                      );
                    },
                    iconSize: 32,
                    icon: const Icon(Icons.shopping_bag_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Find your perfect device",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: searchProducts,
                  decoration: const InputDecoration(
                    hintText: "Search products",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://wantapi.com/assets/banner.png",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (isLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (errorMessage.isNotEmpty)
                Expanded(child: Center(child: Text(errorMessage)))
              else
                Expanded(
                  child: filteredProducts.isEmpty
                      ? const Center(
                          child: Text(
                            "No products found",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : GridView.builder(
                          itemCount: filteredProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.65,
                              ),
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      product: product,
                                      cartProducts: cartProducts,
                                    ),
                                  ),
                                );
                              },
                              child: ProductCard(product: product),
                            );
                          },
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
