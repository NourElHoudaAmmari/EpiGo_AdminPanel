

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/Modeles/Fournisseurs.dart';
import 'package:epigo_adminpanel/Screens/sidebar.dart';
import 'package:epigo_adminpanel/constants.dart';
import 'package:epigo_adminpanel/services/fournisseur_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class AddFournisseurScreen extends StatefulWidget {
  const AddFournisseurScreen({Key? key}) : super(key: key);

  
  @override
  _AddFournisseurScreenState createState() => _AddFournisseurScreenState();
}

class _AddFournisseurScreenState extends State<AddFournisseurScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  void _addFournisseur() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Fournisseur newFournisseur = Fournisseur(
      id: '', // Leave it empty as Firestore will generate a unique ID
      accVerified: null, // You may set this based on your requirements
      name: nameController.text,
      email: emailController.text,
      address: addressController.text,
      mobile: mobileController.text,
      isTopPicked: null, // You may set this based on your requirements
    );

    await firestore.collection('fournisseurs').add(newFournisseur.toMap());

    // Optionally, you can navigate back to the previous screen or perform other actions.
  }

  @override
  Widget build(BuildContext context) {
    SideBarwidget _sideBar = SideBarwidget();
    return AdminScaffold(
      backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Color.fromARGB(255, 216, 189, 154),
      title: const Text(
        'Epi Go Dashboard',
        style: TextStyle(color: Colors.white),
      ),
    ),
    sideBar: _sideBar.sideBarMenus(context, Fournisseur_Screen.id),
      body: Center(
        child:Container(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child:  Text(
                      'Ajouter un fournisseur',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                  ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Adresse'),
                ),
                TextField(
                  controller: mobileController,
                  decoration: InputDecoration(labelText: 'Mobile'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _addFournisseur();
                     Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(builder: (context) => Fournisseur_Screen()),
               );
                     
                  },
                   child: Text('Sauvegarder',style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(primary:primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
