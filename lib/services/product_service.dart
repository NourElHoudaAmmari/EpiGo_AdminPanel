import 'package:epigo_adminpanel/Screens/Produits/editproduct.dart';
import 'package:epigo_adminpanel/constants.dart';
import 'package:flutter/material.dart';

class ProductService {
 
  void showProductDetails(  BuildContext context,String id, String title, String imageUrl, double price, double prixachat,String description, String category, String unit, bool availableInStock,int quantitymin , int discount, String fournisseur, int  stockQuantity) {
 
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.network(
                  imageUrl,
                  width: 300,
                  height: 200,
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
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                    'Prix de vente : ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5), // Ajustez la largeur selon vos préférences
                  Expanded(
                    child: Text(
                      '${price.toStringAsFixed(3)} \Dt / $unit',
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
                    'Fournisseur: ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      '$fournisseur',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
                    'Quantité de Stock : ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                   '${stockQuantity.toString()}  / $unit ',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
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
        ),
        actions: [
          ElevatedButton(
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
        prixachat:prixachat,
       stockQuantity:stockQuantity,
       fournisseur:fournisseur,
       quantitymin:quantitymin,
       
                        ),
                      ),
                    );
                  },
           child: Text('Modifier',style: TextStyle(color: Colors.black),),
           style: ButtonStyle(
    backgroundColor: MaterialStateProperty.all(primaryColor), // Couleur de fond
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Rayon de la bordure
        side: BorderSide(color:primaryColor), // Couleur et épaisseur de la bordure
      ),
    ),
  ),
          ),
      TextButton( onPressed: () {
              Navigator.of(context).pop();
            }, child: Text("Fermer",style: TextStyle(color:Colors.black),),),
        ],
      );
    },
  );
}

void checkStockQuantityAlert(BuildContext context,String productName, int stockQuantity, int quantityMin) {
    if (stockQuantity <= quantityMin) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text('La quantité en stock est faible pour $productName!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
}





}
