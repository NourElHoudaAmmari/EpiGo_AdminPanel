import 'package:epigo_adminpanel/services/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/constants.dart';
import 'package:dim_loading_dialog/dim_loading_dialog.dart';
import 'package:firebase_core/firebase_core.dart';

import 'HomeScreen.dart';
class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';


 

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  
final _formkey = GlobalKey<FormState>();
FirebaseServices _services = FirebaseServices();


String email="";
String password="";
  @override
  Widget build(BuildContext context) {
   DimLoadingDialog dimDialog = DimLoadingDialog(
context,
    blur: 2,
    backgroundColor: const Color(0x33000000),
    animationDuration: const Duration(milliseconds: 500));

Future<void>_login()async{
    
   dimDialog.show();
   _services.getAdminCredentials().then((value){
    value.docs.forEach((doc) async { 
      if(doc.get('email')== email){
        if(doc.get('password')==password){
          UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
        dimDialog.dismiss();
        if(userCredential.user!.uid!=null){
Navigator.pushReplacement(
  context,
   MaterialPageRoute(builder: (BuildContext context)=> HomeScreen()));
   return;
        }else{
          _showMyDialog(
            title: 'Login',
            message: 'Login échoué'

          );
        }
      }else{
        dimDialog.dismiss();
        _showMyDialog(
          title: 'Mot de passe incorrect',
          message: 'Mot de passe saisi est incorrect'
        );
      }
    }else{
      dimDialog.dismiss();
      _showMyDialog(
        title: 'email ivalide',
        message: 'email saisi est incorrect'
      );
    }
      
    });
   });
  }

	
    return Scaffold(
  
      body:FutureBuilder(
        future: _initialization,
        builder: (context,snapshot){
          if(snapshot.hasError){
            return Center(child: Text('Connexion réfusé'),);
          }
          if(snapshot.connectionState == ConnectionState.done){
            return Container (
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
          Color.fromARGB(255, 216, 189, 154)
,
            Colors.white
            ],
            stops: [1.0,1.0],
            begin: Alignment.topCenter,
            end: Alignment(0.0, 0.0)
            ),
        ),
        child: Center(
          child: Container(
            width: 450,
            height: 630,
            child: Card(
              elevation: 6,
              shape: Border.all(color: darkBrownColor,width: 2),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Image.asset('assets/images/logo.png'),
                            Text('EPIGO ADMIN',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: darkBrownColor),),
                            SizedBox(height: 10),
                        TextFormField(
                      
                             cursorColor: brownColor,
                          validator: (value) {
                            if(value!.isEmpty){
                              return 'Veuillez saisir une adresse mail';
                            }
                            setState(() {
                              email = value;
                            });
                          
                            return null;
                          },
                          decoration: const InputDecoration(
                            
                            hintText: 'Adresse email',
                          labelText: 'Adresse email',
                            prefixIcon: Icon(Icons.email_outlined,color: Colors.grey,),
                         contentPadding: EdgeInsets.only(left: 20,right: 20),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                                width: 2
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),

                        TextFormField(
                             cursorColor: kPrimaryColor,
                               validator: (value) {
                            if(value!.isEmpty){
                              return 'Veuillez saisir un mot de passe';
                            }
                            if(value.length<6){
                              return 'Au moins 6 caractéres';
                            }
                            setState(() {
                              password = value;
                            });
                         
                            return null;
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Mot de passe',
                            labelText: 'Mot de passe',
                            prefixIcon: Icon(Icons.lock_outline,color: Colors.grey,),
                            contentPadding: EdgeInsets.only(left: 20,right: 20),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                                width: 2
                              ),
                            ),
                          ),
                        ),
                       
                          ],
                        ),
                      ),
                        SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            child:TextButton(
                            onPressed: ()async{
                              if(_formkey.currentState!.validate()){
                             _login();
                              }
                            },
                             style: ButtonStyle(
                                 minimumSize: MaterialStateProperty.all<Size>(Size(120, 50)),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(greenColor),
                ),
                             child: Text('Se Connecter',style: TextStyle(fontSize: 20),),
                             ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        ),
      
      );
  }
  Future<void> _showMyDialog({title,message}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children:  <Widget>[
              Text(message),
              Text('Veuillez réessayer'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


}
