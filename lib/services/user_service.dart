
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/Modeles/user.dart';
import 'package:epigo_adminpanel/constants.dart';


class UserServices {
  String collection = "users";

  Future<List<User>> getAll() async =>
      firebaseFiretore.collection(collection).get().then((result) {
        List<User> users = [];
        for (DocumentSnapshot user in result.docs) {
         users.add(User.fromSnapshot(user));
        }
        return users;
      });
}