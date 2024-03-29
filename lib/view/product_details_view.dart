import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  static const platform = MethodChannel("AndroidChannel");

  void showToast() async {
    try {
      await platform.invokeMethod(
          "showToast", {"message": "You have bought the product"});
    } on PlatformException catch (e) {
      print("Failed to show toast: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              // Displaying additional images from the product's images list
              if (widget.product.images.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: widget.product.images.map((image) {
                    return Image.network(
                      image,
                      height: 130,
                      width: 114,
                      fit: BoxFit.contain,
                    );
                  }).toList(),
                ),
              SizedBox(height: 16),
              Text(
                '${widget.product.title}',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Price: \$${widget.product.price}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text('Description: ${widget.product.description}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
              SizedBox(height: 16),
              // Adding the Buy Now button
              Center(
                child: ElevatedButton(
                  onPressed: showToast,
                  //onPressed: () {  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text('Buy Now',
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
