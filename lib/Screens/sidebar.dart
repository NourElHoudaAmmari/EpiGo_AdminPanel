import 'package:epigo_adminpanel/Screens/Banners/banner.dart';
import 'package:epigo_adminpanel/Screens/Categories/CategoryScreen.dart';
import 'package:epigo_adminpanel/Screens/HomeScreen.dart';
import 'package:epigo_adminpanel/Screens/Produits/productscreen.dart';
import 'package:epigo_adminpanel/Screens/Users/userscreen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_admin_scaffold/admin_scaffold.dart';
  class SideBarwidget {
    sideBarMenus(context, selectedRoute){
    return SideBar(
      backgroundColor:Colors.grey.shade50,
      activeBackgroundColor: const Color(0xFF8B4513),
      activeIconColor: Colors.white,
      activeTextStyle: const TextStyle(color:Colors.white),
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: HomeScreen.id,
            icon: Icons.dashboard,
          ),
             AdminMenuItem(
            title: 'Produits',
            route: ProductScreen.id,
            icon: Icons.production_quantity_limits,
          ),
          AdminMenuItem(title: 'Parametrage',
          icon: Icons.settings,
          children: [
             AdminMenuItem(
            title: 'Bannières',
            route: BannerScreen.id,
            icon: Icons.image,
          ),
           AdminMenuItem(
            title: 'Categorie',
            route: CategoryScreen.id,
            icon: Icons.category,
          ),
           ]
           ),
           AdminMenuItem(
            title: 'Utilisateurs',
            route: UserScreen.id,
            icon: Icons.supervised_user_circle_sharp,
          ),

        ],
        
        selectedRoute: selectedRoute,
        onSelected: (item) {
          if (item.route != null) {
            Navigator.of(context).pushNamed(item.route!);
          }
        },
        header: Container(
   
          height: 50,
          width: double.infinity,
          color: Colors.grey.shade50,
          child: const Center(
             child: Text(
              'Menu',
              style: TextStyle(
                color: Color(0xFF8B4513),fontStyle:FontStyle.normal,fontSize: 25,
               fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
    footer: Container(
          height: 170,
          width: double.infinity,
          color:Colors.grey.shade50,
          child: Center(
            child: Image.asset("images/logo.png",),
          ),
        ),
      );
  }

  }