import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';

import 'package:epigo_adminpanel/Controllers/user_controller.dart';
import 'package:epigo_adminpanel/constants.dart';
import 'package:epigo_adminpanel/services/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ClientsTable extends StatefulWidget {
  const ClientsTable({super.key});

  @override
  State<ClientsTable> createState() => _ClientsTableState();
}

class _ClientsTableState extends State<ClientsTable> {
  late User user;
  bool _isBlocked = false;
  final UserController customersController =
      Get.put(UserController());

  @override
void initState()
  {
    super.initState;
    customersController.fetchUser();
  }
 String getStatusText(bool isBlocked) {
  return isBlocked ? 'Bloqué' : 'Débloqué';
}




  @override
  Widget build(BuildContext context) {
    bool isBlocked = false;
String statusText = getStatusText(isBlocked);
print(statusText); // Affiche "Débloqué"
    var columns = const [
     
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Email')),
      DataColumn(label: Text('Phone')),
       DataColumn(label: Text('Address')),
       DataColumn(label: Text('Etat')),
      DataColumn(label: Text('Actions')),
    ];

    final verticalScrollController = ScrollController();
    final horizontalScrollController = ScrollController();

    return Obx(() => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active.withOpacity(.4), width: .4),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 6),
              color: lightGray.withOpacity(.1),
              blurRadius: 12)
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      child: AdaptiveScrollbar(
        underColor: Colors.blueGrey.withOpacity(0.3),
        sliderDefaultColor: active.withOpacity(0.7),
        sliderActiveColor: active,
        controller: verticalScrollController,
        child: AdaptiveScrollbar(
          controller: horizontalScrollController,
          position: ScrollbarPosition.bottom,
          underColor: lightGray.withOpacity(0.3),
          sliderDefaultColor: active.withOpacity(0.7),
          sliderActiveColor: active,
          width: 13.0,
          sliderHeight: 100.0,
          child: SingleChildScrollView(
            controller: verticalScrollController,
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              controller: horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                customersController.isLoading.value
                    ? const CircularProgressIndicator() :
                 DataTable(
                  columns: columns,
                  rows: List<DataRow>.generate(
                    customersController.users.length,
                    
                    (index){
               final user = customersController.users[index];
     // final isBlocked = user.isBlocked;
                  
                      return DataRow(cells: [
  DataCell(Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    child: CustomText(
      text: customersController.users[index].name.toString(),
    ),
  )),
  DataCell(Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    child: CustomText(
      text: customersController.users[index].email.toString(),
    ),
  )),
  DataCell(Padding(
    padding: EdgeInsets.symmetric(horizontal: 30.0),
    child: CustomText(
      text: customersController.users[index].phone.toString(),
    ),
  )),
  DataCell(Padding(
    padding: EdgeInsets.symmetric(horizontal: 18.0),
    child: CustomText(
      text: customersController.users[index].address.toString(),
    ),
  )),
   DataCell(Padding(
    padding: EdgeInsets.symmetric(horizontal: 18.0),
    child: CustomText(
     text:getStatusText(isBlocked), 
    ),
  )),
     DataCell(Row(children: [
                            IconButton(
                         onPressed: ()async {
   if (!isBlocked) {
       print('users blocked');
     await  customersController.blockUser(user.id!);
     ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(' le Compte utilisateur a éte bloqué avec succés'),
  ),
);
    } 
  },
  icon:const Icon(
   Icons.lock,
   color: Colors.red,
  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.lock_open,color: Colors.green,),
                            onPressed: (){
                              if (isBlocked) {
                      customersController.blockUser(user.id!);
                    } else {
                    print('users unblocked');
                               customersController.unblockUser(user.id!);
                               ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Le compte Utilisateur a été débloqué avec succés'),
  ),
);
                               
                              
                    }
                            },
                            ),
                          ],
                          ),),
]);
                    }
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    )
    );
  }
  
 
}