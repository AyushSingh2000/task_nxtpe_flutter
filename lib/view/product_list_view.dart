import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_nxtpe_flutter/view/product_details_view.dart';

import '../view_model/product_view_model.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productListViewModel = Provider.of<ProductListViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        bottom: productListViewModel.tabs.isEmpty
            ? null
            : TabBar(
                isScrollable: true,
                tabs: productListViewModel.tabs,
                controller: productListViewModel.tabController,
                labelStyle: GoogleFonts.poppins(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
                unselectedLabelColor: Colors.grey.shade700,
                indicatorColor: Colors.blue.shade700,
              ),
      ),
      body: productListViewModel.tabs.isEmpty
          ? Center(
              child: SpinKitChasingDots(
              color: Colors.blue,
              size: 45,
            ))
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
                  productListViewModel.loadMoreProducts();
                }
                return true;
              },
              child: TabBarView(
                controller: productListViewModel.tabController,
                children: productListViewModel.categories.map((category) {
                  final products =
                      productListViewModel.getFilteredProducts(category);
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to product details screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(
                                product: product,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.network(
                                  product.thumbnail,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.title,
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600)),
                                    Text('Price: \$${product.price}',
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
    );
  }
}
