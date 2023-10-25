import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/Screens/Categories/CategoryScreen.dart';
import 'package:epigo_adminpanel/Screens/sidebar.dart';
import 'package:epigo_adminpanel/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'dart:html' as html;
import 'dart:io' as io;



class AddEditCategorie extends StatefulWidget {
    static const String id = 'categorieEdit-screen';
 

  @override
  State<AddEditCategorie> createState() => _AddEditCategorieState();
}

class _AddEditCategorieState extends State<AddEditCategorie> {
    TextEditingController libelleController = TextEditingController();
    bool _isButtonVisible = true;
   bool _visible = false;
  String imgUrl = '';
  html.File? file;
   @override
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future<void> selectImage() async {
  FileUploadInputElement input = FileUploadInputElement()..accept = 'image/*';
  input.click();
  input.onChange.listen((event) async {
    print("File selected");
    final file = input.files?.first;
  final reader = FileReader();
  reader.readAsDataUrl(file!);
  reader.onLoadEnd.listen((event) async {
  print("File loaded");
  if (file != null) {
    setState(() {
      _visible = true;
      imgUrl = reader.result as String;
      this.file = file ;
      _isButtonVisible = false;
    });
  }
});
  });
 }
  
Future<void> uploadToFirebase() async {
  if (_visible && file != null && libelleController.text.isNotEmpty) {
    try {
      FirebaseStorage fs = FirebaseStorage.instance;
      int date = DateTime.now().millisecondsSinceEpoch;
      var snapshot = await fs.ref().child('categories/$date').putBlob(file!);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      await addDataToFirestore(downloadUrl, libelleController.text);
      setState(() {
        imgUrl = downloadUrl;
      });
    } catch (error) {
    }
  }
}

Future<void> addDataToFirestore(String imageUrl, String libelle) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  await firestore.collection('categories').add({
    'image': imageUrl,
    'libelle': libelle,
  });
 
}

  @override
  Widget build(BuildContext context) {
     SideBarwidget _sideBar = SideBarwidget();
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        title: const Text('Epi Go Dashboard',style: TextStyle(color:Colors.white,),),
      ),
      sideBar: _sideBar.sideBarMenus(context,CategoryScreen.id),
        body: SafeArea(
            child: SingleChildScrollView(
               padding: EdgeInsets.all(44),
          child: Form(
          key: _formKey,
            child: Column(
              children: [
                const Text('Ajouter Catégorie',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                ),
              ),
            
              SizedBox(height: 30,), 
  Container(
  height: 250,
  width: 250,
  decoration: BoxDecoration(
    border: Border.all(),
    color: Colors.grey.shade50,
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (_isButtonVisible)
        TextButton(
          onPressed: () {
            selectImage();
          },
          child: const Text(
            'Ajouter Image',
            style: TextStyle(color: Colors.black),
          ),
        ),
      //SizedBox(height: 10),
      imgUrl.isNotEmpty
          ? Image.network(
              imgUrl,
              fit: BoxFit.cover,
            )
          : Container(),
    ],
  ),
),


          
      SizedBox(
  width: 250,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: libelleController,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          labelText: 'Libelle',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Le libellé est obligatoire';
          }
          return null;
        },
      ),
      if (_formKey.currentState?.validate() ?? false)
        const Text(
          'Le libellé est obligatoire',
          style: TextStyle(color: Colors.red),
        ),
    ],
  ),
),


                         
                   SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 400),
                        child: Row(
                          children: [
                             Container(
                                child: Row(
                                  children: [
                          
         Center(
           child: TextButton(
           child: Text('Sauvegarder'),
           onPressed: () {
             if (_visible) {
               if (file != null) {
                 if (_formKey.currentState?.validate() ?? false) {
            uploadToFirebase();
             Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => CategoryScreen()),
           );
            ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Catégorie ajoutée avec Succées!'),
    backgroundColor: Colors.green,
  ),

);
            
                 } 
                 else {
           
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Veuillez sélectionner une image et remplir le libellé'),
                backgroundColor: Colors.red,
              ),
            );
                 }
               } 
             } else {
               // Show SnackBar if the image is not visible
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(
            content: Text('Veuillez sélectionner une image'),
            backgroundColor: Colors.red,
                 ),
               );
             }
           },
           style: TextButton.styleFrom(
             backgroundColor: Colors.black,
           ),
         ),
         )
                                  ],
                                ),
                              ),
              ])
          
                      )
                    )
            ]),
          )
            )
        )
    );
  }
}