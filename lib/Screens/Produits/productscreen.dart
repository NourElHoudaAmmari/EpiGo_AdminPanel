import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/Screens/Produits/addproduct.dart';
import 'package:epigo_adminpanel/Screens/Produits/editproduct.dart';
import 'package:epigo_adminpanel/Screens/sidebar.dart';
import 'package:epigo_adminpanel/constants.dart';
import 'package:epigo_adminpanel/services/firebase.dart';
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





   void _showProductDetails(String id,String title, String imageUrl, double price,String description,String category,  String unit ,bool availableInStock ,int discount ) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: TextStyle( fontWeight: FontWeight.bold),),
        
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image.network(
                imageUrl,
                width: 400,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
             
            SizedBox(height: 10),
              Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categorie: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5), // Ajustez la largeur selon vos préférences
                Expanded(
                  child: Text(
                    '$category',
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            
             SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '$description',
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
              
                SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prix : ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5), // Ajustez la largeur selon vos préférences
                Expanded(
                  child: Text(
                    '${price.toString()} \dt  $unit ',
                   style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
        Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    if (discount != 0)
      Row(
        children: [
          const Text(
            'Remise :',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$discount %',
            ),
          ),
        ],
      ),
  ],
),


            SizedBox(height: 10),
     Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      'Disponibilité : ',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    SizedBox(width: 5),
    Text(
      availableInStock ? 'En stock' : 'Épuisé',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: availableInStock ? Colors.green : Colors.red,
      ),
    ),
  ],
),

          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProduct(
                          id: id,
        title: title,
        imageUrl: imageUrl,
        price: price,
        description: description,
        category: category,
        unit: unit,
        availableInStock: availableInStock,
        discount: discount,
                        ),
                      ),
                    );
                  },
           child: Text('Modifier'),
           
          ),
      IconButton(icon: Icon(Icons.close, color: Colors.red),  onPressed: () {
              Navigator.of(context).pop();
            },),
        ],
      );
    },
  );
}

    return StreamBuilder<QuerySnapshot>(

      stream: _services.produits.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
         if (snapshot.hasError) {
          return Text('Something went wrong');
        }
         if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
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
                  SizedBox(height: 10),
   
            // Ajoutez la liste déroulante pour filtrer par catégorie
            /*DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              items: <String>['Tous les produits', 'Fruits', 'Légumes', 'Herbes']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),*/
         
                // Zone de recherche
               /* TextField(
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
          Center(
            child: ElevatedButton(onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                         AddProduct(),
                                    ),
                                  );
                                }, 
            child: Text('Ajouter Produit'),
             style: ElevatedButton.styleFrom(primary:greenColor),
            
            ),
          ), 
                           
          Divider(thickness: 2,),
           
            SizedBox(
              //width: 400,
              height: 400,
              child:GridView.builder(
  itemCount: snapshot.data!.docs.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 5,
    childAspectRatio: 1,
  ),
  itemBuilder: (context, index) {
    DocumentSnapshot document = snapshot.data!.docs[index];

    // Ajoutez une condition pour filtrer par catégorie
    if (selectedCategory == 'Tous les produits' || document['category'] == selectedCategory) {
      return Card(
        elevation: 10,
        child: InkWell(
          onTap: () {
            _showProductDetails(
              document['id'],
              document['title'],
              document['imageUrl'],
              document['price'],
              document['description'],
              document['category'],
              document['unit'],
              document['availableInStock'],
              document['discount'],
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
                  style: TextStyle(
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
                  '${document['price'].toString()} dt ${document['unit']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 4),
            ],
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

 