import 'package:epigo_adminpanel/Modeles/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/services/user_service.dart';
import 'package:get/get.dart';


class UserController extends GetxController {
  final CollectionReference _user= FirebaseFirestore.instance.collection("users");
 Future delete_utilisateur(User user) async{
    await  _user.doc(user.id).delete();

   }
  var users = <User>[].obs;
  var isLoading = true.obs;

void fetchUser() async {
  try {
    isLoading(true);
    var userList = await UserServices().getAll();
    if (userList.isNotEmpty) {
      users.assignAll(userList);
    }
  } catch (e) {
    print(e);
  } finally {
    isLoading(false);
  }
}
/*void blockUser(String userId) {
  // Recherche de l'index de l'utilisateur dans la liste
  final userIndex = users.indexWhere((user) => user.id == userId);
  
  if (userIndex != -1) {
    // Mettre à jour l'état de l'utilisateur dans la liste
    users[userIndex].isBlocked = true;
  }
  
  // Autres opérations nécessaires après le blocage de l'utilisateur
  
  // Mettre à jour l'affichage ou effectuer d'autres actions
  update();
}
void unblockUser(String userId) {
  // Recherche de l'index de l'utilisateur dans la liste
  int userIndex = -1;
  for (int i = 0; i < users.length; i++) {
    if (users[i].id == userId) {
      userIndex = i;
      break;
    }
  }
  
  if (userIndex != -1) {
    // Mettre à jour l'état de l'utilisateur dans la liste
    users[userIndex].isBlocked = false;
  }
  
  // Autres opérations nécessaires après le déblocage de l'utilisateur
  
  // Mettre à jour l'affichage ou effectuer d'autres actions
  update();
}*/
   Future<void> blockUser(String userId) async {
    // Perform necessary operations to block the user
    // For example, update the user's blocked status in the database
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'isBlocked': true});
         // Notify listeners about the changes in the user object
  
  }
   Future<void> unblockUser(String userId) async {
    // Perform necessary operations to block the user
    // For example, update the user's blocked status in the database
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'isBlocked': false});
  }
}