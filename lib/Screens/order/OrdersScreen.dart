import 'package:epigo_adminpanel/Controllers/order_controller.dart';
import 'package:epigo_adminpanel/Screens/order/OrdersStatus.dart';
import 'package:epigo_adminpanel/Screens/sidebar.dart';
import 'package:epigo_adminpanel/services/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:get/get.dart';

class OrdersScreen extends StatefulWidget {
  static const String id = 'order-screen';
  @override
  State<OrdersScreen> createState() =>_OrdersScreenState();
}
 class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    Get.put(OrderController());
     SideBarwidget _sideBar = SideBarwidget();
    return AdminScaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 216, 189, 154),
        title: const Text('Epi Go Dashboard',style: TextStyle(color:Colors.white,),),
      ),
    
       sideBar: _sideBar.sideBarMenus(context,OrdersScreen.id),
      
      body:LayoutBuilder(
       builder: (context, constraints) {
          return  DefaultTabController(
            length: 3,
            child: Scaffold(
                body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Liste des commandes', style: Styles.headLineStyle1),
                  //Gap(AppLayout.getHeight(10)),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: TabBar(
                      indicatorColor: Styles.orangeColor,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Styles.primaryColor,
                      tabs: const [
                        Tab(text: 'En train de préparer'),
                        Tab(text: 'En Expédition'),
                        Tab(text: 'Livrée'),
                      ],
                    ),
                  ),
                  const Expanded(
                      child: TabBarView(
                    children: [
                      OrdersStatus(status: 'En préparation'),
                      OrdersStatus(status: 'En expédition'),
                      OrdersStatus(status: 'Livrée'),
                    ],
                  ))
                ],
              ),
            )),
          );
        
     
  }
      ),
    );
  }
}