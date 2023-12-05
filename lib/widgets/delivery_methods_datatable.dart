

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/services/firebase.dart';
import 'package:flutter/material.dart';

class DeliveryMethodsDataTable extends StatelessWidget {
  const DeliveryMethodsDataTable({super.key});

  @override
  Widget build(BuildContext context) {
     FirebaseServices _services = FirebaseServices();
    return StreamBuilder(
      stream: _services.deliveryMethods.orderBy('name', descending: true).snapshots(),
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
              DataColumn(label: Text('image')),
              DataColumn(label: Text('Nom')),
             DataColumn(label: Text('Nombre de jours')),
             
            ],
            // details
            rows: _vendorDetailsRows(snapshot.data, _services),
             columnSpacing: 495, // Add space between columns
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
DataCell(
     SizedBox(
        width: 40,  // Set the desired width
        height: 40,  // Set the desired height
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),  // Optional: Set border radius
          child: Image.network(
            document['imgUrl'].toString(),
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
    DataCell(Text(document['name'].toString())),
  DataCell(Text('${document['days'].toString()} jours')),
  
  ];
  }
}