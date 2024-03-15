import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:task_nxtpe_flutter/model/products_model.dart';
import 'package:task_nxtpe_flutter/view_model/product_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductViewModel productViewModel = ProductViewModel();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      body: ListView(children: [
        SizedBox(
          height: height * .55,
          width: width,
          child: FutureBuilder<ProductsModel>(
            future: productViewModel.fetchProductApi(),
            builder:
                (BuildContext context, AsyncSnapshot<ProductsModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitChasingDots(
                    color: Colors.blue,
                    size: 45,
                  ),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.products!.length,
                  itemBuilder: (context, index) {
                    final product = snapshot.data!.products![index];
                    return Card(
                      child: Column(
                        children: [
                          Text(product.id.toString()),
                        ],
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return Center(
                  child: Text('No data available'),
                );
              }
            },
          ),
        )
      ]),
    );
  }
}
