import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices{
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference banners = FirebaseFirestore.instance.collection('banners');
  CollectionReference produits = FirebaseFirestore.instance.collection('products');
  
  Future<QuerySnapshot> getAdminCredentials(){
var result = FirebaseFirestore.instance.collection('Admin').get();
return result;
  }

  

}