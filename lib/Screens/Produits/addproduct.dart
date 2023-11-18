// ignore_for_file: sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:html' as html;
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/Modeles/product.dart';
import 'package:epigo_adminpanel/Screens/Produits/productscreen.dart';
import 'package:epigo_adminpanel/Screens/sidebar.dart';
import 'package:epigo_adminpanel/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class AddProduct extends StatefulWidget {
  
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
    bool _isButtonVisible = true;
   final _formkey = GlobalKey<FormState>();
   late final TextEditingController _titleController , _priceController,_descriptionController,_unitController, _disController,
   _prixachatController,_qteStockController,_fourController;
     String selectedCategorie="0";
     String selectedFournisseur="0";
     bool _isFournisseurSelected=false;
bool _isCategorieSelected = false;
bool _isAvailable = false; 
List<String> availableUnits = ["kg", "botte", "pcs"];
String selectedUnit = ''; 
   bool _visible = false;
  String imgUrl = '';
  html.File? file;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   @override
   void initState(){
    _priceController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
_fourController = TextEditingController();
_prixachatController = TextEditingController();
_qteStockController = TextEditingController();
    _unitController = TextEditingController();
    _disController = TextEditingController();
    super.initState();
   } 

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
  if (_visible && file != null && _titleController.text.isNotEmpty) {
    try {
      FirebaseStorage fs = FirebaseStorage.instance;
      int date = DateTime.now().millisecondsSinceEpoch;
      var snapshot = await fs.ref().child('produits/$date').putBlob(file!);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      double price = double.tryParse(_priceController.text) ?? 0.0;
      double? prixachat = double.tryParse(_prixachatController.text) ?? 0.0;
      int? stockQuantity= int.parse(_qteStockController.text);
      int? qunt = 1;
     int? dis = int.tryParse(_disController.text);

     String units = selectedUnit;

      await addDataToFirestore(
        downloadUrl,
        _titleController.text,
        selectedCategorie,
        _descriptionController.text,
        price,
        units,
        qunt,
        dis!,
        prixachat ,
        stockQuantity!,
      selectedFournisseur,

      );
      setState(() {
        imgUrl = downloadUrl;
      });
    } catch (error) {
    }
  }
}
// Function to calculate selling price based on purchase price
  void _calculateSellingPrice() {
    // Assuming you want to add a 30% margin
    double purchasePrice =
        double.tryParse(_prixachatController.text) ?? 0.0;
    double sellingPrice = purchasePrice * 1.3;

    // Update the selling price controller
    _priceController.text = sellingPrice.toStringAsFixed(2);
  }
Future<void> addDataToFirestore(String imageUrl, String titre, String category, String description, double price, String units, int qunt, int dis, double prixachat,int stockQuantity,String fournisseur) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String id = FirebaseFirestore.instance.collection('products').doc().id;

  Product product = Product (
    id: id,
    availableInStock: _isAvailable,
    imageUrl: imageUrl,
    title: titre,
    category: category,
    description: description,
    price: price,
    unit: units,
    quantity:qunt ,
    discount: dis,
    prixachat: prixachat,
    fournisseur: fournisseur,
    stockQuantity:stockQuantity,
  );

  await firestore.collection('products').doc(id).set(product.toMap());
}

void _clearForm(){
  _priceController.clear();
  _titleController.clear();
  _descriptionController.clear();
  _unitController.clear();
  _disController.clear();
  _fourController.clear();
  _prixachatController.clear();
  _qteStockController.clear();
 //selectedCategorie =_isCategorieSelected;
  setState(() {
   _visible = false;
    imgUrl = '';
    _isButtonVisible = true;
  
  });
}

  @override
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
    sideBar: _sideBar.sideBarMenus(context, ProductScreen.id),
    body: Center(
      child: Container(
        width: 700,
        
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
          
            width: 500,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child:  Text(
                      'Ajouter un produit',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_isButtonVisible)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        selectImage();
                      },
                      child: const Text(
                        'Ajouter une image',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(primary:darkBrownColor),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: _visible
                        ? Image.network(
                            imgUrl,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          )
                        : Container(),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                         border: OutlineInputBorder(),
                      labelText: 'Titre',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le titre est obligatoire';
                      }
                      return null;
                    },
                    
                  ),
                  if (_formKey.currentState?.validate() ?? false)
                  const Text(
            'Le titre est obligatoire',
            style: TextStyle(color: Colors.red),
                  ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Category selection
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.all(8.0)),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                              builder: (context, snapshot) {
                                List<DropdownMenuItem> categorieItems = [];
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                } else {
                                  final categories = snapshot.data?.docs.reversed.toList();
                                  categorieItems.add(
                                    const DropdownMenuItem(
                                      value: "0",
                                      child: Text('Catégorie sélectionnée'),
                                    ),
                                  );
                                  for (var category in categories!) {
                                    categorieItems.add(DropdownMenuItem(
                                      value: category["libelle"],
                                      child: Text(category['libelle']),
                                    ));
                                  }
                                }
                                return DropdownButton(
                                  items: categorieItems,
                                  onChanged: (categorieValue) {
                                    setState(() {
                                      selectedCategorie = categorieValue;
                                      _isCategorieSelected = true;
                                    });
                                  },
                                  value: selectedCategorie,
                                  isExpanded: false,
                                  hint: Text('Sélectionner une catégorie'),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 70), // Adjust the spacing as needed

                        // Supplier selection
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.all(8.0)),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('fournisseurs').snapshots(),
                              builder: (context, snapshot) {
                                List<DropdownMenuItem> fournisseurItems = [];
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                } else {
                                  final fournisseurs = snapshot.data?.docs.reversed.toList();
                                  fournisseurItems.add(
                                    const DropdownMenuItem(
                                      value: "0",
                                      child: Text('Fournisseurs sélectionné'),
                                    ),
                                  );
                                  for (var fournisseur in fournisseurs!) {
                                    fournisseurItems.add(DropdownMenuItem(
                                      value: fournisseur["name"],
                                      child: Text(fournisseur['name']),
                                    ));
                                  }
                                }
                                return DropdownButton(
                                  items: fournisseurItems,
                                  onChanged: (fournisseurValue) {
                                    setState(() {
                                      selectedFournisseur = fournisseurValue;
                                      _isFournisseurSelected = true;
                                    });
                                  },
                                  value: selectedFournisseur,
                                  isExpanded: false,
                                  hint: Text('Sélectionner un Fournisseur'),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
             
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                         border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La description est obligatoire';
                      }
                      return null;
                    },
                  ),
                  if (_formKey.currentState?.validate() ?? false)
                  const Text(
            'La description est obligatoire',
            style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                 Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _prixachatController,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Prix d\'achat',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Le prix d\'achat est obligatoire';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              // Trigger the calculation when the purchase price changes
                              _calculateSellingPrice();
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Prix de vente',
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_formKey.currentState?.validate() ?? false)
                      const Text(
                        'Le prix d\'achat est obligatoire',
                        style: TextStyle(color: Colors.red),
                      ),

                  const SizedBox(height: 20),
                    TextFormField(
                       keyboardType: TextInputType.number,
                    controller: _qteStockController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                         border: OutlineInputBorder(),
                      labelText: 'Quantité en Stock',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'quantite en stock est obligatoire';
                      }
                      return null;
                    },
                  ),
                  if (_formKey.currentState?.validate() ?? false)
                  const Text(
            'quantite en stock est obligatoire',
            style: TextStyle(color: Colors.red),
                  ),
                  
     const SizedBox(height: 20),
                  TextFormField(
                       keyboardType: TextInputType.number,
                    controller: _disController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                         border: OutlineInputBorder(),
                      labelText: 'Remise (%)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Remise est obligatoire';
                      }
                      return null;
                    },
                  ),
                  if (_formKey.currentState?.validate() ?? false)
                  const Text(
            'Remise est obligatoire',
            style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
          Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Unité  :',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Row(
                          children: availableUnits.map((unit) {
                            return Row(
                              children: [
                                Radio(
                                  value: unit,
                                  groupValue: selectedUnit,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedUnit = value.toString();
                                    });
                                  },
                                ),
                                Text(unit),
                                const SizedBox(width: 10),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
const SizedBox(height: 20),
          
                  CheckboxListTile(
                           contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
            title: Text('Disponibilité', style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),),
            value: _isAvailable,
            onChanged: (value) {
              setState(() {
                _isAvailable = value!;
              });
            },
          ),
          
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_visible  ) {
                              if (file != null){
                                if (_formKey.currentState?.validate() ?? false){
                                  uploadToFirebase();
                                    Navigator.pushReplacement(
               context,
               MaterialPageRoute(builder: (context) => ProductScreen()),
             );
              ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produit ajouté avec Succés!'),
              backgroundColor: Colors.green,
            
              )
              );
          
                                }
                                else {
             
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Veuillez sélectionner une image et remplir les champs'),
                  backgroundColor: Colors.red,
                ),
              );
                   }
                              }
                              
                            }
                            else {
                 // Show SnackBar if the image is not visible
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(
              content: Text('Veuillez sélectionner une image'),
              backgroundColor: Colors.red,
                   ),
                 );
               }
                          },
                          child: Text('Sauvegarder',style: TextStyle(color: Colors.black),),
                          style: ElevatedButton.styleFrom(primary:primaryColor),
                        ),
                      ),
                     const SizedBox(width: 20),
                      Expanded(child:
                  TextButton(
                    onPressed: () {
                      
                        _clearForm();
                                              Navigator.pushReplacement(
               context,
               MaterialPageRoute(builder: (context) => ProductScreen()),
             );
                     
                    },
                    child: const Text('Annuler',style: TextStyle(color: Colors.black),),
                    
                  ), )
                    ],
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

}