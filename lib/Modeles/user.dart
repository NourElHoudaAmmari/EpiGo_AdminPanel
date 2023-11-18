import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  static const ID = "id";
  static const NAME = "name";
  static const EMAIL = "email";
    static const PHONE = "phone";
    static User? currentUser;

 String? id;
  String? name;
  String? email;
String? phone;
String? address;
final bool isBlocked ;

 User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
   this.isBlocked=false,
  });

  /*User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
      address = json['address'];
       isBlocked = json['isBlocked'];

    
  }*/

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['isBlocked'] = isBlocked;

    return data;
  }

  /*factory User.fromSnapshot(DocumentSnapshot snapshot) {
  final data = snapshot.data();
final name = data!['name'] as String?;
final id = data!['id'] as int?;
final email = data!['email'] as String?;
final phone = data!['phone'] as String?;
  return User(
    name: name,
    id: id,
    email: email,
    phone: phone,
  );
}*/
factory User.fromSnapshot(DocumentSnapshot snapshot) {
  final data = snapshot.data() as Map<String, dynamic>?;
  final name = data?['name'] as String?;
  final email = data?['email'] as String?;
  final id = data?['id'] as String?;
  final phone = data?['phone'] as String?;
  final address = data?['address'] as String?;
  final isBlocked = data?['isBlocked'] as bool?;
 
  return User(
    name: name,
    email: email,
    id: id,
    phone: phone,
    address: address,
  
  );
}
}

