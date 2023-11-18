import 'package:epigo_adminpanel/Modeles/product.dart';
import 'package:epigo_adminpanel/services/firebase.dart';
import 'package:get/get.dart';




class SearchController extends GetxController {
  RxString _searchText = ''.obs;
  var products = <Product>[].obs;
  List<Product> get productList => products;
  String get searchText => _searchText.value;
  set searchText(String value) {
    _searchText.value = value;
    searchProduct(value);
    if (_searchText.value == '') {
      products = <Product>[].obs;
    }
  }

  void clearSearchText() {
    _searchText.value = '';
  }

  @override
  void onClose() {
    clearSearchText();
    super.onClose();
  }

  Future searchProduct(String searchText) async {
    products.bindStream(FirebaseServices().searchProduct(searchText));
  }
}