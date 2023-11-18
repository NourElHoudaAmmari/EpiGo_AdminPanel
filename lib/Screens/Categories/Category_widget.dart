import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/services/firebase.dart';
import 'package:flutter/material.dart';


class CategorieWidget extends StatefulWidget {
  @override
  State<CategorieWidget> createState() => _CategorieWidgetState();
}

class _CategorieWidgetState extends State<CategorieWidget> {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    return StreamBuilder<QuerySnapshot>(
      stream: _services.categories.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
            height: 400, 
             child: GridView.builder(
                 gridDelegate:
                 const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, //Number of columns
                      childAspectRatio:2, //Ratio of height to width of each grid item
                    ),
               itemCount: snapshot.data!.docs.length,
                 itemBuilder: (context, index) {
                 DocumentSnapshot document = snapshot.data!.docs[index];

     return Padding(
  padding: const EdgeInsets.all(1),
  child: Stack(
    children: [
      Card(
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            (document['image'] as String),
            width: MediaQuery.of(context).size.width ,
            height: 100,
            fit: BoxFit.fill,
          ),
        ),
      ),
      Positioned(
       bottom: -10,
       left: 5,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            document['libelle'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
     Positioned(
  top: 3,
  //right: 5,
  child: Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.transparent, // Set your desired background color here
    ),
    child: IconButton(
      icon: Icon(Icons.delete, color: Colors.red), // Set icon color
      onPressed: () {
        showDialog(
              context: context,
                builder: (BuildContext context) {
                return AlertDialog(
                title: Text('Confirmation'),
                 content: const Text('Êtes-vous sûr de vouloir supprimer cette categorie ?',style: TextStyle(color: Colors.red),),
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
                     _services.categories.doc(document.id).delete().then((value) {
                // Si la suppression réussit, vous pouvez ajouter des actions supplémentaires ici
                   print('Image supprimée avec succès!');
                      }).catchError((error) {
                // En cas d'erreur lors de la suppression
                print('Erreur lors de la suppression de categorie: $error');
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
    ),
  ),
),

    ],
  ),
);
 },
  ),
  
);

      },
    );
  }
}
