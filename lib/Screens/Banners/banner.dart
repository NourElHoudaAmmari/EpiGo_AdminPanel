import 'dart:html' as html;  // Renommez la bibliothèque pour éviter les conflits
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/Screens/Banners/banner_widget.dart';
import 'package:epigo_adminpanel/Screens/sidebar.dart';
import 'package:epigo_adminpanel/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'dart:html' as html;



class BannerScreen extends StatefulWidget {
  static const String id = 'banner-screen';
  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
   final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final SideBarwidget _sideBar = SideBarwidget();
  bool _visible = false;
  String imgUrl = '';
html.File? file;

 

 Future<void> selectImage() async {
  print("Select Image called");

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
 // Add this line to store the selected file in the class variable
    });
  }
});
  });
 }
  

Future<void> uploadToFirebase() async {
  if (_visible && file != null) {
    try {
      FirebaseStorage fs = FirebaseStorage.instance;
      int date = DateTime.now().millisecondsSinceEpoch;
      var snapshot = await fs.ref().child('images/$date').putBlob(file!);

      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Download URL: $downloadUrl");
      await addImageUrlToFirestore(downloadUrl);

      setState(() {
        imgUrl = downloadUrl;
      
      });
    } catch (error) {
      print("Error uploading image to Firebase: $error");
    }
  }
}

Future<void> addImageUrlToFirestore(String imageUrl) async {
    // Initialise Firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Ajoute l'URL à la collection "slider" (ou le nom de ta collection Firestore)
    await firestore.collection('banners').add({
      'imageUrl': imageUrl,
      // Ajoute d'autres champs si nécessaire
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: _initialization,  // Set the future to the result of Firebase.initializeApp()
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return AdminScaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: greenColor,
            title: const Text('Epi Go Dashboard', style: TextStyle(color: Colors.white)),
          ),
          sideBar: _sideBar.sideBarMenus(context, BannerScreen.id),
          body: SingleChildScrollView(
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bannières',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                  //Text('Ajouter / Modifier'),
                  Divider(thickness: 5),
                  Bannerwidget(),
                  Divider(thickness: 5),
                      Visibility(
                            visible: _visible,
                     
                         child: Center(
                           child: Container(
                           height: 250,
                           width: 250,
                           decoration: BoxDecoration(
                                 border: Border.all(),
                           ),
                           child: imgUrl.isNotEmpty
                                   ? Image.network(
                                       imgUrl,
                                       fit: BoxFit.cover, // ajustez cela en fonction de vos besoins
                                     )
                                   : Container(), // Si aucune image n'est sélectionnée, afficher un conteneur vide
                               // Si aucune image n'est sélectionnée, afficher un conteneur vide
                              ),
                         ),
                       ),
                  Container(
                    //color: Color.fromARGB(255, 216, 189, 154),
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 450.0),
                      child: Row(
                        children: [
                          Visibility(
                            visible: _visible,
                            child: Container(
                              child: Row(
                                children: [
                                  TextButton(
  child: Text('Upload Image'),
  onPressed: () {
        selectImage(); // Ajoutez cet appel pour déclencher la sélection de l'image
  },
  style: TextButton.styleFrom(
        backgroundColor:Colors.black,
  ),
),
SizedBox(width: 10,),
TextButton(
  child: Text('Save Image'),
  onPressed: () {
        if (_visible) {
          // Assurez-vous que le fichier n'est pas null avant d'uploader
          if (file != null) {
            uploadToFirebase();
          }
        }
  },
  style: TextButton.styleFrom(
        backgroundColor:Colors.black,
  ),
),

                                  SizedBox(width: 10,),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _visible ?false : true,
                            child: TextButton(
                              child: const Text('Ajouter Nouveau  Image',),
                              onPressed: () {
                                setState(() {
                                  _visible = true;
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.black,
                                //textStyle:TextStyle(color: Colors.blueGrey.shade50)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
       return CircularProgressIndicator();
  });

  
  }

 




}
