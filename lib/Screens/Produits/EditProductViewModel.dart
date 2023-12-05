import 'package:flutter/material.dart';

class EditProductViewModel {
 late TextEditingController  _descriptionController;
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _unitController;
  late TextEditingController  _disController;
  late TextEditingController _imageController;
  late TextEditingController _prixachatController;
  late TextEditingController _stockController;
 late TextEditingController _fournisseurController;
 late TextEditingController _quantityminController;


  // Your business logic goes here

 
  Future<void> updateImage() async {
    
  }

 
// Function to calculate selling price based on purchase price
void calculateSellingPrice() {
  // Assuming you want to add a 30% margin
  double purchasePrice = double.tryParse(_prixachatController.text) ?? 0.0;
  double sellingPrice = purchasePrice * 1.3;

  // Update the selling price controller
  _priceController.text = sellingPrice.toStringAsFixed(3);

  print("Calculating selling price: Purchase Price - $purchasePrice, Selling Price - $sellingPrice");
}


  // Example method for updating data in Firestore
  Future<void> updateProductData() async {
   
  }
}
