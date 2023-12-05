import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epigo_adminpanel/Modeles/order.dart' as epigo_order;
class FirestoreDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteOrder(String id) async {
    await _firestore.collection('orders').doc(id).delete();
  }

Future<void> updateOrder(epigo_order.Order order) async {
    return await _firestore
        .collection('orders')
        .doc(order.id)
        .update(order.toMap());
  }

Stream<List<epigo_order.Order>> getOrdersByStatus(String status) {
  return _firestore
      .collection('orders')
      .where('status', isEqualTo: status)
      .orderBy('date', descending: true) 
      .snapshots()
      .map((QuerySnapshot query) {
        List<epigo_order.Order> retVal = [];
        query.docs.forEach((element) {
          retVal.add(epigo_order.Order.fromDocumentSnapshot(snapshot: element));
        });
        return retVal;
      });
}


  Stream<List<epigo_order.Order>> getAllOrders() {
    return _firestore
        .collection('orders')
        .snapshots()
        .map((QuerySnapshot query) {
      List<epigo_order.Order> retVal = [];
      query.docs.forEach((element) {
        retVal.add(epigo_order.Order.fromDocumentSnapshot(snapshot: element));
      });

      return retVal;
    });
  } 
}