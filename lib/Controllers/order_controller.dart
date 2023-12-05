import 'package:epigo_adminpanel/Modeles/order.dart';
import 'package:epigo_adminpanel/services/firestore_db.dart';
import 'package:epigo_adminpanel/services/styles.dart';
import 'package:get/get.dart';



class OrderController extends GetxController {
  
  final _isLoading = false.obs;
  final _isError = false.obs;
  final _errorMessage = ''.obs;
  bool get isLoading => _isLoading.value;
  bool get isError => _isError.value;
  String get errorMessage => _errorMessage.value;

  var isOpen = false.obs;

  final orders = <Order>[].obs;
  List<Order> get productList => orders;

  final newOrders = {}.obs;
  //List<Order> get orderList => orders;
@override
void onReady() {
  orders.bindStream(FirestoreDB().getOrdersByStatus('en attente'));

}



  Future getOrdersByStatus(String status) async {
    orders.bindStream(FirestoreDB().getOrdersByStatus(status));
  }

  Future deleteOrder(String id) async {
    _isLoading.value = true;
    try {
      FirestoreDB().deleteOrder(id);
    } catch (e) {
      _isError.value = true;
      _errorMessage.value = e.toString();
    } finally {
      _isLoading.value = false;
      Get.snackbar(
        'Deleted order',
        'order is deleted successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Styles.orangeColor,
        colorText: Styles.whiteColor,
        duration: const Duration(seconds: 1),
      );
    }
  }
  Future updateOrder(Order order) async {
  _isLoading.value = true;
  try {
    String newPaymentStatus = order.paymentMethod == 'Payer par carte' ? 'Payé' : 'en attente';

    Order newOrder = Order(
      id: order.id,
      cart: order.cart,
      user: order.user,
      total: order.total,
      status: order.status == 'En préparation' ? 'En expédition' : 'Livrée',
      date: order.date,
      deliveryAddress: order.deliveryAddress,
      deliverymethods: order.deliverymethods,
      paymentMethod: order.paymentMethod,
      paymentStatus: newPaymentStatus,
      deliveryStatus: 'en attente',
    );

    FirestoreDB().updateOrder(newOrder);
  } catch (e) {
    _isError.value = true;
    _errorMessage.value = e.toString();
  } finally {
    _isLoading.value = false;
    Get.snackbar(
      'Updated order',
      'order is updated successfully!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Styles.orangeColor,
      colorText: Styles.whiteColor,
      duration: const Duration(seconds: 1),
    );
  }
}




  
}