import 'package:epigo_adminpanel/Screens/Categories/Category_widget.dart';
import 'package:epigo_adminpanel/Screens/Categories/ajoutercat.dart';
import 'package:epigo_adminpanel/Screens/sidebar.dart';
import 'package:epigo_adminpanel/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';


class CategoryScreen extends StatefulWidget {
static const String id = 'category-screen';
 @override
  State<CategoryScreen> createState() =>_CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {


  @override
 Widget build(BuildContext context) {
    SideBarwidget _sideBar = SideBarwidget();
    
   
   return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: greenColor,
        title: const Text('Epi Go Dashboard',style: TextStyle(color:Colors.white,),),
      ),
        sideBar: _sideBar.sideBarMenus(context,CategoryScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
         padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
            
              SizedBox(height: 30,), 
Center(
  child:   ElevatedButton(onPressed: () {
  
                              Navigator.push(
  
                                context,
  
                                MaterialPageRoute(
  
                                  builder: (context) =>
  
                                     AddEditCategorie(),
  
                                ),
  
                              );
  
                            }, 
  
  child: Text('Ajouter Categorie'),
  
  
  
  ),
),                  
Divider(thickness: 2,),
        SizedBox(height: 30,),
                  CategorieWidget(),
    ],
          )
        )
      )
   );
}

 
}