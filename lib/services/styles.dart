import 'package:flutter/material.dart';
// access from any ware!!
//Color primary = Colors.blueGrey;

class Styles {
  static Color primaryColor = Colors.blueGrey.shade900;
  static Color secondaryColor = Colors.blueGrey;
  static Color textColor = Colors.blueGrey.shade900;
  static Color bgColor = Colors.grey.shade200;
  static Color whiteColor = Colors.grey.shade200;
  static Color orangeColor = Colors.deepOrangeAccent;
  static Color redColor = Colors.redAccent;

  static TextStyle textStyle =
      TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500);

  static TextStyle headLineStyle1 =
      TextStyle(fontSize: 26, color: textColor, fontWeight: FontWeight.bold);

  static TextStyle headLineStyle2 =
      TextStyle(fontSize: 18, color: textColor, fontWeight: FontWeight.bold);

  static TextStyle headLineStyle3 = TextStyle(
      fontSize: 16, color: secondaryColor, fontWeight: FontWeight.bold);

  static TextStyle headLineStyle4 = TextStyle(
      fontSize: 14, color: secondaryColor, fontWeight: FontWeight.w500);

//   static InputDecoration inputDecoration = InputDecoration(
//     filled: true,
//     fillColor: Colors.white,
//     labelStyle: TextStyle(
//       color: Styles.orangeColor,
//     ),
//     prefixIcon:
//         Icon(Icons.label_important_outline_rounded, color: Styles.orangeColor),
//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide.none,
//     ),
//     errorBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide.none,
//     ),
//     focusedErrorBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide.none,
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide.none,
//     ),
//     labelText: 'Product Name',
//     hintText: 'banana',
//   );
// }

  static InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Styles.secondaryColor),
    ),
  );
  static InputDecoration dropdownDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    prefixIcon: Icon(Icons.functions_outlined, color: Styles.orangeColor),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );
}