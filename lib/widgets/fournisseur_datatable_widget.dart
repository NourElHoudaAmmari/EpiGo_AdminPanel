

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/services/firebase.dart';
import 'package:flutter/material.dart';

class FournisseurDataTable extends StatelessWidget {
  const FournisseurDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return StreamBuilder(
      stream: _services.fournisseurs.orderBy('name', descending: true).snapshots(),
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
            rows: _vendorDetailsRows(snapshot.data, _services),
             columnSpacing: 120, // Add space between columns
          ),
        );
      },
    );
  }

  List<DataRow> _vendorDetailsRows(QuerySnapshot? snapshot, FirebaseServices services) {
    if (snapshot == null || snapshot.docs.isEmpty) {
      // Return an empty list if there is no data
      return [];
    }

    // Assuming you have a function to extract cells from a document
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      List<DataCell> cells = _extractCells(document, services);
      return DataRow(cells: cells);
    }).toList();

    return newList;
  }

  List<DataCell> _extractCells(DocumentSnapshot document, FirebaseServices services) {
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
      DataCell(IconButton(onPressed: () {}, icon: Icon(Icons.remove_red_eye_outlined))),
    ];
  }
}