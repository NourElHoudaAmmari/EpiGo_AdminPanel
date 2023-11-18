import 'package:epigo_adminpanel/Screens/Produits/productscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:epigo_adminpanel/Controllers/search_controller.dart';

class SearchProduct extends StatelessWidget {
  SearchProduct({super.key});
  var searchController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        (() => Padding(
              padding: const EdgeInsets.all(20),
              child: searchController.products.isNotEmpty
                  ? GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1 / 1.3,
                      children: List.generate(
                        searchController.products.length,
                        (index) {
                          return ProductScreen(
                            
                          //  product: searchController.products[index],
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text('No Products',),
                    ),
            )),
      ),
    );
  }
}