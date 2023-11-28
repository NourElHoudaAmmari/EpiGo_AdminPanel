
import 'package:epigo_adminpanel/Screens/sidebar.dart';
import 'package:epigo_adminpanel/constants.dart';
import 'package:epigo_adminpanel/widgets/delivery_methods_datatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class DeliveryMethods extends StatefulWidget {
    static const String id = 'DeliveryMethods-screen';
  const DeliveryMethods({super.key});

  @override
  State<DeliveryMethods> createState() => _DeliveryMethodsState();
}

class _DeliveryMethodsState extends State<DeliveryMethods> {
  @override
  Widget build(BuildContext context) {
   SideBarwidget _sideBar = SideBarwidget();
    return AdminScaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 216, 189, 154),
            title: const Text('Epi Go Dashboard',style: TextStyle(color:Colors.white,),),
           
        ),
       
          
            sideBar: _sideBar.sideBarMenus(context,  DeliveryMethods.id),
          body: SingleChildScrollView(
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Méthodes de livraisons',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                    ),
                  ),
                  SizedBox(height: 30,), 
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(onPressed: () {
                               
                                }, 
            child: Text('Ajouter',style: TextStyle(color: Colors.black),),
             style: ElevatedButton.styleFrom(primary:primaryColor),
            
            ),
          ), 
                           
         const Divider(thickness: 5,),
      DeliveryMethodsDataTable(),
          Divider(thickness: 5,),

           
        ],
              )
            )
          )
         );
  }
}