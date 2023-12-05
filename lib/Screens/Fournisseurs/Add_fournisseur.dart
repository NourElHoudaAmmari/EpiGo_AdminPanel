import 'package:epigo_adminpanel/Screens/Fournisseurs/FournisseurViewModel.dart';
import 'package:epigo_adminpanel/services/fournisseur_Screen.dart';
import 'package:epigo_adminpanel/Screens/sidebar.dart';
import 'package:epigo_adminpanel/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class AddFournisseurScreen extends StatefulWidget {
  const AddFournisseurScreen({Key? key}) : super(key: key);

  @override
  _AddFournisseurScreenState createState() => _AddFournisseurScreenState();
}

class _AddFournisseurScreenState extends State<AddFournisseurScreen> {
   final FournisseurViewModel _viewModel = FournisseurViewModel();

  


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
                  controller: _viewModel.nameController,
                  decoration: InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: _viewModel.emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _viewModel.addressController,
                  decoration: InputDecoration(labelText: 'Adresse'),
                ),
                TextField(
                  controller: _viewModel.mobileController,
                  decoration: InputDecoration(labelText: 'Mobile'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
     onPressed: () async {
                    await _viewModel.addFournisseur(
                      name: _viewModel.nameController.text,
                      email: _viewModel.emailController.text,
                      address: _viewModel.addressController.text,
                      mobile: _viewModel.mobileController.text,
                    );
      
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
