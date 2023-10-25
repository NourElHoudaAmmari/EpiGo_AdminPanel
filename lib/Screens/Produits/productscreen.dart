import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/Screens/Produits/addproduct.dart';
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
            
            ),
          ),                  
          Divider(thickness: 2,),
           
            SizedBox(
              //width: 400,
              height: 400,
              child:GridView.builder(
  itemCount: snapshot.data!.docs.length,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 5,
    childAspectRatio: 1,
  ),
  itemBuilder: (context, index) {
    DocumentSnapshot document = snapshot.data!.docs[index];
    return Card(
      elevation: 10,
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
              document['price'].toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
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

 