// ignore_for_file: unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/services/firebase.dart';
import 'package:flutter/material.dart';

class Bannerwidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    return StreamBuilder<QuerySnapshot>(
      stream: _services.banners.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return  Container(
          width: MediaQuery.of(context).size.width,
         height: 250,
          child: new ListView(
            scrollDirection: Axis.horizontal ,
            children:snapshot.data!.docs.map((DocumentSnapshot document) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Stack(
                    children: [
                      SizedBox(
                      height: 200,
                        child: new Card(
                          elevation: 10,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              (document['imageUrl'] as String),
                              width: 350,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: CircleAvatar(backgroundColor:Colors.white,
                          child: IconButton(
                          onPressed: () {
                             showDialog(
                              context: context,
                                   builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Confirmation'),
                                         content: Text('Êtes-vous sûr de vouloir supprimer cette image ?',style: TextStyle(color: Colors.red),),
                                               actions: [
                                                       TextButton(
                                                         onPressed: () {
                                                         Navigator.pop(context); // Fermer l'alerte
                                                                   },
                                                               child: Text('Annuler'),
                                                                   ),
                                                                             TextButton(
                                                                         onPressed: () {
                                                                                 // Supprimer le document de Firestore en utilisant l'ID du document
                                                                                     _services.banners.doc(document.id).delete().then((value) {
                // Si la suppression réussit, vous pouvez ajouter des actions supplémentaires ici
                                                                        print('Image supprimée avec succès!');
                                                                                    }).catchError((error) {
                // En cas d'erreur lors de la suppression
                                                                                       print('Erreur lors de la suppression de l\'image: $error');
                                                                                                   });

                                                                                                     Navigator.pop(context); // Fermer l'alerte après la suppression
                                                                                                                 },
                                                                                                                 child: Text('Confirmer',style: TextStyle(color: Colors.red),),
          ),
        ],
      );
    },
  );
},

                            icon:Icon(Icons.delete,color: Colors.red,) ),))
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
  
}
