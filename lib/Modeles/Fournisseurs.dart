import 'package:cloud_firestore/cloud_firestore.dart';

class Fournisseur {
  late String id;
late bool? accVerified;
late String address;
late String name;
late String email;
late bool? isTopPicked;
late String mobile;


 


  Fournisseur({
    required this.id,
   this.accVerified,
   required this.address,
   required this.name,
   required this.email,
   this.isTopPicked,
   required this.mobile,
   
  });

  Fournisseur.fromDocumentSnapshot({required DocumentSnapshot snapshot}) {
    id = snapshot.id;
   accVerified = snapshot['accVerified'];
   address = snapshot['address'];
   name = snapshot['name'];
   email = snapshot['email'];
   isTopPicked = snapshot['isTopPicked'];
   mobile = snapshot['mobile'];
    
  }
  Fournisseur.fromMap(Map<String, dynamic> map) {
    id = map['id'];
   accVerified = map['accVerified'];
   address = map['address'];
   name = map['name'];
   email = map['email'];
   isTopPicked = map['isTopPicked'];
   mobile = map['mobile'];
  
  }
  Map<String, dynamic> toMap() => {
        'id': id,
        'accVerified': accVerified,
        'address': address,
        'name': name,
        'email': email,
        'isTopPicked': isTopPicked,
        'mobile': mobile,
       
      };
}