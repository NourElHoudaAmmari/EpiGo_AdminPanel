import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/Modeles/delivery_methods.dart';
import 'package:epigo_adminpanel/Modeles/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices{
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference banners = FirebaseFirestore.instance.collection('banners');
  CollectionReference produits = FirebaseFirestore.instance.collection('products');
    CollectionReference fournisseurs = FirebaseFirestore.instance.collection('fournisseurs');
     CollectionReference deliveryMethods = FirebaseFirestore.instance.collection('deliveryMethods');
  Future<QuerySnapshot> getAdminCredentials(){
var result = FirebaseFirestore.instance.collection('Admin').get();
return result;
  }

  
Stream<List<Product>> searchProduct(String searchText) {
    return _firestore
        .collection('products')
        .where('title', isGreaterThanOrEqualTo: searchText.toUpperCase())
        .snapshots()
        .map((QuerySnapshot query) {
      List<Product> retVal = [];
      query.docs.forEach((element) {
        retVal.add(Product.fromDocumentSnapshot(snapshot: element));
      });

      return retVal;
    });
  }
  //vendors
  updateVendorStatus({id,status})async{
    fournisseurs.doc(id).update({
      'accVerified':status?false:true
    });
  }

   Future<void> addDeliveryMethod(DeliveryMethod deliveryMethod) async {
    try {
      await _firestore.collection('deliveryMethods').add(deliveryMethod.toMap());
    } catch (e) {
      print('Error adding delivery method: $e');
      rethrow;
    }
  }

  // Update an existing delivery method
  Future<void> updateDeliveryMethod(DeliveryMethod deliveryMethod) async {
    try {
      await _firestore
          .collection('deliveryMethods')
          .doc(deliveryMethod.id)
          .update(deliveryMethod.toMap());
    } catch (e) {
      print('Error updating delivery method: $e');
      rethrow;
    }
  }

  // Delete a delivery method
  Future<void> deleteDeliveryMethod(String deliveryMethodId) async {
    try {
      await _firestore.collection('deliveryMethods').doc(deliveryMethodId).delete();
    } catch (e) {
      print('Error deleting delivery method: $e');
      rethrow;
    }
  }

  // Stream to get all delivery methods
  Stream<List<DeliveryMethod>> deliveryMethodsStream() {
    return _firestore
        .collection('deliveryMethods')
        .snapshots()
        .map((QuerySnapshot query) {
      List<DeliveryMethod> retVal = [];
      query.docs.forEach((element) {
        retVal.add(DeliveryMethod.fromDocumentSnapshot(element));
      });

      return retVal;
    });
  }
}