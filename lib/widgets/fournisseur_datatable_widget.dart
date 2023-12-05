

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/Screens/Fournisseurs/FournisseurViewModel.dart';
import 'package:epigo_adminpanel/services/firebase.dart';
import 'package:flutter/material.dart';

class FournisseurDataTable extends StatelessWidget {
  final FournisseurViewModel viewModel;

  const FournisseurDataTable({required this.viewModel, Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
 
    return StreamBuilder(
      stream: viewModel.fournisseursStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Quelque chose s'est mal passé");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            showBottomBorder: true,
            dataRowHeight: 60,
            headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
            // table headers
            columns: <DataColumn>[
            
              DataColumn(label: Text('Nom')),
          
             DataColumn(label: Text('Adresse')),
              DataColumn(label: Text('Téléphone')),
              DataColumn(label: Text('Email')),
                 DataColumn(label: Text('Notes')),
              DataColumn(label: Text('Voir Détails')),
             
            ],
            // details
            rows: _vendorDetailsRows(snapshot.data, context),
             columnSpacing: 80, // Add space between columns
          ),
        );
      },
    );
  }

  

    List<DataRow> _vendorDetailsRows(
      QuerySnapshot? snapshot, BuildContext context) {
    if (snapshot == null || snapshot.docs.isEmpty) {
      return [];
    }

    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      List<DataCell> cells = _extractCells(document, context);
      return DataRow(cells: cells);
    }).toList();

    return newList;
  }
List<DataCell> _extractCells(DocumentSnapshot document,  BuildContext context) {
   FournisseurViewModel viewModel = this.viewModel;
  return [
    DataCell(Text(document['name'].toString())),
    DataCell(Text(document['address'].toString())),
    DataCell(Text(document['mobile'].toString())),
    DataCell(Text(document['email'].toString())),
    DataCell(Row(
      children: [
        Icon(Icons.star, color: Colors.grey),
        Text('3.5'),
      ],
    )),
    DataCell(IconButton(
      onPressed: () {
        // Affichez les détails dans un dialogue ici
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Détails du fournisseur', style: TextStyle(fontWeight: FontWeight.bold),),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisSize: MainAxisSize.min,
                children: [
                   SizedBox(height: 10),
              Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nom: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5), // Ajustez la largeur selon vos préférences
                Expanded(
                  child: Text(
                     document['name'],
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
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
                const Text(
                  'Adresse: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                //SizedBox(width: 5), // Ajustez la largeur selon vos préférences
                Expanded(
                  child: Text(
                     document['address'],
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
             SizedBox(height: 10),
                 SizedBox(height: 10),
              Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Téléphone: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5), // Ajustez la largeur selon vos préférences
                Expanded(
                  child: Text(
                     document['mobile'].toString(),
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
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
                const Text(
                  'Email: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5), // Ajustez la largeur selon vos préférences
                Expanded(
                  child: Text(
                     document['email'],
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
             SizedBox(height: 10),

                  //Text('Nom: ${document['name']}'),
                 // Text('Adresse: ${document['Adresse']}'),
                 // Text('Téléphone: ${document['mobile']}'),
                  //Text('Email: ${document['email']}'),
                  // Ajoutez d'autres détails si nécessaire
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Ferme le dialogue
                  },
                  child: Text('Fermer'),
                ),
              ],
            );
          },
        );
      },
      icon: Icon(Icons.remove_red_eye_outlined),
    )),
    
   
  ];
}

}