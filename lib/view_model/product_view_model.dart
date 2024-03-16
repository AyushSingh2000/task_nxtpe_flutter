import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

import '../Enum/product_list_state.dart';
import '../models/product_model.dart';
import '../utils/api_response.dart';

class ProductListViewModel with ChangeNotifier implements TickerProvider {
  late List<Product> _products;
  late List<String> _categories;
  late List<Widget> _tabs;
  late TabController _tabController;
  int _currentPage = 1;
  int _pageSize = 60; // Number of products to load per page
  late ProductListState _state;
  late ApiResponse<List<Product>> _apiResponse;

  ProductListViewModel() {
    _products = [];
    _categories = [];
    _tabs = [];
    _tabController = TabController(length: 0, vsync: this);
    _state = ProductListState.Loading;
    _apiResponse = ApiResponse.loading();
    fetchData();
  }

  List<Product> get products => _products;

  List<String> get categories => _categories;

  List<Widget> get tabs => _tabs;

  TabController get tabController => _tabController;

  ProductListState get state => _state;

  ApiResponse<List<Product>> get apiResponse => _apiResponse;

  @override
  Ticker createTicker(onTick) => Ticker(onTick);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      _state = ProductListState.Loading;
      notifyListeners();

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
        _apiResponse = ApiResponse.completed(_products);
      } else {
        throw Exception('Unexpected data format: $data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      _apiResponse = ApiResponse.error('Error fetching data: $e');
    } finally {
      _state = _getStatusFromApiResponse(_apiResponse);
      notifyListeners();
    }
  }

  ProductListState _getStatusFromApiResponse(ApiResponse response) {
    switch (response.status) {
      case Status.LOADING:
        if (kDebugMode) {
          print("loading");
        }
        return ProductListState.Loading;
      case Status.COMPLETED:
        if (kDebugMode) {
          print("Success");
        }
        return ProductListState.Success;
      case Status.ERROR:
        if (kDebugMode) {
          print("Error");
        }
        return ProductListState.Error;
      default:
        return ProductListState.Error;
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
