import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_nxtpe_flutter/view/product_list_view.dart';
import 'package:task_nxtpe_flutter/view_model/product_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductListViewModel(),
      child: MaterialApp(
        title: 'Product List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ProductListScreen(),
      ),
    );
  }
}
