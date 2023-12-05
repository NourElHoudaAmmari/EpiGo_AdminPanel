import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/Modeles/Fournisseurs.dart';
import 'package:epigo_adminpanel/services/firebase.dart';
import 'package:flutter/material.dart';

class FournisseurViewModel {

   final FirebaseServices _services = FirebaseServices();

  Stream<QuerySnapshot> get fournisseursStream =>
      _services.fournisseurs.orderBy('name', descending: true).snapshots();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  Future<void> addFournisseur({
    required String name,
    required String email,
    required String address,
    required String mobile,
  }) async {
    Fournisseur newFournisseur = Fournisseur(
      id: '',
      accVerified: true,
      name: name,
      email: email,
      address: address,
      mobile: mobile,
      isTopPicked: true,
    );

    await _firestore.collection('fournisseurs').add(newFournisseur.toMap());
  }
}
