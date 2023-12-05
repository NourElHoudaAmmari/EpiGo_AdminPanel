import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/Screens/Produits/EditProductViewModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:epigo_adminpanel/Screens/Produits/productscreen.dart';
import 'package:epigo_adminpanel/Screens/sidebar.dart';
import 'package:epigo_adminpanel/constants.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class EditProduct extends StatefulWidget {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final String description;
  final String category;
  final String unit;
  final bool availableInStock;
  final int discount;
  final double? prixachat;
  final int? stockQuantity;
  final String fournisseur;
  final int? quantitymin;


  const EditProduct({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.category,
    required this.unit,
    required this.availableInStock,
    required this.discount,
    this.prixachat,
    this.stockQuantity,
    required this.fournisseur, 
   this.quantitymin,
  });

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  
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

   String imageUrl = '';
    Uint8List? _imageBytes;
    String  selectedCategorie="";
    String selectedFournisseur="";
      late bool _availableInStock;
      String selectedUnit = ""; // Set it to one of the available units initially
List<String> availableUnits = ["kg", "botte", "pcs"];
GlobalKey<FormState> _key = GlobalKey();
 late DocumentReference _reference;
  @override
  void initState() {
  
selectedFournisseur = widget.fournisseur;
    imageUrl = widget.imageUrl;
    selectedCategorie= widget.category;
   selectedUnit = widget.unit.isNotEmpty ? widget.unit : availableUnits[0];
     _availableInStock = widget.availableInStock;
    _titleController = TextEditingController(text: widget.title);
    _priceController = TextEditingController(text: widget.price.toStringAsFixed(3));
  _descriptionController = TextEditingController(text: widget.description);
 _imageController= TextEditingController(text: widget.imageUrl) ;
    _unitController = TextEditingController(text: widget.unit);
    _disController = TextEditingController(text: widget.discount.toString());
    _prixachatController = TextEditingController(text: widget.prixachat?.toStringAsFixed(3)) ;
    _stockController = TextEditingController(text: widget.stockQuantity.toString()) ;
 _quantityminController =  TextEditingController(text: widget.quantitymin.toString());

_reference = FirebaseFirestore.instance.collection('products').doc(widget.id);

    super.initState();
  }
void _updateImage() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
  );

  if (result != null && result.files.isNotEmpty) {
    Uint8List bytes = result.files.single.bytes!;
    String imageURL = await uploadImageToFirebaseStorage(bytes);
    setState(() {
      imageUrl = imageURL;
    });
  }
}
late final EditProductViewModel viewModel;
// Function to calculate selling price based on purchase price
  void _calculateSellingPrice() {
    // Assuming you want to add a 30% margin
    double purchasePrice =
        double.tryParse(_prixachatController.text) ?? 0.0;
    double sellingPrice = purchasePrice * 1.3;

    // Update the selling price controller
    _priceController.text = sellingPrice.toStringAsFixed(3);
  }
Future<String> uploadImageToFirebaseStorage(Uint8List bytes) async {
  FirebaseStorage fs = FirebaseStorage.instance;
  int date = DateTime.now().millisecondsSinceEpoch;
  final reference = await fs.ref().child('produits/$date.png');

  // Explicitly set the content type to image/png
  SettableMetadata metadata = SettableMetadata(contentType: 'image/png');
  final uploadTask = reference.putData(bytes, metadata);

  final snapshot = await uploadTask;
  String imageURL = await snapshot.ref.getDownloadURL();
  return imageURL;
}



  @override
  Widget build(BuildContext context) {
      SideBarwidget _sideBar = SideBarwidget();
    return AdminScaffold(
      backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor:Color.fromARGB(255, 216, 189, 154),
            title: const Text('Epi Go Dashboard',style: TextStyle(color:Colors.white,),),
          ),
            sideBar: _sideBar.sideBarMenus(context,ProductScreen.id),
     body: Container(
      width: 700,
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
       child: SingleChildScrollView(
         child: SizedBox(
          width: 500,
           child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                   InkWell(
           onTap: _updateImage,
         child: Center(
           child: Container(
             height: 350,
             width: 350,
             decoration: BoxDecoration(
            border: Border.all(),
             ),
             child: SizedBox(
            height: 100,
            child: imageUrl.isEmpty
                ? Center(
                    child: Text('Ajouter image'),
                  )
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
             ),
           ),
         ),
       ),
       SizedBox(height: 10,),
          Container(
                     width: 600,
                    child:const Text(
          'Titre',
          style: TextStyle(
             color: Colors.black,
            fontSize: 18,fontWeight: FontWeight.bold
          ),
           ),
                  ),
       Container(
         
                     width: 600,
                    child: TextFormField(
                      controller:   _titleController,
                      decoration:
                          InputDecoration(hintText: 'Titre'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return '***champ obligatoire';
                        }
                  
                        return null;
                      },
                    ),
                  ),
                SizedBox(height: 10,),
                Row(
        crossAxisAlignment: CrossAxisAlignment.center,
         children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(12.0)),
              const Text(
                'Catégorie',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Center(
                child: Container(
                 
            
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                   builder: (context, snapshot) {
                        List<DropdownMenuItem<String>> categorieItems = [];
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        } else {
                          final categories = snapshot.data?.docs.reversed.toList();
                          categorieItems.add(
                            const DropdownMenuItem(
                              value: "0",
                              child: Text('Categorie sélectionnée'),
                            ),
                          );
                          for (var category in categories!) {
                            categorieItems.add(DropdownMenuItem(
                              value: category["libelle"],
                              child: Text(
                                category['libelle'],
                              ),
                            ));
                          }
                        }
                        return DropdownButton(
                          items: categorieItems,
                          onChanged: (categorieValue) {
                            setState(() {
                              selectedCategorie = categorieValue as String;
                            });
                            print(categorieValue);
                          },
                          value: selectedCategorie,
                          isExpanded: false,
                        );
                      }
                    
                  ),
                ),
              ),
            ],
          ),
             const SizedBox(width: 70),
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   Padding(padding: EdgeInsets.all(8.0)),
                const Text(
                  'Fournisseur',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                 // width: 290,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('fournisseurs').snapshots(),
                    builder: (context, snapshot) {
            List<DropdownMenuItem<String>> fournisseurItems = [];
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              final fournisseurs = snapshot.data?.docs.reversed.toList();
              fournisseurItems.add(
                const DropdownMenuItem(
                  value: "0",
                  child: Text('Fournisseur sélectionné'),
                ),
              );
              for (var fournisseur in fournisseurs!) {
                fournisseurItems.add(DropdownMenuItem(
                  value: fournisseur["name"],
                  child: Text(
                    fournisseur['name'],
                  ),
                ));
              }
            }
            return DropdownButton(
              items: fournisseurItems,
              onChanged: (fournisseurValue) {
                setState(() {
                  selectedFournisseur = fournisseurValue as String;
                });
              },
              value: selectedFournisseur,
              isExpanded: false,
            );
          },
                  ),
                ),
              ],
            ),
        
          
         ],
       ),
       
              
              SizedBox(height:10.0),
                         Container(
         
                     width: 600,
                    child:const Text(
          'Description',
          style: TextStyle(
             color: Colors.black,
            fontSize: 18,fontWeight: FontWeight.bold
          ),
           ),
                  ),
                         Container(
         width: 600,
         //height: 800,
         child: TextFormField(
           controller: _descriptionController,
           decoration: InputDecoration(
          hintText: 'Description',
           ),
           maxLines: 3, // Set maxLines to 2 for multiline input
           textInputAction: TextInputAction.newline, // Provide newline action
           validator: (String? value) {
          if (value == null || value.isEmpty) {
            return '***champ obligatoire';
          }
          return null;
           },
         ),
       ),
    SizedBox(height:10.0),

                  Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.all(10.0)),
          const  Text(
            'Prix d\'achat',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
  child: Container(
    child: SizedBox(
      width: 250,  // Adjust the width as needed
      child: TextFormField(
        controller:  _prixachatController,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
       keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
         onChanged: (value) {
                              // Trigger the calculation when the purchase price changes
                              _calculateSellingPrice();
                            },
      ),
    ),
  ),
),
        
      ],
    ),
     const SizedBox(width: 70),
 Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.all(12.0)),
          const  Text(
            'Prix de vente',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
  child: Container(
    child: SizedBox(
      width: 250,  // Adjust the width as needed
      child: TextFormField(
        controller: _priceController,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        readOnly: false,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        
      ),
    ),
  ),
),
        
      ],
    ),
  ],
),
if (_key.currentState?.validate() ?? false)
                      const Text(
                        'Le prix d\'achat est obligatoire',
                        style: TextStyle(color: Colors.red),
                      ),
                         SizedBox(height:10.0), 
                         Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.all(10.0)),
          const  Text(
            'Quantité de Stock',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
  child: Container(
    child: SizedBox(
      width: 250,  // Adjust the width as needed
      child: TextFormField(
        controller:  _stockController,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
       keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    ),
  ),
),
        
      ],
    ),
     const SizedBox(width: 70),
 Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.all(12.0)),
          const  Text(
            'Quantité minimale',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
  child: Container(
    child: SizedBox(
      width: 250,  // Adjust the width as needed
      child: TextFormField(
        controller: _quantityminController,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    ),
  ),
),
        
      ],
    ),
  ],
),    
       
                  SizedBox(height:10.0),       
             Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Unité  :',
                          style: TextStyle(
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
         SizedBox(height:10.0),
              
          Container(
          width: 600,
          child: Row(
            children: [
              Text('Disponibilité: '),
              Switch(
                value: _availableInStock, // Use the local variable here
                onChanged: (value) {
                  setState(() {
                    _availableInStock = value;
                  });
                },
              ),
            ],
          ),
           ),
            SizedBox(height:10.0),
         Container(
         
                     width: 600,
                    child:const Text(
          'Remise',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,fontWeight: FontWeight.bold
          ),
           ),
                  ),
       Container(
         width: 600,
         child: TextFormField(
           controller: _disController,
           decoration: InputDecoration(hintText: 'Remise (%)'),
           keyboardType: TextInputType.number,
           validator: (String? value) {
          if (value == null || value.isEmpty) {
            return '***champ obligatoire';
          }
          return null;
           },
         ),
       ),
       
       
              SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Padding(padding: EdgeInsets.all(8.0)),
                  Column(
                    children: [
                      ElevatedButton(
                         onPressed: () async {
                           String title = _titleController.text;
                           String description = _descriptionController.text;
                           String category = selectedCategorie;
                           String unit = selectedUnit;
                           int discount = int.parse(_disController.text);
                           double prixachat = double.parse(_prixachatController.text);
                           double price = double.parse(_priceController.text);
                           bool availableInStock = _availableInStock;
                           int stockQuantity = int.parse(_stockController.text);
                           int quantitymin = int.parse(_quantityminController.text);
                           String fournisseur = selectedFournisseur;
                       
                           // Create the Map of data
                           Map<String, dynamic> dataToUpdate = {
                          'title': title,
                          'description': description,
                          'imageUrl': imageUrl,
                          'category': category,
                          'unit': unit,
                          'discount': discount,
                          'price': price,
                          'availableInStock': availableInStock,
                          'prixachat':prixachat,
                          'quantitymin':quantitymin,
                          'stockQuantity':stockQuantity,
                          'fournisseur':fournisseur

                           };
                           //if (Key.currentState?.validate() ?? false){
                           _reference.update(dataToUpdate);
                          // }
                          ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Produit modifié avec Succés!'),
                          backgroundColor: Colors.green,
                        
                          )
                          );
                           Navigator.pushReplacement(
                           context,
                           MaterialPageRoute(builder: (context) => ProductScreen()),
                         );
                         },        
                      child: Text('Modifier',style: TextStyle(color: Colors.black),),
                        style: ElevatedButton.styleFrom(primary: darkBrownColor),
                      ),
                    ],
                  ),
                    SizedBox(width: 70),
                    Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       ElevatedButton(
         onPressed: () async {
  
                   Navigator.pushReplacement(
                   context,
                   MaterialPageRoute(builder: (context) => ProductScreen()),
                 );
         },        
              child: Text('Annuler',style: TextStyle(color: Colors.black),),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
                    ],
                  )
                ],
              ),
             
            ],
          )
       
       ),
         ),
       ),
     )
);
}
}