// ignore_for_file: sort_child_properties_last, prefer_const_constructors, unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/Screens/Produits/addproduct.dart';
import 'package:epigo_adminpanel/Screens/sidebar.dart';
import 'package:epigo_adminpanel/constants.dart';
import 'package:epigo_adminpanel/services/firebase.dart';
import 'package:epigo_adminpanel/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class ProductScreen extends StatefulWidget {
     static const String id = 'product-screen';
  

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
   
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    SideBarwidget _sideBar = SideBarwidget();
  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'Tous les produits';
  String selectedFournisseur = 'Tous les fournisseurs';
  ProductService productService = ProductService();





    return StreamBuilder<QuerySnapshot>(

      stream: _services.produits.snapshots(),
      
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
         if (snapshot.hasError) {
          return Text("Quelque chose s'est mal passé");
        }
         if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        
 
        return AdminScaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 216, 189, 154),
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
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                  SizedBox(height: 10),
   
            // Ajoutez la liste déroulante pour filtrer par catégorie
            
                // Zone de recherche
               /*TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Rechercher par lettre',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    // Mettez à jour la liste des produits en fonction de la lettre saisie
                    // Vous pouvez utiliser un filtre comme snapshot.data!.docs.where((doc) => doc['title'].startsWith(value.toUpperCase()))
                    // pour filtrer les produits.
                  },
                ),*/

                  SizedBox(height: 30,), 
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                         AddProduct(),
                                    ),
                                  );
                                }, 
            child: Text('Ajouter Produit',style: TextStyle(color: Colors.black),),
             style: ElevatedButton.styleFrom(primary:primaryColor),
            
            ),
          ), 
                           
         const Divider(thickness: 3,),
           
            SizedBox(
            
              height: 430,
              child:GridView.builder(
  itemCount: snapshot.data!.docs.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 5,
    childAspectRatio: 1,

  ),
  itemBuilder: (context, index) {
    DocumentSnapshot document = snapshot.data!.docs[index];

  if (selectedCategory == 'Tous les produits' ||
          document['category'] == selectedCategory) {
        Future.delayed(Duration.zero, () {
        productService.checkStockQuantityAlert(context,document['title'], document['stockQuantity'], document['quantitymin']);

        });
      return Container(
        color: Colors.white,
        child: Card(
          elevation: 10,
          child: Container(
            width: 100,
            height: 150,
            child: InkWell(
              onTap: () {
               productService.showProductDetails(
                context,
                  document['id'],
                  document['title'],
                  document['imageUrl'],
                  document['price'],
                   document['prixachat'],
                  document['description'],
                  document['category'],
                  document['unit'],
                  document['availableInStock'],
                  document['quantitymin'],
                  document['discount'],
                  document['fournisseur'], 
                  document['stockQuantity'],
                 

                );
              },
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        (document['imageUrl'] as String),
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      document['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${document['price'].toStringAsFixed(3)} dt ${document['unit']}',
                      style:const  TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                  ),
                   const SizedBox(height: 4),
               
                 
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(); // Retourne un conteneur vide si la catégorie ne correspond pas
    }
  },
),

     )
                      //CategorieWidget(),
        ],
              )
            )
          )
         );
  });
    
}
}

 