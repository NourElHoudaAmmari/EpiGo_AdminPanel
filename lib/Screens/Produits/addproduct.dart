import 'dart:html';
import 'dart:typed_data';

import 'package:epigo_adminpanel/Screens/Categories/ajoutercat.dart';
import 'package:epigo_adminpanel/Screens/Produits/productscreen.dart';
import 'package:epigo_adminpanel/Screens/sidebar.dart';
import 'package:epigo_adminpanel/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class AddProduct extends StatefulWidget {
     //static const String id = 'product-screen';
  

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
   final _formkey = GlobalKey<FormState>();
   late final TextEditingController _titleController , _priceController;
   File? _pickedImage;
   Uint8List webImage = Uint8List(8);

   @override
   void initState(){
    _priceController = TextEditingController();
    _titleController = TextEditingController();
    super.initState();
   } 

@override
void dispose() {
  if(mounted){
    _priceController.dispose();
    _titleController.dispose();
  }
  super.dispose();
}
/*void _uploadForm()async {}
final isValid = _formkey.currentState!.validate();
FocusScope.of(context).unfocus();

if (isValid) {
  _formkey.currentState!.save();
  if (_pickedImage == null){
    GlobalMethods.errorDialog(
     subtitle : 'zzzzzzzzzzzzzz',context: context 
    );
    return;
  }
  final _uuid = const Uuid().v4();

}*/

void _clearForm(){
  _priceController.clear();
  _titleController.clear();
  setState(() {
    _pickedImage = null ;
    webImage = Uint8List(8);
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
        sideBar: _sideBar.sideBarMenus(context,ProductScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Produits',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            
              SizedBox(height: 30,), 
              Container(
                width: 650,
                color: Colors.grey.shade50,
                padding: const EdgeInsets.all(16),
                margin:const  EdgeInsets.all(16),
                child: Form (
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget> [
                         TextFormField(
        controller: _titleController,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: 'Libelle',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Le libellé est obligatoire';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _titleController,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: 'Libelle',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Le libellé est obligatoire';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _titleController,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: 'Libelle',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Le libellé est obligatoire';
          }
          return null;
        },
      ),
      TextFormField(
        controller: _titleController,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: 'Libelle',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Le libellé est obligatoire';
          }
          return null;
        },
      ),
      //textWidget
                    ],
                    
                    
                    )),
              ),
                  
Divider(thickness: 2,),
        SizedBox(height: 30,),
                  //CategorieWidget(),
    ],
          )
        )
      )
   );
}

 
}