import 'package:flutter/material.dart';
import 'package:mini_katalog_app/model/product_model.dart';

class CartScreen extends StatefulWidget {
  final List<ProductModel> cartProducts;

  const CartScreen({super.key, required this.cartProducts});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void removeFromCart(int index) {
    setState(() {
      widget.cartProducts.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Product removed from cart"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: Colors.white,
      ),
      body: widget.cartProducts.isEmpty
          ? const Center(
              child: Text("Your cart is empty", style: TextStyle(fontSize: 16)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = widget.cartProducts[index];

                      return ListTile(
                        leading: Image.network(
                          product.image ?? "",
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                        title: Text(
                          product.title ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "\$${product.price?.toStringAsFixed(2) ?? '0.00'}",
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            removeFromCart(index);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Lorem ipsum is simply dummy text",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Lorem ipsum is simply dummy text"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Text(
                        "Checkout",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
