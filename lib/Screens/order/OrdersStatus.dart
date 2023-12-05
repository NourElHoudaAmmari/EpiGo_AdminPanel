import 'package:epigo_adminpanel/Controllers/order_controller.dart';
import 'package:epigo_adminpanel/Modeles/order.dart';
import 'package:epigo_adminpanel/services/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

class OrdersStatus extends StatelessWidget {
  
  const OrdersStatus({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    OrderController orderController = Get.find();
    orderController.getOrdersByStatus(status);
    return Scaffold(
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: ListView.separated(
                      itemCount: orderController.orders.length,
                      separatorBuilder: (context, index) => Gap(50),
                      itemBuilder: ((_, index) {
                        return OrdersList(
                          orderController: orderController,
                          order: orderController.orders[index],
                        );
                      }))),
            ),
          ],
        ),
      ),
    );
  }
}

class OrdersList extends StatelessWidget {
  const OrdersList({
    Key? key,
    required this.orderController,
    required this.order,
  }) : super(key: key);

  final OrderController orderController;
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GFAccordion(
        onToggleCollapsed: (value) {
          orderController.isOpen.value = value;
        },
        expandedTitleBackgroundColor: Colors.white,
        titleBorderRadius: orderController.isOpen.value == true
            ? const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
        contentBorderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        margin: const EdgeInsets.all(0),
        titleChild: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${order.cart!.length} Produits',
                          style: Styles.headLineStyle4),
                       Text('Total: ${order.total!.toStringAsFixed(3)} dt',style: Styles.headLineStyle4,)
                  
                    ],
                  ),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text( DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(order.date.toString())),
                  
                    style: Styles.headLineStyle4,
),

                  Text(order.status.toString(),
                      style: Styles.headLineStyle4
                          .copyWith(color: Styles.orangeColor)),
                ]),
              ],
            ),
          ],
        ),
        contentChild: order.cart!.isNotEmpty
            ? Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: order.cart!.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: Styles.primaryColor),
                    itemBuilder: ((_, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(children: [
                            
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: Center(
                               child: Image.network(
                                     order.cart![index].imageUrl.toString(),
                                    
                                                fit: BoxFit.cover, 
        ),
                              ),
                            ),
                          ]),
                          
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(order.cart![index].title.toString(),
                                    style: Styles.headLineStyle4),
                                Text(
                                   '${order.cart![index].quantity} / ${order.cart![index].unit} * ${order.cart![index].price.toStringAsFixed(3)}\dt',
                                       style: Styles.headLineStyle4,
                                       ),

                              ]),
                          Spacer(),
                          Column(children: [
                            Text(
                               '${(order.cart![index].quantity! * order.cart![index].price).toStringAsFixed(3)}\dt',
                                  style: Styles.headLineStyle4,
                                            ),

                          ]),
              
                        ],
                      );
                    }),
                  ),
                  Divider(color: Styles.primaryColor),
                  Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nom du client :', style: Styles.headLineStyle3,),
                  SizedBox(width: 9), // Ajustez la largeur selon vos préférences
                  Expanded(
                    child:Text(
                        order.user!['name'],
                        style: Styles.headLineStyle4,
                      )
                  ),
                ],
              ),
                SizedBox(height: 10),
                      Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mobile :', style: Styles.headLineStyle3),
                  SizedBox(width: 9), // Ajustez la largeur selon vos préférences
                  Expanded(
                    child:Text(order.user!['phone'].toString(), style: Styles.headLineStyle4),
                  ),
                ],
              ),
               SizedBox(height: 10),
                    Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text('Adresse de livraison :', style: Styles.headLineStyle3),
                  SizedBox(width: 9), 
                 Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: order.deliveryAddress!.map((address) {
        return Text(
          '${address.address},${address.codePostale}, ${address.region}',
          style: Styles.headLineStyle4,
        );
      }).toList(),
    ),
                ],
              ),
                SizedBox(height: 10),

              // Ajoutez ceci dans la partie où vous affichez les détails de la commande dans OrdersList
Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Mode de paiement :', style: Styles.headLineStyle3,),
    SizedBox(width: 9),
    Expanded(
      child: Text(
        order.paymentMethod ?? 'Non spécifié',
        style: Styles.headLineStyle4,
      ),
    ),
  ],
),
 SizedBox(height: 10),
   Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Statut de paiement :', style: Styles.headLineStyle3,),
    SizedBox(width: 9),
    Expanded(
      child: Text(
        order.paymentStatus ?? 'Non spécifié',
        style: Styles.headLineStyle4,
      ),
    ),
  ],
),           
          

                  
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      order.status != 'Livrée'
                          ? RichText(
                              text: TextSpan(
                              style: Styles.headLineStyle4,
                              text: order.status == 'En préparation'
                                  ? 'Confirmer la commande: '
                                  : 'Commande livrée: ',
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      orderController.updateOrder(order);
                                    },
                                  text: 'Confirmer',
                                  style: Styles.headLineStyle4.copyWith(
                                      decoration: TextDecoration.underline,
                                      color: Styles.orangeColor),
                                ),
                              ],
                            ))
                          : Text('Commande livrée',
                              style: Styles.headLineStyle4),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      RichText(
                          text: TextSpan(
                        style: Styles.headLineStyle4,
                        text: 'Annuler et supprimer la commande: ',
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                orderController.deleteOrder(order.id!);
                              },
                            text: 'Annuler ',
                            style: Styles.headLineStyle4.copyWith(
                                decoration: TextDecoration.underline,
                                color: Styles.orangeColor),
                          ),
                        ],
                      )),
                    ],
                  ),
                ],
              )
            : Container(),
      ),
    );
  }
}