import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductListViewModel with ChangeNotifier implements TickerProvider {
  late List<Product> _products;
  late List<String> _categories;
  late List<Widget> _tabs;
  late TabController _tabController;
  int _currentPage = 1;
  int _pageSize = 60; // Number of products to load per page

  ProductListViewModel() {
    _products = [];
    _categories = [];
    _tabs = [];
    _tabController = TabController(length: 0, vsync: this);
    fetchData();
  }

  List<Product> get products => _products;

  List<String> get categories => _categories;

  List<Widget> get tabs => _tabs;

  TabController get tabController => _tabController;

  @override
  Ticker createTicker(onTick) => Ticker(onTick);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://dummyjson.com/products?page=$_currentPage&limit=$_pageSize'));
      final dynamic data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data.containsKey('products')) {
        final List<dynamic> productList = data['products'];
        final List<Product> newProducts =
            productList.map((json) => Product.fromJson(json)).toList();
        _products.addAll(newProducts);
        _categories =
            _products.map((product) => product.category).toSet().toList();
        _tabs = _categories
            .map((category) => Tab(
                  text: category,
                ))
            .toList();
        if (_tabs.isNotEmpty) {
          _tabController = TabController(length: _tabs.length, vsync: this);
        }
        notifyListeners();
      } else {
        throw Exception('Unexpected data format: $data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error accordingly
    }
  }

  List<Product> getFilteredProducts(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  void loadMoreProducts() {
    _currentPage++;
    fetchData();
  }
}
