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
   late final TextEditingController _titleController , _priceController,_descriptionController,_unitController, _disController;
     String selectedCategorie="0";
bool _isCategorieSelected = false;
bool _isAvailable = false; 
List<String> availableUnits = ["kg", "la botte", "pcs"];
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
      );
      setState(() {
        imgUrl = downloadUrl;
      });
    } catch (error) {
    }
  }
}

Future<void> addDataToFirestore(String imageUrl, String titre, String category, String description, double price, String units, int qunt, int dis) async {
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
  );

  await firestore.collection('products').doc(id).set(product.toMap());
}

void _clearForm(){
  _priceController.clear();
  _titleController.clear();
  _descriptionController.clear();
  _unitController.clear();
  _disController.clear();
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
      backgroundColor: greenColor,
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
                  const Text(
                    'Ajouter un produit',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
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
                   Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
              Padding(padding: EdgeInsets.all(8.0)),
                      StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                builder: (context,snapshot){
                  List<DropdownMenuItem>categorieItems=[];
                  if(!snapshot.hasData){
            return const CircularProgressIndicator();
                  }else{
            final categories = snapshot.data?.docs.reversed.toList();
            categorieItems.add(
              const DropdownMenuItem(
                value: "0",
                child: Text('Categorie sélectionnée'),
                ),
            );
            for(var categories in categories!){
              categorieItems.add(DropdownMenuItem(
                value:categories["libelle"],
                child:Text(                                                      
               categories['libelle'],
               
                ),
                
                ),
                );
            }
                  }
                  return DropdownButton(
            items: categorieItems,
             onChanged: (categorieValue){
              setState(() {
                selectedCategorie=categorieValue;
                _isCategorieSelected = true;
              });
                  },
                  value: selectedCategorie,
                  isExpanded: false,
                   hint: Text('Sélectionner une catégorie'),
                  );
                  
                }
                
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
                  TextFormField(
                    controller: _priceController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Prix',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le prix est obligatoire';
                      }
                      return null;
                    },
                  ),
                  if (_formKey.currentState?.validate() ?? false)
                  const Text(
            'Le prix est obligatoire',
            style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _disController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
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
              Column(  children: [
                 Text('Unité  :' ,),
              ],),    
        Column(
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
      ],
    );
  }).toList(),
),

const SizedBox(height: 20),
          
                  CheckboxListTile(
            title: Text('Disponible'),
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
                          child: const Text('Sauvegarder'),
                          style: ElevatedButton.styleFrom(primary:darkBrownColor),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(child:
                  ElevatedButton(
                    onPressed: () {
                      
                        _clearForm();
                     
                    },
                    child: const Text('Annuler'),
                    style: ElevatedButton.styleFrom(primary:greenColor),
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