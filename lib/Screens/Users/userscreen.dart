

import 'package:epigo_adminpanel/Screens/Users/ClientsTable.dart';
import 'package:epigo_adminpanel/Screens/sidebar.dart';
import 'package:epigo_adminpanel/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});
static const String id = 'user-screen';
  @override
  Widget build(BuildContext context) {
   SideBarwidget _sideBar = SideBarwidget();
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        title: const Text('Epi Go Dashboard',style: TextStyle(color:Colors.white,),),
      ),
      sideBar: _sideBar.sideBarMenus(context,UserScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Utilisateurs',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  color: Colors.black,
                ),
              ),
              Divider(thickness: 2,),
              SizedBox(height: 18,),
                        ClientsTable(),
            ],
          ),

        ),
      ),
    );
  }
}